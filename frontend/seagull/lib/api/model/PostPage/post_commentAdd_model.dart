class CommentAdd {
  final int postId;
  final int userId;
  final String content;
  //final DateTime createdAt;

  CommentAdd({
    required this.postId,
    required this.userId,
    required this.content,
    //required this.createdAt,
  });

  factory CommentAdd.fromJson(Map<String, dynamic> json) {
    return CommentAdd(
      postId: json['postId'],
      userId: json['userId'],
      content: json['content'],
      // createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'content': content,
    };
  }
}
