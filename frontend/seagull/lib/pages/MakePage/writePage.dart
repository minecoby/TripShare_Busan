import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 0,
              left: 15,
              right: 15,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 14, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.edit_square,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            ' 메인글작성',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            '코스 설정',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.close, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Icon(Icons.check, color: Colors.white, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),

                Transform.rotate(
                  angle: -2.44 * 3.141592 / 180,
                  child: Container(
                    width: 366,
                    height: 608,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFD8D8D8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFF757575), width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.keyboard_double_arrow_right_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          // 하단 좌측: 이미지 추가 버튼
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFFDDE2EF),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            top: 75,
            child: Container(
              width: double.infinity,
              height: 608,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0xFF757575), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      hintText: '제목',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15),
                      isCollapsed: true,

                      hintStyle: TextStyle(
                        color: Color(0xFFF4EBEB),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(height: 1, color: Color(0xFFE4E4E4)),
                  SizedBox(height: 15),
                  TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '추천하고 싶은 코스를 글로 남겨보세요!',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15),
                      isCollapsed: true,
                      hintStyle: TextStyle(
                        color: Color(0xFFE4E4E4),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
