package com.pusan_trip.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "route_locations")
public class RouteLocation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "route_id", nullable = false)
    private Route route;

    @Column(nullable = false)
    private String locationName;

    @Column(nullable = false)
    private String address;

    @Column
    private String imageUrl;

    @Column(nullable = false)
    private Integer orderIndex;

    public RouteLocation(String locationName, String address, String imageUrl, Integer orderIndex) {
        this.locationName = locationName;
        this.address = address;
        this.imageUrl = imageUrl;
        this.orderIndex = orderIndex;
    }

    public void setRoute(Route route) {
        this.route = route;
    }

    public void update(String locationName, String address, String imageUrl, Integer orderIndex) {
        this.locationName = locationName;
        this.address = address;
        this.imageUrl = imageUrl;
        this.orderIndex = orderIndex;
    }
} 