import 'package:flutter/material.dart';
import 'package:seagull/api/controller/LoginAndSignup/login_controller.dart';
import 'package:seagull/api/controller/MyPage/mypage_controller.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final MyPageController myPageController = Get.put(MyPageController());

  String name = '로그인이 필요합니다';
  String profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadMyPage();
  }

  Future<void> _loadMyPage() async {
    final loginController = Get.find<LoginController>();
    final userId = await loginController.getUserId();
    final token = await loginController.getAccessToken();

    if (userId != null && token != null) {
      await myPageController.fetchMyPageData();
      setState(() {
        name = myPageController.name;
        profileImage = myPageController.profileImage;
      });
    }
  }

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
                _buildProfileImage(profileImage),
                const SizedBox(height: 8),
                Text(
                  name,
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
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        final loginController = Get.find<LoginController>();
                        loginController.logout();
                      },
                      child: _SettingItem(text: '로그아웃'),
                    ),
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

Widget _buildProfileImage(String imageUrl) {
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
          child:
              imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Image.asset('lib/images/user.png', fit: BoxFit.cover),
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
