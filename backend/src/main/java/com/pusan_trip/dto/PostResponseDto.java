package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PostResponseDto {
    private Long id;
    private String title;
    private String content;
    private String summary;
    private LocalDateTime createdAt;
    private Long userId;
    private String userName;
    private Integer likeCount;
    private Integer seenCount;
    private Integer commentCount;
    private List<CommentRequestDto> comments;
} 