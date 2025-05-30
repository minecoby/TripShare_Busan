import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

class PostCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PostCard({this.onTap, super.key});

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
                  child: Image.asset('lib/images/oyaji.jpg', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '북구 화명동에 떠나보았습니다',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: TextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        UserDataText('user'),
                        UserDataText(' | '),
                        Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Color(0xFF8A8A8A),
                        ),
                        SizedBox(width: 4),
                        UserDataText('0'),
                        UserDataText(' | '),
                        Icon(Icons.comment, size: 14, color: Color(0xFF8A8A8A)),
                        SizedBox(width: 4),
                        UserDataText('0'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFFCEC8FD), //연보라로맞췄어
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
