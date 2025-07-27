package com.pusan_trip.service;

import com.pusan_trip.domain.Post;
import com.pusan_trip.domain.Route;
import com.pusan_trip.domain.RouteLocation;
import com.pusan_trip.dto.RouteRequestDto;
import com.pusan_trip.dto.RouteResponseDto;
import com.pusan_trip.dto.RouteUpdateRequestDto;
import com.pusan_trip.repository.RouteRepository;
import com.pusan_trip.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RouteService {
    private final RouteRepository routeRepository;
    private final PostRepository postRepository;

    @Transactional
    public Long createRoute(RouteRequestDto requestDto) {
        // 지역 개수 검증
        if (requestDto.getLocations().size() < 3 || requestDto.getLocations().size() > 5) {
            throw new IllegalArgumentException("지역은 3개 이상 5개 이하여야 합니다");
        }

        Post post = postRepository.findById(requestDto.getPostId())
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));

        Route route = new Route(post);
        routeRepository.save(route);

        // 지역 정보들 저장
        for (RouteRequestDto.LocationRequestDto locationDto : requestDto.getLocations()) {
            RouteLocation routeLocation = new RouteLocation(
                locationDto.getLocationName(),
                locationDto.getAddress(),
                locationDto.getImageUrl(),
                locationDto.getOrderIndex()
            );
            route.addRouteLocation(routeLocation);
        }

        return route.getId();
    }

    @Transactional(readOnly = true)
    public RouteResponseDto getRouteById(Long routeId) {
        Route route = routeRepository.findByIdWithPostAndLocations(routeId)
                .orElseThrow(() -> new IllegalArgumentException("Route not found"));

        List<RouteResponseDto.LocationResponseDto> locationDtos = route.getRouteLocations().stream()
                .map(location -> new RouteResponseDto.LocationResponseDto(
                    location.getId(),
                    location.getLocationName(),
                    location.getAddress(),
                    location.getImageUrl(),
                    location.getOrderIndex()
                ))
                .collect(Collectors.toList());

        return new RouteResponseDto(
            route.getId(),
            route.getPost().getId(),
            locationDtos
        );
    }


    @Transactional(readOnly = true)
    public RouteResponseDto getRouteByPostId(Long postId) {
        Route route = routeRepository.findByPostId(postId)
                .orElseThrow(() -> new IllegalArgumentException("Route not found for this post"));
        
        List<RouteResponseDto.LocationResponseDto> locationDtos = route.getRouteLocations().stream()
                .map(location -> new RouteResponseDto.LocationResponseDto(
                    location.getId(),
                    location.getLocationName(),
                    location.getAddress(),
                    location.getImageUrl(),
                    location.getOrderIndex()
                ))
                .collect(Collectors.toList());

        return new RouteResponseDto(
            route.getId(),
            route.getPost().getId(),
            locationDtos
        );
    }

    @Transactional
    public void updateRouteLocations(Long routeId, RouteUpdateRequestDto requestDto) {
        // 지역 개수 검증
        if (requestDto.getLocations().size() < 3 || requestDto.getLocations().size() > 5) {
            throw new IllegalArgumentException("지역은 3개 이상 5개 이하여야 합니다");
        }

        Route route = routeRepository.findById(routeId)
                .orElseThrow(() -> new IllegalArgumentException("Route not found"));

        // 기존 지역 정보들 삭제
        route.getRouteLocations().clear();

        // 새로운 지역 정보들 추가
        for (RouteUpdateRequestDto.LocationRequestDto locationDto : requestDto.getLocations()) {
            RouteLocation routeLocation = new RouteLocation(
                locationDto.getLocationName(),
                locationDto.getAddress(),
                locationDto.getImageUrl(),
                locationDto.getOrderIndex()
            );
            route.addRouteLocation(routeLocation);
        }
    }

    @Transactional
    public void deleteRoute(Long routeId) {
        Route route = routeRepository.findById(routeId)
                .orElseThrow(() -> new IllegalArgumentException("Route not found"));
        routeRepository.delete(route);
    }
} 