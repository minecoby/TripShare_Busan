import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

class ListPageView extends StatefulWidget {
  const ListPageView({super.key});

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  final List<String> _districts = [
    "중구",
    "동구",
    "영도구",
    "부산진구",
    "동래구",
    "남구",
    "북구",
    "해운대구",
    "사하구",
    "금정구",
    "강서구",
    "연제구",
    "수영구",
    "사상구",
    "기장군",
    "서구",
  ];

  String _selected = "중구";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 파란색 컨테이너 웨이브 모양양
          ClipPath(
            clipper: HJCustomClipper(),
            child: Container(
              color: MainColor,
              height: 255,
              width: double.infinity,
            ),
          ),
          // 검색 아이콘콘
          Positioned(
            top: 255 - 65 - 24, // 전체 높이 - r - icon의 길이 절반
            right: 65 - 24, // r - icon 길이 절반
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF595959),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // 상단 목록 + 작성 아이콘콘
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.list_rounded, color: Colors.white, size: 33),
                  const Icon(Icons.add_rounded, color: Colors.white, size: 33),
                ],
              ),
            ),
          ),
          Positioned(
            top: 255 - 65 - 24 - 40,
            right: 65 + 10,
            left: 20,
            child: SizedBox(
              height: 35,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _districts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final name = _districts[idx];
                  final selected = name == _selected;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = name),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: selected ? MainColor : const Color(0xFFADADAD),
                          fontWeight: selected ? FontWeight.bold : null,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HJCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const r = 65.0;
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(0, size.height)
          ..quadraticBezierTo(0, size.height - r, r, size.height - r)
          ..lineTo(size.width - r, size.height - r)
          ..quadraticBezierTo(
            size.width,
            size.height - r,
            size.width,
            size.height - 2 * r,
          )
          ..lineTo(size.width, 0)
          ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
