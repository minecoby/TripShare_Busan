package com.pusan_trip.controller;

import com.pusan_trip.dto.RouteRequestDto;
import com.pusan_trip.dto.RouteResponseDto;
import com.pusan_trip.dto.RouteUpdateRequestDto;
import com.pusan_trip.service.RouteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/routes")
@RequiredArgsConstructor
public class RouteController {
    private final RouteService routeService;

    // 루트 생성
    @PostMapping
    public ResponseEntity<Long> createRoute(@Valid @RequestBody RouteRequestDto requestDto) {
        Long routeId = routeService.createRoute(requestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(routeId);
    }

    // 루트 조회
    @GetMapping("/{routeId}")
    public ResponseEntity<RouteResponseDto> getRoute(@PathVariable Long routeId) {
        RouteResponseDto route = routeService.getRouteById(routeId);
        return ResponseEntity.ok(route);
    }

    // 게시글별 루트 조회
    @GetMapping("/post/{postId}")
    public ResponseEntity<RouteResponseDto> getRouteByPost(@PathVariable Long postId) {
        RouteResponseDto route = routeService.getRouteByPostId(postId);
        return ResponseEntity.ok(route);
    }

    // 루트 지역 정보 수정
    @PatchMapping("/{routeId}")
    public ResponseEntity<Void> updateRouteLocations(@PathVariable Long routeId, 
                                                   @Valid @RequestBody RouteUpdateRequestDto requestDto) {
        routeService.updateRouteLocations(routeId, requestDto);
        return ResponseEntity.ok().build();
    }

    // 루트 삭제
    @DeleteMapping("/{routeId}")
    public ResponseEntity<Void> deleteRoute(@PathVariable Long routeId) {
        routeService.deleteRoute(routeId);
        return ResponseEntity.ok().build();
    }
} 