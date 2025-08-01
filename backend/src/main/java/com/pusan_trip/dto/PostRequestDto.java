// 게시글 생성,수정 요청에 사용
package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PostRequestDto {
    @NotBlank
    private String title;

    @NotBlank
    private String content;

    @NotNull
    private Long userId;

    private String region;

    // 루트 정보 추가
    @Size(min = 3, max = 5, message = "지역은 3개 이상 5개 이하")
    private List<LocationRequestDto> locations;

    public String getRegion() {
        return region;
    }

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LocationRequestDto {
        @NotBlank
        private String locationName;

        @NotBlank
        private String address;

        private String imageUrl;

        @NotNull
        private Integer orderIndex;
    }
} 