import 'package:get/get.dart';

import 'package:seagull/layout/navigationLayout.dart';
import 'package:seagull/layout/noLayout.dart';

import 'package:seagull/pages/mainPage.dart';
import 'package:seagull/pages/listPage.dart';
import 'package:seagull/pages/summationPage.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(name: '/main', page: () => NavigationLayout(child: MainPageView())),
    GetPage(name: '/list', page: () => NavigationLayout(child: ListPageView())),
    GetPage(name: '/summation', page: () => NoLayout(child: SummationPage())),
  ];
}
