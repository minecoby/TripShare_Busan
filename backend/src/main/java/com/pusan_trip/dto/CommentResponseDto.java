package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CommentResponseDto {
    private Long id;
    private Long postId;
    private String userId;
    private String userName;
    private String userProfileImage; // 사용자 프로필 사진
    private String content;
    private LocalDateTime createdAt;
} 