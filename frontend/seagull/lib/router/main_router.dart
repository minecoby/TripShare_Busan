import 'package:get/get.dart';

import 'package:seagull/layout/navigationLayout.dart';
import 'package:seagull/layout/noLayout.dart';
import 'package:seagull/pages/MakePage/mapPage.dart';
import 'package:seagull/pages/MakePage/rootPage.dart';
import 'package:seagull/pages/MakePage/rootPin.dart';
import 'package:seagull/pages/MakePage/writePage.dart';

import 'package:seagull/pages/mainPage.dart';
import 'package:seagull/pages/listPage.dart';
import 'package:seagull/pages/signupPage.dart';
import 'package:seagull/pages/summationPage.dart';
import 'package:seagull/pages/myPage.dart';
import 'package:seagull/pages/writtenPostsPage.dart';
import 'package:seagull/pages/likedPostsPage.dart';
import 'package:seagull/pages/loginPage.dart';

class MainRouter {
  static final List<GetPage> routes = [
    GetPage(name: '/login', page: () => NoLayout(child: LoginPage())),
    GetPage(name: '/signup', page: () => NoLayout(child: SignUpPage())),
    GetPage(name: '/main', page: () => NavigationLayout(child: MainPageView())),
    GetPage(name: '/list', page: () => NavigationLayout(child: ListPageView())),
    GetPage(name: '/summation', page: () => NoLayout(child: SummationPage())),
    GetPage(name: '/mypage', page: () => NavigationLayout(child: MyPageView())),
    GetPage(
      name: '/written',
      page: () => NavigationLayout(child: MyWrittenPostsPage()),
    ),
    GetPage(
      name: '/liked',
      page: () => NavigationLayout(child: MylikedPostsPage()),
    ),
    GetPage(name: '/write', page: () => NoLayout(child: WritePage())),
    GetPage(name: '/root', page: () => NoLayout(child: RootPage())),
    GetPage(name: '/map', page: () => NoLayout(child: MapPage())),
  ];
}
