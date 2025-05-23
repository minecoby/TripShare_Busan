import 'package:get/get.dart';

import 'package:seagull/layout/navigationLayout.dart';

import 'package:seagull/pages/mainPage.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(name: '/main', page: () => NavigationLayout(child: MainPageView())),
  ];
}
