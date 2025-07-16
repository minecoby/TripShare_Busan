package com.pusan_trip.repository;

import com.pusan_trip.domain.Region;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface RegionRepository extends JpaRepository<Region, Long> {
    Optional<Region> findByRegion(String region);
} 