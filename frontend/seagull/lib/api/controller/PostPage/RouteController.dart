import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PlaceTimelineController extends GetxController {
  RxInt num = 3.obs;

  RxList<TextEditingController> titleControllers =
      <TextEditingController>[].obs;
  RxList<TextEditingController> addressControllers =
      <TextEditingController>[].obs;
  RxList<File?> imageFiles = <File?>[].obs;

  void initialize(int count) {
    num.value = count;
    titleControllers.value = List.generate(
      count,
      (_) => TextEditingController(),
    );
    addressControllers.value = List.generate(
      count,
      (_) => TextEditingController(),
    );
    imageFiles.value = List<File?>.filled(count, null);
  }

  void updateImage(int index, File file) {
    if (index >= 0 && index < imageFiles.length) {
      imageFiles[index] = file;
      imageFiles.refresh();
    }
  }

  @override
  void onClose() {
    for (final controller in titleControllers) {
      controller.dispose();
    }
    for (final controller in addressControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
