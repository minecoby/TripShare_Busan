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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false, unique = true)
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
}
