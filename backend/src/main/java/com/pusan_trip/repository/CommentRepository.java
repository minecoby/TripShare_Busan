package com.pusan_trip.repository;

import com.pusan_trip.domain.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    // 특정 게시글의 모든 댓글 조회
    List<Comment> findByPostId(Long postId);

    // 게시글 삭제 시 댓글 일괄 삭제
    void deleteByPostId(Long postId);
} 