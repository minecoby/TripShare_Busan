import 'package:flutter/material.dart';
import 'package:seagull/components/bottomNavigationController.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';

class MyBottomNavigation extends GetView<MyBottomNavigationController> {
  const MyBottomNavigation({super.key});

  static const double r = 8.5; // 흰색 동그라미 반지름 -> 전체 높이는 17이 되도록
  static const double h = 50; // 네비게이션 바 높이

  static const _icons = [
    Icons.edit_rounded, // 목록 아이콘
    Icons.home_filled, // 홈 아이콘
    Icons.person_rounded, // 마이페이지지
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = controller.selectedIndex.value;

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 흰색 네비게이션 바의 그림자 설정
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MainColor.withOpacity(0),
                      MainColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: h - 8.5, // 네비바 상단 y = bottom+h
            child: SizedBox(
              height: r * 2, // 반원 영역만큼
              child: CustomPaint(
                painter: _CircleTopShadowPainter(
                  radius: r + 3,
                  itemCount: _icons.length,
                  selectedIndex: sel,
                ),
              ),
            ),
          ),

          // 凸 모양
          PhysicalShape(
            elevation: 20, // z축
            color: Colors.white, // 잘린 모양 -> 흰색
            shadowColor: MainColor.withOpacity(0.25),
            clipBehavior: Clip.antiAlias, // 잘린 테두리를 부드럽게
            clipper: DynamicBumpClipper(
              // 어떻게 오려낼 것인가가
              bumpRadius: r, // 흰색 원 크기
              barHeight: h, // 네비게이션 바 높이이
              itemCount: _icons.length,
              selectedIndex: sel,
            ),
            child: SizedBox(
              height: h + r, // 하단 높이 + 반원 높이 만큼의 크기
              child: Padding(
                padding: EdgeInsets.only(top: r),
                child: _NavContent(
                  icons: _icons,
                  mainColor: MainColor,
                  bumpRadius: r,
                  currentIndex: sel,
                  onTap: controller.changeIndex,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class DynamicBumpClipper extends CustomClipper<Path> {
  final double bumpRadius; // 흰색 반원의 반지름 높이
  final double barHeight; // 네비게이션 바 높이
  final int itemCount;
  final int selectedIndex;

  DynamicBumpClipper({
    required this.bumpRadius,
    required this.barHeight,
    required this.itemCount,
    required this.selectedIndex,
  });

  @override
  Path getClip(Size size) {
    final Path p = Path();

    final double gap = size.width / itemCount; // 전체 가로 폭 에서 아이콘 하나 당 차지 칸 계산산
    final double wcX = gap * (selectedIndex + 0.5); // 흰색 반원의 중심 좌표 계산산
    final double top = bumpRadius;

    p.moveTo(0, top); // 시작점에서 반원의 높이 만큼 내려 온 곳에서 시작
    p.lineTo(wcX - bumpRadius, top);

    p.arcToPoint(
      Offset(wcX + bumpRadius, top),
      radius: Radius.circular(bumpRadius),
      clockwise: true, // 위로 볼록
    );

    p.lineTo(size.width, top);
    p.lineTo(size.width, top + barHeight);
    p.lineTo(0, top + barHeight);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(DynamicBumpClipper old) =>
      old.selectedIndex != selectedIndex ||
      old.itemCount != itemCount ||
      old.bumpRadius != bumpRadius ||
      old.barHeight != barHeight;
}

class _NavContent extends StatelessWidget {
  const _NavContent({
    required this.icons,
    required this.mainColor,
    required this.bumpRadius,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> icons;
  final Color mainColor;
  final double bumpRadius;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(icons.length, (i) {
        final selected = i == currentIndex;

        return Expanded(
          child: InkWell(
            onTap: () => onTap(i),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // 파란 점이 위로 나가도록
              children: [
                if (selected)
                  Positioned(
                    top: -bumpRadius - 3.5, // bump 원 중앙
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: mainColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                // 아이콘 (선택 시 위로 이동)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(0, selected ? -4 : 0, 0),
                  child: Icon(
                    icons[i],
                    size: selected ? 30 : 26,
                    color: selected ? mainColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _CircleTopShadowPainter extends CustomPainter {
  final double radius;
  final int itemCount;
  final int selectedIndex;

  _CircleTopShadowPainter({
    required this.radius,
    required this.itemCount,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas c, Size s) {
    final gap = s.width / itemCount;
    final cx = gap * (selectedIndex + 0.5);
    final cy = radius;

    final Path circlePath =
        Path()
          ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: radius));

    c.save();
    c.translate(0, -radius);
    c.drawShadow(circlePath, MainColor.withOpacity(0.8), 20, true);
    c.restore();
  }

  @override
  bool shouldRepaint(covariant _CircleTopShadowPainter old) =>
      old.selectedIndex != selectedIndex ||
      old.itemCount != itemCount ||
      old.radius != radius;
}
