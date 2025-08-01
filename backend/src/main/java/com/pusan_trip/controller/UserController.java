package com.pusan_trip.controller;

import com.pusan_trip.dto.LoginRequestDto;
import com.pusan_trip.dto.LoginResponseDto;
import com.pusan_trip.dto.SignupRequestDto;
import com.pusan_trip.dto.SignupResponseDto;
import com.pusan_trip.dto.NicknameRequest;
import com.pusan_trip.dto.PasswordChangeRequest;
import com.pusan_trip.dto.ProfileImageRequest;
import com.pusan_trip.dto.MyPageResponseDto;
import com.pusan_trip.dto.ApiResponse;
import com.pusan_trip.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);
    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponseDto>> login(@RequestBody LoginRequestDto requestDto) {
        logger.info("로그인 요청 - 사용자 ID: {}", requestDto.getUserId());
        try {
            LoginResponseDto responseDto = userService.login(requestDto);
            logger.info("로그인 성공 - 사용자 ID: {}", requestDto.getUserId());
            return ResponseEntity.ok(ApiResponse.success("로그인에 성공했습니다.", responseDto));
        } catch (Exception e) {
            logger.error("로그인 실패 - 사용자 ID: {}, 오류: {}", requestDto.getUserId(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("로그인에 실패했습니다: " + e.getMessage()));
        }
    }


    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<SignupResponseDto>> signup(@Valid @RequestBody SignupRequestDto signupRequestDto) {
        logger.info("회원가입 요청 - 사용자 ID: {}, 이름: {}", signupRequestDto.getUserId(), signupRequestDto.getName());
        try {
            SignupResponseDto savedUser = userService.signup(signupRequestDto);
            logger.info("회원가입 성공 - 사용자 ID: {}, 이름: {}", savedUser.getId(), savedUser.getName());
            return ResponseEntity.ok(ApiResponse.success("회원가입이 완료되었습니다.", savedUser));
        } catch (Exception e) {
            logger.error("회원가입 실패 - 사용자 ID: {}, 오류: {}", signupRequestDto.getUserId(), e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("회원가입에 실패했습니다: " + e.getMessage()));
        }
    }

    @GetMapping("/check-nickname")
    public ResponseEntity<ApiResponse<Boolean>> checkNicknameAvailability(@RequestParam String nickname) {
        logger.info("닉네임 중복 확인 요청 - 닉네임: {}", nickname);
        try {
            boolean isAvailable = userService.isNicknameAvailable(nickname);
            String message = isAvailable ? "사용 가능한 닉네임입니다." : "이미 사용 중인 닉네임입니다.";
            logger.info("닉네임 중복 확인 완료 - 닉네임: {}, 사용가능: {}", nickname, isAvailable);
            return ResponseEntity.ok(ApiResponse.success(message, isAvailable));
        } catch (Exception e) {
            logger.error("닉네임 중복 확인 실패 - 닉네임: {}, 오류: {}", nickname, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("닉네임 중복 확인에 실패했습니다: " + e.getMessage()));
        }
    }

    @PutMapping("/{userId}/nickname")
    public ResponseEntity<ApiResponse<String>> updateNickname(
            @PathVariable Long userId,
            @RequestBody NicknameRequest request) {
        logger.info("닉네임 변경 요청 - 사용자 ID: {}, 새 닉네임: {}", userId, request.getNewNickname());
        try {
            userService.updateNickname(userId, request);
            logger.info("닉네임 변경 성공 - 사용자 ID: {}, 새 닉네임: {}", userId, request.getNewNickname());
            return ResponseEntity.ok(ApiResponse.success("닉네임이 성공적으로 변경되었습니다.", "변경 완료"));
        } catch (IllegalArgumentException e) {
            logger.error("닉네임 변경 실패 - 사용자 ID: {}, 오류: {}", userId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{userId}/password")
    public ResponseEntity<ApiResponse<String>> updatePassword(
            @PathVariable Long userId,
            @RequestBody PasswordChangeRequest request) {
        logger.info("비밀번호 변경 요청 - 사용자 ID: {}", userId);
        try {
            userService.updatePassword(userId, request);
            logger.info("비밀번호 변경 성공 - 사용자 ID: {}", userId);
            return ResponseEntity.ok(ApiResponse.success("비밀번호가 성공적으로 변경되었습니다.", "변경 완료"));
        } catch (IllegalArgumentException e) {
            logger.error("비밀번호 변경 실패 - 사용자 ID: {}, 오류: {}", userId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{userId}/profile-image")
    public ResponseEntity<ApiResponse<String>> updateProfileImage(
            @PathVariable Long userId,
            @RequestBody ProfileImageRequest request) {
        logger.info("프로필 이미지 변경 요청 - 사용자 ID: {}", userId);
        try {
            userService.updateProfileImage(userId, request.getProfileImage());
            logger.info("프로필 이미지 변경 성공 - 사용자 ID: {}", userId);
            return ResponseEntity.ok(ApiResponse.success("프로필 사진이 성공적으로 변경되었습니다.", "변경 완료"));
        } catch (IllegalArgumentException e) {
            logger.error("프로필 이미지 변경 실패 - 사용자 ID: {}, 오류: {}", userId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    // 마이페이지 조회
    @GetMapping("/{userId}/mypage")
    public ResponseEntity<ApiResponse<MyPageResponseDto>> getMyPage(@PathVariable Long userId) {
        logger.info("마이페이지 조회 요청 - 사용자 ID: {}", userId);
        try {
            MyPageResponseDto myPage = userService.getMyPage(userId);
            logger.info("마이페이지 조회 성공 - 사용자 ID: {}", userId);
            return ResponseEntity.ok(ApiResponse.success("마이페이지 정보를 조회했습니다.", myPage));
        } catch (IllegalArgumentException e) {
            logger.error("마이페이지 조회 실패 - 사용자 ID: {}, 오류: {}", userId, e.getMessage());
            return ResponseEntity.badRequest().body(ApiResponse.error("마이페이지 조회에 실패했습니다: " + e.getMessage()));
        }
    }
}
