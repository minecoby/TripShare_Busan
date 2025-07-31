class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final int userId;
  final String userName;
  final int likeCount;
  final int seenCount;  
  final int commentCount;
  final String region;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.likeCount,
    required this.seenCount,
    required this.commentCount,
    required this.region,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      userName: json['userName'],
      likeCount: json['likeCount'],
      seenCount: json['seenCount'],
      commentCount: json['commentCount'],
      region: json['region'],
    );
  }
}
