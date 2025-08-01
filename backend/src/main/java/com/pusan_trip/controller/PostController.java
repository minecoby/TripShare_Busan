package com.pusan_trip.controller;

import com.pusan_trip.dto.PostRequestDto;
import com.pusan_trip.dto.PostResponseDto;
import com.pusan_trip.dto.ApiResponse;
import com.pusan_trip.service.PostService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/posts")
@RequiredArgsConstructor
public class PostController {
    private static final Logger logger = LoggerFactory.getLogger(PostController.class);
    private final PostService postService;

    // 게시글 생성
    @PostMapping
    public ResponseEntity<ApiResponse<Long>> createPost(@RequestBody PostRequestDto requestDto) {
        logger.info("게시글 생성 요청 - 제목: {}", requestDto.getTitle());
        try {
            Long postId = postService.createPost(requestDto);
            logger.info("게시글 생성 성공 - 게시글 ID: {}", postId);
            return ResponseEntity.ok(ApiResponse.success("게시글이 성공적으로 생성되었습니다.", postId));
        } catch (Exception e) {
            logger.error("게시글 생성 실패 - 제목: {}, 오류: {}", requestDto.getTitle(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("게시글 생성에 실패했습니다: " + e.getMessage()));
        }
    }

    // 게시글 단건 조회
    @GetMapping("/{postId}")
    public ResponseEntity<ApiResponse<PostResponseDto>> getPostById(@PathVariable Long postId) {
        logger.info("게시글 조회 요청 - 게시글 ID: {}", postId);
        try {
            PostResponseDto response = postService.getPostById(postId);
            logger.info("게시글 조회 성공 - 게시글 ID: {}, 제목: {}", postId, response.getTitle());
            return ResponseEntity.ok(ApiResponse.success("게시글을 조회했습니다.", response));
        } catch (Exception e) {
            logger.error("게시글 조회 실패 - 게시글 ID: {}, 오류: {}", postId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("게시글 조회에 실패했습니다: " + e.getMessage()));
        }
    }

    // 게시글 전체 목록 조회
    @GetMapping
    public ResponseEntity<ApiResponse<List<PostResponseDto>>> getAllPosts() {
        logger.info("전체 게시글 목록 조회 요청");
        try {
            List<PostResponseDto> posts = postService.getAllPosts();
            logger.info("전체 게시글 목록 조회 성공 - 게시글 수: {}", posts.size());
            return ResponseEntity.ok(ApiResponse.success("게시글 목록을 조회했습니다.", posts));
        } catch (Exception e) {
            logger.error("전체 게시글 목록 조회 실패 - 오류: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("게시글 목록 조회에 실패했습니다: " + e.getMessage()));
        }
    }

    // 게시글 수정
    @PutMapping("/{postId}")
    public ResponseEntity<ApiResponse<String>> updatePost(@PathVariable Long postId, @RequestBody PostRequestDto requestDto) {
        logger.info("게시글 수정 요청 - 게시글 ID: {}, 제목: {}", postId, requestDto.getTitle());
        try {
            postService.updatePost(postId, requestDto);
            logger.info("게시글 수정 성공 - 게시글 ID: {}", postId);
            return ResponseEntity.ok(ApiResponse.success("게시글이 성공적으로 수정되었습니다.", "수정 완료"));
        } catch (Exception e) {
            logger.error("게시글 수정 실패 - 게시글 ID: {}, 오류: {}", postId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("게시글 수정에 실패했습니다: " + e.getMessage()));
        }
    }

    // 게시글 삭제
    @DeleteMapping("/{postId}")
    public ResponseEntity<ApiResponse<String>> deletePost(@PathVariable Long postId) {
        logger.info("게시글 삭제 요청 - 게시글 ID: {}", postId);
        try {
            postService.deletePost(postId);
            logger.info("게시글 삭제 성공 - 게시글 ID: {}", postId);
            return ResponseEntity.ok(ApiResponse.success("게시글이 성공적으로 삭제되었습니다.", "삭제 완료"));
        } catch (Exception e) {
            logger.error("게시글 삭제 실패 - 게시글 ID: {}, 오류: {}", postId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("게시글 삭제에 실패했습니다: " + e.getMessage()));
        }
    }

    // 좋아요 증가
    @PostMapping("/{postId}/like")
    public ResponseEntity<ApiResponse<String>> increaseLikeCount(@PathVariable Long postId) {
        logger.info("게시글 좋아요 증가 요청 - 게시글 ID: {}", postId);
        try {
            postService.increaseLikeCount(postId);
            logger.info("게시글 좋아요 증가 성공 - 게시글 ID: {}", postId);
            return ResponseEntity.ok(ApiResponse.success("좋아요가 추가되었습니다.", "좋아요 추가"));
        } catch (Exception e) {
            logger.error("게시글 좋아요 증가 실패 - 게시글 ID: {}, 오류: {}", postId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("좋아요 추가에 실패했습니다: " + e.getMessage()));
        }
    }

    // 좋아요 감소
    @PostMapping("/{postId}/unlike")
    public ResponseEntity<ApiResponse<String>> decreaseLikeCount(@PathVariable Long postId) {
        logger.info("게시글 좋아요 감소 요청 - 게시글 ID: {}", postId);
        try {
            postService.decreaseLikeCount(postId);
            logger.info("게시글 좋아요 감소 성공 - 게시글 ID: {}", postId);
            return ResponseEntity.ok(ApiResponse.success("좋아요가 취소되었습니다.", "좋아요 취소"));
        } catch (Exception e) {
            logger.error("게시글 좋아요 감소 실패 - 게시글 ID: {}, 오류: {}", postId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("좋아요 취소에 실패했습니다: " + e.getMessage()));
        }
    }

    // 조회수 기준 인기 게시글 목록 (최대 5개)
    @GetMapping("/popular")
    public ResponseEntity<ApiResponse<List<PostResponseDto>>> getPopularPosts() {
        logger.info("인기 게시글 목록 조회 요청");
        try {
            List<PostResponseDto> popularPosts = postService.getPopularPosts();
            logger.info("인기 게시글 목록 조회 성공 - 게시글 수: {}", popularPosts.size());
            return ResponseEntity.ok(ApiResponse.success("인기 게시글 목록을 조회했습니다.", popularPosts));
        } catch (Exception e) {
            logger.error("인기 게시글 목록 조회 실패 - 오류: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("인기 게시글 목록 조회에 실패했습니다: " + e.getMessage()));
        }
    }

    // 좋아요 기준 추천 게시글 목록 (최대 5개)
    @GetMapping("/recommend")
    public ResponseEntity<ApiResponse<List<PostResponseDto>>> getRecommendedPosts() {
        logger.info("추천 게시글 목록 조회 요청");
        try {
            List<PostResponseDto> recommendedPosts = postService.getRecommendedPosts();
            logger.info("추천 게시글 목록 조회 성공 - 게시글 수: {}", recommendedPosts.size());
            return ResponseEntity.ok(ApiResponse.success("추천 게시글 목록을 조회했습니다.", recommendedPosts));
        } catch (Exception e) {
            logger.error("추천 게시글 목록 조회 실패 - 오류: {}", e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("추천 게시글 목록 조회에 실패했습니다: " + e.getMessage()));
        }
    }
}
