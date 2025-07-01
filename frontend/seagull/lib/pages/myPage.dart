import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: Column(
              children: [
                _buildProfileImage(),
                const SizedBox(height: 8),
                const Text(
                  "아무개",
                  style: TextStyle(
                    color: TextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconBox(
                      icon: Icons.article_outlined, // 작성한 글
                      onTap: () {
                        Get.toNamed("/written");
                      },
                    ),
                    _buildIconBox(
                      icon: Icons.favorite_border, // 찜한 글
                      onTap: () {
                        Get.toNamed("/liked");
                      },
                    ),
                    _buildIconBox(
                      icon: Icons.more_horiz, // 미정
                      onTap: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 35,
                  vertical: 37,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingItem(text: '닉네임 변경'),
                    SizedBox(height: 20),
                    _SettingItem(text: '비밀번호 변경'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileImage() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 105,
        height: 105,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: ClipOval(
          child: Image.asset(
            'lib/images/user.png', // 실제 이미지 경로
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  );
}

Widget _buildIconBox({required IconData icon, required VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 30, color: MainColor),
    ),
  );
}

class _SettingItem extends StatelessWidget {
  final String text;

  const _SettingItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 16, color: TextColor));
  }
}
