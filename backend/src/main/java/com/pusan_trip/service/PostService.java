package com.pusan_trip.service;

import com.pusan_trip.domain.Post;
import com.pusan_trip.domain.PostInfo;
import com.pusan_trip.domain.User;
import com.pusan_trip.domain.Region;
import com.pusan_trip.dto.PostRequestDto;
import com.pusan_trip.dto.PostResponseDto;
import com.pusan_trip.dto.CommentRequestDto;
import com.pusan_trip.repository.PostRepository;
import com.pusan_trip.repository.PostInfoRepository;
import com.pusan_trip.repository.UserRepository;
import com.pusan_trip.repository.RegionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PostService {
    private final PostRepository postRepository;
    private final PostInfoRepository postInfoRepository;
    private final UserRepository userRepository;
    private final OpenAIService openAIService;
    private final RegionRepository regionRepository;

    @Transactional
    public Long createPost(PostRequestDto requestDto) {
        // user, region, postinfo 생성 및 저장
        User user = userRepository.findById(requestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Region 객체로 변환
        Region region = null;
        if (requestDto.getRegion() != null && !requestDto.getRegion().isEmpty()) {
            region = regionRepository.findByRegion(requestDto.getRegion())
                    .orElseThrow(() -> new IllegalArgumentException("Region not found"));
        }

        String summary = openAIService.generateSummary(requestDto.getContent());
        Post post = new Post(
            requestDto.getTitle(),
            requestDto.getContent(),
            summary,
            user,
            null,   // PostInfo는 나중에 set
            region  // Region 객체로 전달
            // comments는 없음
        );
      
        PostInfo postInfo = new PostInfo(post, 0, 0);
        post.setPostInfo(postInfo);
        postRepository.save(post);
        postInfoRepository.save(postInfo);
        return post.getId();
    }

    @Transactional(readOnly = true)
    public PostResponseDto getPostById(Long postId) {
        // Post, PostInfo, Comment 조회 및 DTO 변환
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        PostInfo postInfo = post.getPostInfo();
        // 조회수 자동 증가
        if (postInfo != null) {
            postInfo.increaseSeenCount();
        }
        List<CommentRequestDto> comments = post.getComments().stream()
                .map(c -> new CommentRequestDto(c.getId(),  c.getUser().getId(), c.getContent()))
                .collect(Collectors.toList());
        String region = post.getRegion() != null ? post.getRegion().getRegion() : null;
        return new PostResponseDto(
                post.getId(),
                post.getTitle(),
                post.getContent(),
                post.getSummary(),
                post.getCreatedAt(),
                post.getUser().getId(),
                post.getUser().getName(),
                postInfo != null ? postInfo.getLikeCount() : 0,
                postInfo != null ? postInfo.getSeenCount() : 0,
                comments.size(),
                comments,
                region
        );
    }

    @Transactional
    public void updatePost(Long postId, PostRequestDto requestDto) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        post.update(requestDto.getTitle(), requestDto.getContent());
        if (requestDto.getRegion() != null && !requestDto.getRegion().isEmpty()) {
            Region regionEntity = regionRepository.findByRegion(requestDto.getRegion())
                .orElseThrow(() -> new IllegalArgumentException("Region not found"));
            post.setRegion(regionEntity);
        }
    }

    @Transactional(readOnly = true)
    public List<PostResponseDto> getAllPosts() {
        // 목록 조회용 DTO로 반환
        List<Post> posts = postRepository.findAll();
        return posts.stream().map(post -> {
            PostInfo postInfo = post.getPostInfo();
            String region = post.getRegion() != null ? post.getRegion().getRegion() : null;
            return new PostResponseDto(
                    post.getId(),
                    post.getTitle(),
                    post.getContent(),
                    post.getSummary(),
                    post.getCreatedAt(),
                    post.getUser().getId(),
                    post.getUser().getName(),
                    postInfo != null ? postInfo.getLikeCount() : 0,
                    postInfo != null ? postInfo.getSeenCount() : 0,
                    post.getComments().size(),
                    null,
                    region
            );
        }).collect(Collectors.toList());
    }

    @Transactional
    public void deletePost(Long postId) {
        // 글 + 댓글 + PostInfo 제거
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        postRepository.delete(post);
    }

    @Transactional
    public void increaseLikeCount(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        PostInfo postInfo = post.getPostInfo();
        if (postInfo != null) {
            postInfo.increaseLikeCount();
        }
    }

    @Transactional
    public void decreaseLikeCount(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        PostInfo postInfo = post.getPostInfo();
        if (postInfo != null) {
            postInfo.decreaseLikeCount();
        }
    }
}
