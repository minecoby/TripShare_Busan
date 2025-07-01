package com.pusan_trip.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import jakarta.validation.constraints.NotBlank;


@Getter
public class SignupRequestDto {

    @NotBlank
    private String userId;

    @NotBlank
    @Size(min=8, message = "비밀번호는 최소 8자리 이상이어야 합니다.")
    private String password;

    @NotBlank
    @Size(min=3, message = "이름은 3자리 이상이어야 합니다.")
    private String name;

    @NotBlank
    @Email(message = "이메일 형식이 아닙니다.")
    private String email;

    protected SignupRequestDto() {}

    public SignupRequestDto(String userId, String password, String name, String email) {
        this.userId = userId;
        this.password = password;
        this.name = name;
        this.email = email;
    }
}
