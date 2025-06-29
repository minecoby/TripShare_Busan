package com.pusan_trip.repository;

import com.pusan_trip.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    // 이메일로 사용자 조회
    Optional<User> findByEmail(String email);

    // 유저네임으로 사용자 조회
    Optional<User> findByname(String name);

    // 유저아이디로 사용자 조회
    Optional<User> findByUserId(String userId);

    // 이메일 중복 여부 확인
    boolean existsByEmail(String email);

    // 유저네임 중복 여부 확인
    boolean existsByName(String name);

    // 유저아이디 중복 여부 확인
    boolean existsByUserId(String userId);
}