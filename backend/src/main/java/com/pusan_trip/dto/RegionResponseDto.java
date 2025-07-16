package com.pusan_trip.dto;

import com.pusan_trip.domain.Region;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class RegionResponseDto {
    private Long id;
    private String region;

    public RegionResponseDto(Region region) {
        this.id = region.getId();
        this.region = region.getRegion();
    }
} 