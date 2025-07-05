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
    private String region;

    public PostResponseDto(Long id, String title, String content, String summary, LocalDateTime createdAt, Long userId, String userName, int likeCount, int seenCount, int commentCount, List<CommentRequestDto> comments, String region) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.summary = summary;
        this.createdAt = createdAt;
        this.userId = userId;
        this.userName = userName;
        this.likeCount = likeCount;
        this.seenCount = seenCount;
        this.commentCount = commentCount;
        this.comments = comments;
        this.region = region;
    }

    public String getRegion() {
        return region;
    }
} 