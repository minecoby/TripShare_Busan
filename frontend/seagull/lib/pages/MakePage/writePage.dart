import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> contents = [
    {"type": "text", "controller": TextEditingController()},
  ];

  Future<void> _pickImages(int insertIndex) async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var picked in pickedFiles) {
        contents.insert(insertIndex + 1, {
          "type": "image",
          "file": File(picked.path),
          "alignment": Alignment.center,
        });
        contents.insert(insertIndex + 2, {
          "type": "text",
          "controller": TextEditingController(),
        });
        insertIndex += 2;
      }
      setState(() {});
    }
  }

  void _removeItem(int index) {
    setState(() => contents.removeAt(index));
  }

  void _changeAlignment(int index, Alignment alignment) {
    setState(() {
      contents[index]["alignment"] = alignment;
    });
  }

  Widget _buildImageWidget(Map<String, dynamic> item, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: item["alignment"],
          child: Image.file(item["file"], width: 250),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.format_align_left),
              onPressed: () => _changeAlignment(index, Alignment.centerLeft),
            ),
            IconButton(
              icon: Icon(Icons.format_align_center),
              onPressed: () => _changeAlignment(index, Alignment.center),
            ),
            IconButton(
              icon: Icon(Icons.format_align_right),
              onPressed: () => _changeAlignment(index, Alignment.centerRight),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeItem(index),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
            child: Column(
              children: [
                //상단바
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_square,
                            color: Colors.white,
                            size: 16,
                          ),
                          const Text(
                            ' 메인글작성',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed("/root"),
                            child: const Text(
                              '코스 설정',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.offAllNamed("/list"),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),

                Transform.rotate(
                  angle: -2.44 * 3.141592 / 180,
                  child: Container(
                    width: 366,
                    height: 608,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8D8D8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF757575),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed("/root"),
                    child: const Icon(
                      Icons.keyboard_double_arrow_right_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 15,
            right: 15,
            top: 75,
            child: Container(
              width: double.infinity,
              height: 608,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF757575), width: 1),
              ),
              child: ListView.builder(
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  final item = contents[index];
                  if (item["type"] == "text") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: item["controller"],
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: '내용을 입력하세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                            isCollapsed: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  } else if (item["type"] == "image") {
                    return _buildImageWidget(item, index);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () => _pickImages(contents.length - 1),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE2EF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
