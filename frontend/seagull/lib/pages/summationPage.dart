import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/pages/detailPage.dart';

class SummationPage extends StatelessWidget {
  const SummationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                        image: AssetImage('lib/images/sea.jpg'),
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
                        Expanded(child: PageUserData('광안리로 떠나다', '김효정')),
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
                    const Text(
                      '화명동은 부산 북구에 위치한 주거 중심지로, 금정산과 낙동강 사이에 자리 잡아 자연과 도시가 조화를 이루는 지역입니다. '
                      '2000년대 화명 신시가지 개발로 대규모 아파트 단지가 조성되며 인구가 급증하였고, 현재는 화명 1·2·3동으로 나뉘어 있습니다.',
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          5,
                          (index) => Container(
                            height: 130,
                            width: 215,
                            margin: EdgeInsets.only(right: index == 4 ? 0 : 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 87, 87, 87),
                      offset: Offset(0, -4), // X: 0, Y: 4
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
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
                        children: const [PostDetailPage()],
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
