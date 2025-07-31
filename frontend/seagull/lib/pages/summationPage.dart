import 'package:flutter/material.dart';
import 'package:seagull/api/controller/PostPage/post_route_controller.dart';
import 'package:seagull/api/controller/PostPage/post_summary_controller.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/pages/detailPage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummationPage extends StatefulWidget {
  const SummationPage({super.key});

  @override
  State<SummationPage> createState() => _SummationPageState();
}

class _SummationPageState extends State<SummationPage> {
  final PostSummaryController _postSummaryController = Get.put(
    PostSummaryController(),
  );
  int postId = 0;

  // final RouteController _routeController = Get.put(RouteController());

  String errormessage = '';

  @override
  void initState() {
    super.initState();
    postId = Get.arguments as int;
    _loadPost();
  }

  Future<void> _loadPost() async {
    await _postSummaryController.fetchPost(postId);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    // if (token != null && _postSummaryController.post?.routeId != null) {
    //   try {
    //     await _routeController.fetchRoute(_postSummaryController.post!.routeId!);
    //   } catch (e) {
    //     errormessage = "루트 정보 불러오기를 실패하였습니다";
    //   }
    // } else {
    //   errormessage = "🔒 루트 정보는 로그인 후 확인할 수 있습니다.\n로그인 후 다시 확인해주세요!";
    // }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final post = _postSummaryController.post;
    // final route = _routeController.route;

    if (post == null) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.face_2, size: 50, color: MainColor),
                Text(
                  "게시글을 찾을 수 없습니다\n다시시도해주세요",
                  style: TextStyle(fontSize: 14, color: SubTextColor),
                ),
              ],
            ),
            Positioned(
              top: 15,
              left: 15,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.undo_rounded,
                    color: Color(0xFF757575),
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 330,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: const DecorationImage(
                        image: AssetImage('images/sea.jpg'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4), // X: 0, Y: 4
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.undo_rounded,
                          color: Color(0xFF757575),
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 25,
                    right: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: PageUserData(post.title, post.userName),
                        ),
                        SizedBox(width: 10),
                        LikeCount(0),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.summary,
                      style: TextStyle(
                        color: TextColor,
                        fontSize: 14,
                        height: 22 / 14,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      '🌱 나의 여행 루트',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // route != null
                    //     ? SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: route.locations
                    //         .map((loc) => Container(
                    //       height: 130,
                    //       width: 215,
                    //       margin: const EdgeInsets.only(right: 15),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(12),
                    //         image: DecorationImage(
                    //           image: NetworkImage(loc.imageUrl),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(loc.locationName,
                    //                 style: const TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold)),
                    //             Text(loc.address,
                    //                 style: const TextStyle(color: Colors.white)),
                    //           ],
                    //         ),
                    //       ),
                    //     ))
                    //         .toList(),
                    //   ),
                    // )
                    //     : Text(errormessage, style: const TextStyle(color: SubTextColor, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.25,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: 30,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        children: [PostDetailPage(post: post)],
                      ),
                    ),

                    const Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 50,
                          height: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PageUserData extends StatelessWidget {
  final String title, name;
  const PageUserData(this.title, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Text(
              '| $name',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class LikeCount extends StatefulWidget {
  final int cnt;
  const LikeCount(this.cnt, {super.key});

  @override
  State<LikeCount> createState() => _LikeCountState();
}

class _LikeCountState extends State<LikeCount> {
  late int count;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    count = widget.cnt;
  }

  void toggleLike() {
    setState(() {
      liked = !liked;
      count += liked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLike,
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}
