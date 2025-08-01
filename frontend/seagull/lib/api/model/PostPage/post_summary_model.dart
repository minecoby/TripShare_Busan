class Comment {
  final int id;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final String createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userProfileImage: json['userProfileImage'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}

class PostDetail {
  final int id;
  final String title;
  final String content;
  final String summary;
  final String createdAt;
  final int userId;
  final String userName;
  final int likeCount;
  final int seenCount;
  final int commentCount;
  final List<Comment> comments;
  final String region;
  final int routeId;

  PostDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.likeCount,
    required this.seenCount,
    required this.commentCount,
    required this.comments,
    required this.region,
    required this.routeId,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      summary: json['summary'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      userName: json['userName'],
      likeCount: json['likeCount'],
      seenCount: json['seenCount'],
      commentCount: json['commentCount'],
      region: json['region'],
      comments:
          (json['comments'] as List).map((c) => Comment.fromJson(c)).toList(),
      routeId: json['routeId'],
    );
  }
}
