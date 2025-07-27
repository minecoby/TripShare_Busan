package com.pusan_trip.domain;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "posts")
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String content;

    @Column(columnDefinition = "TEXT")
    private String summary;

    @Column(updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "region_id")
    private Region region;

    @OneToOne(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private PostInfo postInfo;

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();

    @OneToOne(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private Route route;

    public Post(String title, String content, String summary, User user, PostInfo postInfo, Region region, Comment... comments) {
        this.title = title;
        this.content = content;
        this.summary = summary;
        this.user = user;
        this.postInfo = postInfo;
        this.region = region;
        this.comments = Arrays.asList(comments);
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }
    
    public void addComment(Comment comment) {
        if (!comments.contains(comment)) {
            comments.add(comment);
            comment.setPost(this);
        }
    }

    public void setPostInfo(PostInfo postInfo) {
        this.postInfo = postInfo;
        postInfo.setPost(this);
    }
    
    public void update(String title, String content) {
        this.title = title;
        this.content = content;
    }

    public void setRegion(Region region) {
        this.region = region;
    }

    public void setRoute(Route route) {
        this.route = route;
    }
}
