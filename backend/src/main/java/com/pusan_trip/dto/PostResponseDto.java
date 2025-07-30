package com.pusan_trip.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonInclude;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
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
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private List<CommentRequestDto> comments;
    private String region;
    private Long routeId;

    public PostResponseDto(Long id, String title, String content, String summary, LocalDateTime createdAt, Long userId, String userName, int likeCount, int seenCount, int commentCount, List<CommentRequestDto> comments, String region, Long routeId) {
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
        this.routeId = routeId;
    }

    public String getRegion() {
        return region;
    }
} 