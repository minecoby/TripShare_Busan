package com.pusan_trip.controller;

import com.pusan_trip.dto.RouteRequestDto;
import com.pusan_trip.dto.RouteResponseDto;
import com.pusan_trip.dto.RouteUpdateRequestDto;
import com.pusan_trip.dto.ApiResponse;
import com.pusan_trip.service.RouteService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/routes")
@RequiredArgsConstructor
public class RouteController {
    private static final Logger logger = LoggerFactory.getLogger(RouteController.class);
    private final RouteService routeService;

    // 루트 생성
    @PostMapping
    public ResponseEntity<ApiResponse<Long>> createRoute(@Valid @RequestBody RouteRequestDto requestDto) {
        logger.info("루트 생성 요청 - 게시글 ID: {}", requestDto.getPostId());
        try {
            Long routeId = routeService.createRoute(requestDto);
            logger.info("루트 생성 성공 - 루트 ID: {}", routeId);
            return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("루트가 성공적으로 생성되었습니다.", routeId));
        } catch (Exception e) {
            logger.error("루트 생성 실패 - 게시글 ID: {}, 오류: {}", requestDto.getPostId(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("루트 생성에 실패했습니다: " + e.getMessage()));
        }
    }

    // 루트 조회
    @GetMapping("/{routeId}")
    public ResponseEntity<ApiResponse<RouteResponseDto>> getRoute(@PathVariable Long routeId) {
        logger.info("루트 조회 요청 - 루트 ID: {}", routeId);
        try {
            RouteResponseDto route = routeService.getRouteById(routeId);
            logger.info("루트 조회 성공 - 루트 ID: {}", routeId);
            return ResponseEntity.ok(ApiResponse.success("루트 정보를 조회했습니다.", route));
        } catch (Exception e) {
            logger.error("루트 조회 실패 - 루트 ID: {}, 오류: {}", routeId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("루트 조회에 실패했습니다: " + e.getMessage()));
        }
    }

    // 게시글별 루트 조회
    @GetMapping("/post/{postId}")
    public ResponseEntity<ApiResponse<RouteResponseDto>> getRouteByPost(@PathVariable Long postId) {
        logger.info("게시글별 루트 조회 요청 - 게시글 ID: {}", postId);
        try {
            RouteResponseDto route = routeService.getRouteByPostId(postId);
            logger.info("게시글별 루트 조회 성공 - 게시글 ID: {}", postId);
            return ResponseEntity.ok(ApiResponse.success("게시글의 루트 정보를 조회했습니다.", route));
        } catch (Exception e) {
            logger.error("게시글별 루트 조회 실패 - 게시글 ID: {}, 오류: {}", postId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("게시글의 루트 조회에 실패했습니다: " + e.getMessage()));
        }
    }

    // 루트 지역 정보 수정
    @PatchMapping("/{routeId}")
    public ResponseEntity<ApiResponse<String>> updateRouteLocations(@PathVariable Long routeId, 
                                                   @Valid @RequestBody RouteUpdateRequestDto requestDto) {
        logger.info("루트 수정 요청 - 루트 ID: {}", routeId);
        try {
            routeService.updateRouteLocations(routeId, requestDto);
            logger.info("루트 수정 성공 - 루트 ID: {}", routeId);
            return ResponseEntity.ok(ApiResponse.success("루트가 성공적으로 수정되었습니다.", "수정 완료"));
        } catch (Exception e) {
            logger.error("루트 수정 실패 - 루트 ID: {}, 오류: {}", routeId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("루트 수정에 실패했습니다: " + e.getMessage()));
        }
    }

    // 루트 삭제
    @DeleteMapping("/{routeId}")
    public ResponseEntity<ApiResponse<String>> deleteRoute(@PathVariable Long routeId) {
        logger.info("루트 삭제 요청 - 루트 ID: {}", routeId);
        try {
            routeService.deleteRoute(routeId);
            logger.info("루트 삭제 성공 - 루트 ID: {}", routeId);
            return ResponseEntity.ok(ApiResponse.success("루트가 성공적으로 삭제되었습니다.", "삭제 완료"));
        } catch (Exception e) {
            logger.error("루트 삭제 실패 - 루트 ID: {}, 오류: {}", routeId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("루트 삭제에 실패했습니다: " + e.getMessage()));
        }
    }
} 