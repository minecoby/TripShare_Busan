// 게시글 생성,수정 요청에 사용
package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

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
} 