package com.pusan_trip.repository;

import com.pusan_trip.domain.Route;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RouteRepository extends JpaRepository<Route, Long> {
    
    @Query("SELECT r FROM Route r JOIN FETCH r.post WHERE r.post.id = :postId")
    java.util.Optional<Route> findByPostId(@Param("postId") Long postId);

    @Query("SELECT r FROM Route r JOIN FETCH r.post JOIN FETCH r.routeLocations WHERE r.id = :routeId")
    java.util.Optional<Route> findByIdWithPostAndLocations(@Param("routeId") Long routeId);
} 