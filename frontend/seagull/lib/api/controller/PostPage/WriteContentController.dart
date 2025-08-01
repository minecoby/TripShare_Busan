import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriteContentController extends GetxController {
  RxList<Map<String, dynamic>> contents = <Map<String, dynamic>>[].obs;
  final Rx<TextEditingController> titleController = TextEditingController().obs;

  void initIfEmpty() {
    if (contents.isEmpty) {
      contents.add({"type": "text", "controller": TextEditingController()});
    }
  }

  void addImageAt(int index, File imageFile, {String? afterText}) {
    int offset = 0;

    // 현재 아이템이 텍스트인 경우
    if (contents[index]["type"] == "text") {
      final controller = contents[index]["controller"] as TextEditingController;
      final fullText = controller.text;
      final selection = controller.selection;

      final hasCursor = selection.isValid && selection.start != -1;

      final beforeText =
          hasCursor ? fullText.substring(0, selection.start) : fullText;
      final after = hasCursor ? fullText.substring(selection.end) : "";

      final isTotallyEmpty = beforeText.trim().isEmpty && after.trim().isEmpty;

      if (isTotallyEmpty) {
        contents.removeAt(index);
        offset = 0;
      } else if (hasCursor) {
        controller.text = beforeText;
        offset = 1;
      } else {
        index = contents.length;
        offset = 0;
      }

      contents.insert(index + offset, {
        "type": "image",
        "file": imageFile,
        "alignment": Alignment.center,
      });

      contents.insert(index + offset + 1, {
        "type": "text",
        "controller": TextEditingController(text: afterText ?? after),
      });
    }
  }

  void removeAt(int index) {
    final isPrevText = index > 0 && contents[index - 1]["type"] == "text";
    final isNextText =
        index < contents.length - 1 && contents[index + 1]["type"] == "text";

    if (isPrevText && isNextText) {
      final prev = contents[index - 1]["controller"] as TextEditingController;
      final next = contents[index + 1]["controller"] as TextEditingController;
      prev.text += next.text;
      contents.removeAt(index + 1);
      contents.removeAt(index);
    } else {
      contents.removeAt(index);
    }
  }

  void reset() {
    for (var item in contents) {
      if (item["type"] == "text") {
        (item["controller"] as TextEditingController).dispose();
      }
    }
    contents.clear();
    titleController.value.clear();
  }
}
