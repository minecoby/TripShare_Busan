import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

class SummationPage extends StatelessWidget {
  const SummationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      color: Colors.black.withOpacity(0.25), // 25% 투명도
                      offset: const Offset(0, 4), // X: 0, Y: 4
                      blurRadius: 4, // Blur: 4
                      spreadRadius: 0, // Spread: 0
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
                      color: Colors.white, // 반투명 배경
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        margin: EdgeInsets.only(
                          right: index == 4 ? 0 : 15,
                        ), // 마지막은 margin 없음
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
