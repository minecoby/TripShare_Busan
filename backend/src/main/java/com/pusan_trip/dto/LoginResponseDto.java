package com.pusan_trip.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginResponseDto {
    private String username;
    private Long userId;
    private String token;
}
