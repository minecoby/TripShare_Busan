package com.pusan_trip.controller;

import com.pusan_trip.dto.PostRequestDto;
import com.pusan_trip.dto.PostResponseDto;
import com.pusan_trip.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {
    private final PostService postService;

    // 게시글 생성
    @PostMapping
    public ResponseEntity<Long> createPost(@RequestBody PostRequestDto requestDto) {
        Long postId = postService.createPost(requestDto);
        return ResponseEntity.ok(postId);
    }

    // 게시글 단건 조회
    @GetMapping("/{postId}")
    public ResponseEntity<PostResponseDto> getPostById(@PathVariable Long postId) {
        PostResponseDto response = postService.getPostById(postId);
        return ResponseEntity.ok(response);
    }

    // 게시글 전체 목록 조회
    @GetMapping
    public ResponseEntity<List<PostResponseDto>> getAllPosts() {
        List<PostResponseDto> posts = postService.getAllPosts();
        return ResponseEntity.ok(posts);
    }

    // 게시글 수정
    @PutMapping("/{postId}")
    public ResponseEntity<Void> updatePost(@PathVariable Long postId, @RequestBody PostRequestDto requestDto) {
        postService.updatePost(postId, requestDto);
        return ResponseEntity.ok().build();
    }

    // 게시글 삭제
    @DeleteMapping("/{postId}")
    public ResponseEntity<Void> deletePost(@PathVariable Long postId) {
        postService.deletePost(postId);
        return ResponseEntity.ok().build();
    }

    // 조회수 증가
    @PostMapping("/{postId}/seen")
    public ResponseEntity<Void> increaseSeenCount(@PathVariable Long postId) {
        postService.increaseSeenCount(postId);
        return ResponseEntity.ok().build();
    }

    // 좋아요 증가
    @PostMapping("/{postId}/like")
    public ResponseEntity<Void> increaseLikeCount(@PathVariable Long postId) {
        postService.increaseLikeCount(postId);
        return ResponseEntity.ok().build();
    }

    // 좋아요 감소
    @PostMapping("/{postId}/unlike")
    public ResponseEntity<Void> decreaseLikeCount(@PathVariable Long postId) {
        postService.decreaseLikeCount(postId);
        return ResponseEntity.ok().build();
    }
}
