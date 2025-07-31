class MyPageInfo {
  final int id;
  final String userId;
  final String name;
  final String profileImage;

  MyPageInfo({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileImage,
  });

  factory MyPageInfo.fromJson(Map<String, dynamic> json) {
    return MyPageInfo(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }
}
