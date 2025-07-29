import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/pages/MakePage/rootPin.dart';
import 'package:get/get.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int num = 3;

  void increase() {
    if (num < 5) {
      setState(() => num++);
    }
  }

  void decrease() {
    if (num > 3) {
      setState(() => num--);
    }
  }

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
                      color: MainColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){Get.toNamed("/map");},
                      child: Icon(
                      Icons.keyboard_double_arrow_left_outlined,
                      color: Colors.white,
                      size: 30,
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: decrease,
                          child: Transform.translate(
                            offset: const Offset(0, -9),
                            child: Icon(
                              Icons.minimize_rounded,
                              color: num == 3 ? MainColor : Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '$num',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: increase,
                          child: Icon(
                            Icons.add_rounded,
                            color: num == 5 ? MainColor : Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            left: 15,
            right: 15,
            top: 75,
            child: Container(
              width: double.infinity,
              height: 608,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0xFF757575), width: 1),
              ),
              child: CustomPaint(child: RoadAnimatedWidget(num: num)),
            ),
          ),
        ],
      ),
    );
  }
}
