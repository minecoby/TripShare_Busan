package com.pusan_trip.repository;
import com.pusan_trip.domain.PostInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.List;

public interface PostInfoRepository extends JpaRepository<PostInfo, Long> {

    // 특정 게시글(Post)에 대한 PostInfo 조회
    Optional<PostInfo> findByPostId(Long postId);

    // 좋아요 수가 높은 순으로 정렬된 상위 N개 PostInfo (e.g. 인기글)
    List<PostInfo> findTop10ByOrderByLikeCountDesc();

    // 조회수가 높은 순으로 정렬된 PostInfo
    List<PostInfo> findTop10ByOrderBySeenCountDesc();
}
