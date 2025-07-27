package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RouteUpdateRequestDto {
    @NotNull
    @Size(min = 3, max = 5, message = "지역은 3개 이상 5개 이하")
    private List<LocationRequestDto> locations;

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LocationRequestDto {
        @NotNull
        private String locationName;

        @NotNull
        private String address;

        private String imageUrl;

        @NotNull
        private Integer orderIndex;
    }
} 