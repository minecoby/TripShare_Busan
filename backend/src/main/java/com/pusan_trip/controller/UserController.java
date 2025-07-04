package com.pusan_trip.controller;

import com.pusan_trip.dto.LoginRequestDto;
import com.pusan_trip.dto.LoginResponseDto;

import com.pusan_trip.dto.SignupRequestDto;
import com.pusan_trip.dto.SignupResponseDto;

import com.pusan_trip.dto.NicknameRequest;
import com.pusan_trip.dto.PasswordChangeRequest;

import com.pusan_trip.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDto> login(@RequestBody LoginRequestDto requestDto) {
        LoginResponseDto responseDto = userService.login(requestDto);
        return ResponseEntity.ok(responseDto);
    }


    @PostMapping("/signup")
    public ResponseEntity<SignupResponseDto> signup(@Valid  @RequestBody SignupRequestDto signupRequestDto) {
        SignupResponseDto savedUser = userService.signup(signupRequestDto);
        return ResponseEntity.ok(savedUser);
    }

    @GetMapping("/check-nickname")
    public ResponseEntity<Boolean> checkNicknameAvailability(@RequestParam String nickname) {
        boolean isAvailable = userService.isNicknameAvailable(nickname);
        return ResponseEntity.ok(isAvailable);
    }

    @PutMapping("/{userId}/nickname")
    public ResponseEntity<String> updateNickname(
            @PathVariable Long userId,
            @RequestBody NicknameRequest request) {
        try {
            userService.updateNickname(userId, request);
            return ResponseEntity.ok("닉네임이 성공적으로 변경되었습니다.");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{userId}/password")
    public ResponseEntity<String> updatePassword(
            @PathVariable Long userId,
            @RequestBody PasswordChangeRequest request) {
        try {
            userService.updatePassword(userId, request);
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
