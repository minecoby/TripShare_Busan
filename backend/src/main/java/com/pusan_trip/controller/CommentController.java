package com.pusan_trip.controller;

import com.pusan_trip.dto.CommentRequestDto;
import com.pusan_trip.dto.CommentResponseDto;
import com.pusan_trip.dto.ApiResponse;
import com.pusan_trip.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class CommentController {
    private static final Logger logger = LoggerFactory.getLogger(CommentController.class);
    private final CommentService commentService;

    // 댓글 생성
    @PostMapping
    public ResponseEntity<ApiResponse<CommentResponseDto>> createComment(@RequestBody CommentRequestDto requestDto) {
        logger.info("댓글 생성 요청 - 게시글 ID: {}, 댓글 내용: {}", requestDto.getPostId(), requestDto.getContent());
        try {
            CommentResponseDto response = commentService.createComment(requestDto);
            logger.info("댓글 생성 성공 - 댓글 ID: {}", response.getId());
            return ResponseEntity.ok(ApiResponse.success("댓글이 성공적으로 등록되었습니다.", response));
        } catch (Exception e) {
            logger.error("댓글 생성 실패 - 게시글 ID: {}, 오류: {}", requestDto.getPostId(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("댓글 등록에 실패했습니다: " + e.getMessage()));
        }
    }

    // 댓글 삭제
    @DeleteMapping("/{commentId}")
    public ResponseEntity<ApiResponse<String>> deleteComment(@PathVariable Long commentId) {
        logger.info("댓글 삭제 요청 - 댓글 ID: {}", commentId);
        try {
            commentService.deleteComment(commentId);
            logger.info("댓글 삭제 성공 - 댓글 ID: {}", commentId);
            return ResponseEntity.ok(ApiResponse.success("댓글이 성공적으로 삭제되었습니다.", "삭제 완료"));
        } catch (Exception e) {
            logger.error("댓글 삭제 실패 - 댓글 ID: {}, 오류: {}", commentId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("댓글 삭제에 실패했습니다: " + e.getMessage()));
        }
    }
} 