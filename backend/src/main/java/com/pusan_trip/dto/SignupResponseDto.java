package com.pusan_trip.dto;

import lombok.Getter;

@Getter
public class SignupResponseDto {

    private Long id;
    private String userId;
    private String name;

    protected SignupResponseDto() {}
    public SignupResponseDto(Long id, String userId, String name) {
        this.id = id;
        this.userId = userId;
        this.name = name;
    }
}
