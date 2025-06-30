package com.pusan_trip.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "postinfo")
public class PostInfo {
    @Id
    private Long id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "post_id")
    private Post post;

    @Column(nullable = false)
    private Integer likeCount ;

    @Column(nullable = false)
    private Integer seenCount ;


    public PostInfo(Post post, Integer likeCount, Integer seenCount) {
        this.post = post;
        this.likeCount = likeCount;
        this.seenCount = seenCount;
    }

    public void setPost(Post post) {
        this.post = post;
        if (post.getPostInfo() != this) {
            post.setPostInfo(this);
        }
    }

    public void increaseSeenCount() {
        this.seenCount++;
    }

    public void increaseLikeCount() {
        this.likeCount++;
    }

    public void decreaseLikeCount() {
        if (this.likeCount > 0) {
            this.likeCount--;
        }
    }

}
