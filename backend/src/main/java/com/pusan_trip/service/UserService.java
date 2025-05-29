package com.pusan_trip.service;

import com.pusan_trip.domain.user;
import com.pusan_trip.dto.LoginRequestDto;
import com.pusan_trip.dto.LoginResponseDto;
import com.pusan_trip.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public LoginResponseDto login(LoginRequestDto dto) {
        user user = userRepository.findByUserId(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        return new LoginResponseDto(user.getName(), user.getUserId(), "로그인 성공");
    }
}