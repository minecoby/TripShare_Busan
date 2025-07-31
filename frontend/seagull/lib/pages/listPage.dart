import 'package:flutter/material.dart';
import 'package:seagull/components/postcard.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/api/controller/post_controller.dart';
import 'package:seagull/api/model/post_model.dart';
import 'package:get/get.dart';
import 'package:seagull/components/showmodal.dart';

class ListPageView extends StatefulWidget {
  const ListPageView({super.key});

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  late ScrollController _scrollController;
  final List<String> _districts = [
    "전체",
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
  String _selected = "전체";

  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchPosts() async {
    try {
      final controller = PostController();
      final posts = await controller.fetchPosts();

      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      print('게시글 로딩 실패: $e');
    }
  }

  List<Post> get filteredPosts {
    if (_selected == "전체") return _posts;
    return _posts.where((post) => post.region == _selected).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: HJCustomClipper(),
                child: Container(
                  color: MainColor,
                  height: 255,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 255 - 65 - 24,
                right: 65 - 24,
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
                                backgroundColor: const Color(
                                  0xFF696666,
                                ).withOpacity(0.8),
                                insetPadding: EdgeInsets.zero,
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
                      GestureDetector(
                        onTap : () {
                          Get.toNamed("/write");
                        },
                        child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 33,
                      ),)
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
                        onTap: () {
                          setState(() {
                            _selected = name;
                            _isLoading = true;
                          });
                          _fetchPosts();
                        },

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
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = filteredPosts[index];
                            return PostCard(
                              onTap:
                                  () => Get.toNamed(
                                    '/summation',
                                    arguments: post.id,
                                  ),
                              title: post.title,
                              nickname: post.userName,
                              region: post.region,
                              likeCount: post.likeCount,
                              commentCount: post.commentCount,
                            );
                          },
                        ),
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
