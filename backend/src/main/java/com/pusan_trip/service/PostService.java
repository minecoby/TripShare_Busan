package com.pusan_trip.service;

import com.pusan_trip.domain.Post;
import com.pusan_trip.domain.PostInfo;
import com.pusan_trip.domain.User;
import com.pusan_trip.domain.Region;
import com.pusan_trip.dto.CommentResponseDto;
import com.pusan_trip.dto.PostRequestDto;
import com.pusan_trip.dto.PostResponseDto;
import com.pusan_trip.dto.CommentRequestDto;
import com.pusan_trip.repository.PostRepository;
import com.pusan_trip.repository.PostInfoRepository;
import com.pusan_trip.repository.UserRepository;
import com.pusan_trip.repository.RegionRepository;
import com.pusan_trip.domain.Route;
import com.pusan_trip.domain.RouteLocation;
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
        
        // 루트 생성 (기본 루트)
        Route route = new Route(post);
        post.setRoute(route);
        
        // 기본 지역 3개 추가
        RouteLocation location1 = new RouteLocation("기본 지역 1", "기본 주소 1", null, 1);
        RouteLocation location2 = new RouteLocation("기본 지역 2", "기본 주소 2", null, 2);
        RouteLocation location3 = new RouteLocation("기본 지역 3", "기본 주소 3", null, 3);
        
        route.addRouteLocation(location1);
        route.addRouteLocation(location2);
        route.addRouteLocation(location3);
        
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
        List<CommentResponseDto> comments = post.getComments().stream()
                .map(c -> new CommentResponseDto(
                        c.getId(),
                        c.getPost().getId(),
                        c.getUser().getUserId(),
                        c.getUser().getName(),
                        c.getUser().getProfileImage(),
                        c.getContent(),
                        c.getCreatedAt()
                ))
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
                post.getUser().getProfileImage(),
                postInfo != null ? postInfo.getLikeCount() : 0,
                postInfo != null ? postInfo.getSeenCount() : 0,
                comments.size(),
                comments,
                region,
                post.getRoute() != null ? post.getRoute().getId() : null
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
                    post.getUser().getProfileImage(),
                    postInfo != null ? postInfo.getLikeCount() : 0,
                    postInfo != null ? postInfo.getSeenCount() : 0,
                    post.getComments().size(),
                    null,
                    region,
                    post.getRoute() != null ? post.getRoute().getId() : null
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

    @Transactional(readOnly = true)
    public List<PostResponseDto> getPopularPosts() {
        // 조회수 기준 인기 게시글 5개
        List<Post> popularPosts = postRepository.findTop5ByOrderBySeenCountDesc();
        return popularPosts.stream().map(post -> {
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
                    post.getUser().getProfileImage(),
                    postInfo != null ? postInfo.getLikeCount() : 0,
                    postInfo != null ? postInfo.getSeenCount() : 0,
                    post.getComments().size(),
                    null,
                    region,
                    post.getRoute() != null ? post.getRoute().getId() : null
            );
        }).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PostResponseDto> getRecommendedPosts() {
        // 좋아요 기준 인기 게시글 5개
        List<Post> recommendedPosts = postRepository.findTop5ByOrderByLikeCountDesc();
        return recommendedPosts.stream().map(post -> {
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
                    post.getUser().getProfileImage(),
                    postInfo != null ? postInfo.getLikeCount() : 0,
                    postInfo != null ? postInfo.getSeenCount() : 0,
                    post.getComments().size(),
                    null,
                    region,
                    post.getRoute() != null ? post.getRoute().getId() : null
            );
        }).collect(Collectors.toList());
    }
}
