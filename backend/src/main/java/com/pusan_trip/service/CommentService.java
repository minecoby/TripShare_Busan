package com.pusan_trip.service;

import com.pusan_trip.domain.Comment;
import com.pusan_trip.domain.User;
import com.pusan_trip.domain.Post;
import com.pusan_trip.dto.CommentRequestDto;
import com.pusan_trip.dto.CommentResponseDto;
import com.pusan_trip.repository.CommentRepository;
import com.pusan_trip.repository.UserRepository;
import com.pusan_trip.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final PostRepository postRepository;

    @Transactional
    public CommentResponseDto createComment(CommentRequestDto requestDto) {
        Post post = postRepository.findById(requestDto.getPostId())
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        User user = userRepository.findByUserId(requestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        Comment comment = new Comment(post, user, requestDto.getContent());
        commentRepository.save(comment);
        return toResponseDto(comment);
    }

    @Transactional
    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }

    private CommentResponseDto toResponseDto(Comment comment) {
        return new CommentResponseDto(
                comment.getId(),
                comment.getPost().getId(),
                comment.getUser().getId(),
                comment.getUser().getName(),
                comment.getUser().getProfileImage(),
                comment.getContent(),
                comment.getCreatedAt()
        );
    }
} 