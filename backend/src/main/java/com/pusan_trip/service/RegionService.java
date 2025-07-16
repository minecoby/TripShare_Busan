package com.pusan_trip.service;

import com.pusan_trip.domain.Region;
import com.pusan_trip.dto.RegionRequestDto;
import com.pusan_trip.dto.RegionResponseDto;
import com.pusan_trip.repository.RegionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class RegionService {
    
    private final RegionRepository regionRepository;
    
    public RegionResponseDto createRegion(RegionRequestDto requestDto) {
        // 중복 체크
        if (regionRepository.findByRegion(requestDto.getRegion()).isPresent()) {
            throw new IllegalArgumentException("이미 존재하는 지역입니다: " + requestDto.getRegion());
        }
        
        Region region = new Region(requestDto.getRegion());
        Region savedRegion = regionRepository.save(region);
        
        return new RegionResponseDto(savedRegion);
    }
} 