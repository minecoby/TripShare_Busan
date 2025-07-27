package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RouteResponseDto {
    private Long id;
    private Long postId;
    private List<LocationResponseDto> locations;

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LocationResponseDto {
        private Long id;
        private String locationName;
        private String address;
        private String imageUrl;
        private Integer orderIndex;
    }
} 