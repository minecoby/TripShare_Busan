import 'package:flutter/material.dart';
import 'package:seagull/components/showmodal.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/components/postcard.dart';
import 'package:get/get.dart';

class ListPageView extends StatefulWidget {
  const ListPageView({super.key});

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: [
          Stack(
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
                      IconButton(
                        icon: const Icon(
                          Icons.list_rounded,
                          color: Colors.white,
                          size: 33,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.3),
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Color(
                                  0xFF696666,
                                ).withOpacity(0.8), // 투명 배경
                                insetPadding: EdgeInsets.zero, // 전체화면처럼
                                child: ShowModal(
                                  districts: _districts,
                                  onSelect: (selected) {
                                    setState(() => _selected = selected);

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          _scrollToSelectedDistrict(selected);
                                        });
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 33,
                      ),
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
                    controller: _scrollController,
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
                              color:
                                  selected
                                      ? MainColor
                                      : const Color(0xFFADADAD),
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
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder:
                      (context, index) => PostCard(
                        onTap: () {
                          Get.toNamed('/summation'); // 👈 여기만 바꾸면 됨!
                        },
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToSelectedDistrict(String name) {
    final index = _districts.indexOf(name);
    if (index == -1) return;

    const itemWidth = 90.0;
    final screenCenter = MediaQuery.of(context).size.width / 2;
    final scrollOffset = index * itemWidth - screenCenter + itemWidth / 2;

    _scrollController.animateTo(
      scrollOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
