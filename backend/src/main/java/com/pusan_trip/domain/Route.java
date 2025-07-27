package com.pusan_trip.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "routes")
public class Route {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @OneToMany(mappedBy = "route", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("orderIndex ASC")
    private List<RouteLocation> routeLocations = new ArrayList<>();


    public Route(Post post) {
        this.post = post;
    }

    public void addRouteLocation(RouteLocation routeLocation) {
        routeLocations.add(routeLocation);
        routeLocation.setRoute(this);
    }

    public void removeRouteLocation(RouteLocation routeLocation) {
        routeLocations.remove(routeLocation);
        routeLocation.setRoute(null);
    }

    public void setPost(Post post) {
        this.post = post;
    }
} 