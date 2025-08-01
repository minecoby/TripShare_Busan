import 'package:get/get.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs;
  var selectedDistrict = ''.obs;

  void goToList(String district) {
    selectedDistrict.value = district;
    currentIndex.value = 1;
  }
}
