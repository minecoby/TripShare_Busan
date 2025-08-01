package com.pusan_trip.controller;

import com.pusan_trip.dto.RegionRequestDto;
import com.pusan_trip.dto.RegionResponseDto;
import com.pusan_trip.dto.ApiResponse;
import com.pusan_trip.service.RegionService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/regions")
@RequiredArgsConstructor
public class RegionController {
    
    private static final Logger logger = LoggerFactory.getLogger(RegionController.class);
    private final RegionService regionService;
    
    @PostMapping
    public ResponseEntity<ApiResponse<RegionResponseDto>> createRegion(@RequestBody RegionRequestDto requestDto) {
        logger.info("지역 생성 요청 - 지역명: {}", requestDto.getRegion());
        try {
            RegionResponseDto responseDto = regionService.createRegion(requestDto);
            logger.info("지역 생성 성공 - 지역 ID: {}, 지역명: {}", responseDto.getId(), responseDto.getRegion());
            return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("지역이 성공적으로 생성되었습니다.", responseDto));
        } catch (Exception e) {
            logger.error("지역 생성 실패 - 지역명: {}, 오류: {}", requestDto.getRegion(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("지역 생성에 실패했습니다: " + e.getMessage()));
        }
    }
} 