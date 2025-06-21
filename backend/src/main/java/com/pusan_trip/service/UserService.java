package com.pusan_trip.service;

import com.pusan_trip.domain.User;
import com.pusan_trip.dto.LoginRequestDto;
import com.pusan_trip.dto.LoginResponseDto;
import com.pusan_trip.dto.SignupRequestDto;
import com.pusan_trip.dto.SignupResponseDto;
import com.pusan_trip.exception.DuplicateUserException;
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
        User user = userRepository.findByUserId(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }

        return new LoginResponseDto(user.getName(), user.getUserId(), "로그인 성공");
    }

    public SignupResponseDto signup(SignupRequestDto dto) {
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new DuplicateUserException("이미 존재하는 이메일입니다.");
        }

        if (userRepository.findByUserId(dto.getUserId()).isPresent()) {
            throw new DuplicateUserException("이미 존재하는 사용자 ID입니다.");
        }

        String encodedPassword = passwordEncoder.encode(dto.getPassword());

        User user = new User(
                dto.getUserId(),
                encodedPassword,
                dto.getName(),
                dto.getEmail()
        );

        userRepository.save(user);

        return new SignupResponseDto(user.getId(), user.getUserId(), user.getName());
    }
}