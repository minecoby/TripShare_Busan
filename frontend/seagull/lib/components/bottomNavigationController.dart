import 'package:get/get.dart';

class MyBottomNavigationController extends GetxController {
  static MyBottomNavigationController get to => Get.find();

  final RxInt selectedIndex = 1.obs;

  void changeIndex(int index) {
    selectedIndex(index);
    switch (index) {
      case 0:
        Get.toNamed('/list');
        break;
      case 1:
        Get.toNamed('/main');
        break;
      case 2:
        Get.toNamed('/main');
        break;
    }
  }
}
