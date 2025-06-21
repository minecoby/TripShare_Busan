package com.pusan_trip.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;


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

    public User(String userId, String name, String password, String email){
        this.userId = userId;
        this.name = name;
        this.password = password;
        this.email = email;
    }
}

