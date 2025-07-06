package com.pusan_trip.controller;

import com.pusan_trip.dto.RegionRequestDto;
import com.pusan_trip.dto.RegionResponseDto;
import com.pusan_trip.service.RegionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/regions")
@RequiredArgsConstructor
public class RegionController {
    
    private final RegionService regionService;
    
    @PostMapping
    public ResponseEntity<RegionResponseDto> createRegion(@RequestBody RegionRequestDto requestDto) {
        RegionResponseDto responseDto = regionService.createRegion(requestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDto);
    }
} 