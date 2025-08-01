import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> imageData = [
    {'path': 'assets/images/busan/junggu.png', 'district': '중구'},
    {'path': 'assets/images/busan/seogu.png', 'district': '서구'},
    {'path': 'assets/images/busan/donggu.png', 'district': '동구'},
    {'path': 'assets/images/busan/yeongdogu.png', 'district': '영도구'},
    {'path': 'assets/images/busan/busanjin.png', 'district': '부산진구'},
    {'path': 'assets/images/busan/dongnaegu.png', 'district': '동래구'},
    {'path': 'assets/images/busan/namgu.png', 'district': '남구'},
    {'path': 'assets/images/busan/bukgu.png', 'district': '북구'},
    {'path': 'assets/images/busan/haeundae.png', 'district': '해운대구'},
    {'path': 'assets/images/busan/sahagu.png', 'district': '사하구'},
    {'path': 'assets/images/busan/geumjeong.png', 'district': '금정구'},
    {'path': 'assets/images/busan/gangseo.png', 'district': '강서구'},
    {'path': 'assets/images/busan/yeonje.png', 'district': '연제구'},
    {'path': 'assets/images/busan/suyeong.png', 'district': '수영구'},
    {'path': 'assets/images/busan/sasang.png', 'district': '사상구'},
    {'path': 'assets/images/busan/gijang.png', 'district': '기장군'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: Column(
        children: [
          const SizedBox(height: 90),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: [
                // 검색창
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      Icon(Icons.search, color: MainColor, size: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // 기능 아이콘 4개
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // 도시 선택 탭
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      height: 25,
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MainColor,
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.white,
                        unselectedLabelColor: MainColor,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 3,
                              ),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 3,
                              ),
                              child: Text(
                                'Popular',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 3,
                              ),
                              child: Text(
                                'Recommend',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        contentGrid(imageData),
                        contentGrid([]),
                        contentGrid([]),
                      ],
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

  Widget contentGrid(List<Map<String, String>> data) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final item = data[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed('/list', arguments: item['district']);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(item['path']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
