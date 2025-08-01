package com.pusan_trip.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private String timestamp;

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "요청이 성공적으로 처리되었습니다.", data, java.time.LocalDateTime.now().toString());
    }

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, message, data, java.time.LocalDateTime.now().toString());
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null, java.time.LocalDateTime.now().toString());
    }

    public static <T> ApiResponse<T> error(String message, T data) {
        return new ApiResponse<>(false, message, data, java.time.LocalDateTime.now().toString());
    }
}