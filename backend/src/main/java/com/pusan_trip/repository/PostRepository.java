package com.pusan_trip.repository;
import com.pusan_trip.domain.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {

    // 제목에 특정 키워드가 포함된 게시글 목록 조회 (페이징 지원)
    Page<Post> findByTitleContaining(String keyword, Pageable pageable);

    // 특정 유저의 게시글 전체 조회
    List<Post> findByUserId(Long userId);

    // 특정 유저의 게시글 페이징
    Page<Post> findByUserId(Long userId, Pageable pageable);

    // 생성일 내림차순으로 최신 게시글 5개
    List<Post> findTop5ByOrderByCreatedAtDesc();
}
