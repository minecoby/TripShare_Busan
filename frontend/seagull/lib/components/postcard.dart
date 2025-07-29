import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

class PostCard extends StatelessWidget {
  final VoidCallback? onTap;

  final String title;
  final String nickname;
  final int likeCount;
  final int commentCount;
  final String region;

  const PostCard({
    required this.title,
    required this.nickname,
    required this.likeCount,
    required this.commentCount,
    required this.region,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 85,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: ListColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: Image.asset('images/oyaji.jpg', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: TextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        UserDataText(nickname),
                        const UserDataText(' | '),
                        const Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Color(0xFF8A8A8A),
                        ),
                        const SizedBox(width: 4),
                        UserDataText(likeCount.toString()),
                        const UserDataText(' | '),
                        const Icon(
                          Icons.comment,
                          size: 14,
                          color: Color(0xFF8A8A8A),
                        ),
                        const SizedBox(width: 4),
                        UserDataText(commentCount.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFFCEC8FD), // 연보라
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDataText extends StatelessWidget {
  final String value;
  const UserDataText(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
    );
  }
}
