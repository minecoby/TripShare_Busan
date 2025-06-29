package com.pusan_trip.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity // 데이터베이스 테이블로 사용될 클래스 명시
@Getter // Lombok에서 제공, getter메서드 자동 생성
@NoArgsConstructor // 기본 생성자
public class User {
    @Id // 기본 키(Primary Key)
    @GeneratedValue(strategy = GenerationType.IDENTITY) // auto_increment
    private Long id;

    @Column(unique = true, nullable = false) // 중복, null 허용 안함
    private String userId;

    @Column(nullable = false)
    private String password;

    private String name;

    @Column(unique = true, nullable = false) // 중복, null 허용 안함
    private String email;

    // 게시글 연관 관계 - 유저가 작성한 게시글 목록을 조회할 때 필요
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Post> posts = new ArrayList<>();

    public User(String userId, String name, String password, String email) {
        this.userId = userId;
        this.name = name;
        this.password = password;
        this.email = email;
    }

    // 닉네임 변경 메서드
    public void updateName(String newName) {
        this.name = newName;
    }

    // 비밀번호 변경 메서드
    public void updatePassword(String newPassword) {
        this.password = newPassword;
    }
}
