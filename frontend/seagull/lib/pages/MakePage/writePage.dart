import 'package:flutter/material.dart';
import 'package:seagull/api/controller/LoginAndSignup/login_controller.dart';
import 'package:seagull/api/controller/PostPage/RouteController.dart';
import 'package:seagull/api/controller/PostPage/write_content_controller.dart';
import 'package:seagull/api/model/PostPage/write_content_model.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:seagull/api/controller/PostPage/WriteContentController.dart';
import 'package:seagull/pages/MakePage/post_utils.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  @override
  void initState() {
    super.initState();
    writeController = Get.put(WriteContentController());
    writeController.initIfEmpty();
  }

  final ImagePicker _picker = ImagePicker();

  final TextEditingController contentController = TextEditingController();

  late final WriteContentController writeController;
  // final List<File> images = [];

  // List<Map<String, dynamic>> contents = [
  //   {"type": "text", "controller": TextEditingController()},
  // ];

  Future<void> _pickImages(int insertIndex) async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var picked in pickedFiles) {
        writeController.addImageAt(insertIndex, File(picked.path));
      }
    }
  }

  // Future<void> _pickImages(int insertIndex) async {
  //   final currentItem = contents[insertIndex];

  //   if (currentItem["type"] == "text") {
  //     final controller = currentItem["controller"] as TextEditingController;
  //     final fullText = controller.text;
  //     final selection = controller.selection;

  //     final bool hasCursor = selection.isValid && selection.start != -1;

  //     final beforeText =
  //         hasCursor ? fullText.substring(0, selection.start) : fullText;
  //     final afterText = hasCursor ? fullText.substring(selection.end) : "";

  //     final List<XFile> pickedFiles = await _picker.pickMultiImage();

  //     if (pickedFiles.isNotEmpty) {
  //       int offset = 0;

  //       // 커서 없고 내용도 없으면, 텍스트필드 제거
  //       final isTotallyEmpty =
  //           beforeText.trim().isEmpty && afterText.trim().isEmpty;
  //       if (isTotallyEmpty) {
  //         writeController.contents.removeAt(insertIndex);
  //         offset = 0;
  //       } else if (hasCursor) {
  //         controller.text = beforeText;
  //         offset = 1;
  //       } else {
  //         // 커서 없고 내용이 있는 경우: 그냥 맨 끝에 추가
  //         insertIndex = writeController.contents.length;
  //         offset = 0;
  //       }

  //       for (var picked in pickedFiles) {
  //         writeController.contents.insert(insertIndex + offset, {
  //           "type": "image",
  //           "file": File(picked.path),
  //           "alignment": Alignment.center,
  //         });
  //         offset++;
  //       }

  //       // 뒤에 텍스트필드 추가 (커서 있든 없든 afterText 포함 or 빈 필드라도 생성)
  //       writeController.contents.insert(insertIndex + offset, {
  //         "type": "text",
  //         "controller": TextEditingController(text: afterText),
  //       });

  //       setState(() {});
  //     }
  //   }
  // }

  // void _removeItem(int index) {
  //   setState(() {
  //     // 앞뒤 텍스트인지 확인
  //     final isPrevText = index > 0 && writeController.contents[index - 1]["type"] == "text";
  //     final isNextText =
  //         index < writeController.contents.length - 1 && writeController.contents[index + 1]["type"] == "text";

  //     if (isPrevText && isNextText) {
  //       final prevController =
  //           writeController.contents[index - 1]["controller"] as TextEditingController;
  //       final nextController =
  //           writeController.contents[index + 1]["controller"] as TextEditingController;

  //       // 내용 합치기
  //       prevController.text = "${prevController.text}${nextController.text}";

  //       // 순서 중요: 뒤 -> 가운데 -> 앞 제거
  //       writeController.contents.removeAt(index + 1); // 다음 텍스트
  //       contents.removeAt(index); // 이미지
  //     } else {
  //       // 그냥 제거만
  //       writeController.contents.removeAt(index);
  //     }
  //   });
  // }

  bool showInitialTextField() {
    return writeController.contents.length == 1 &&
        writeController.contents[0]["type"] == "text" &&
        (writeController.contents[0]["controller"]?.text.isEmpty ?? true);
  }

  Widget _buildImageWithDeleteButton(Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                item["file"],
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => writeController.removeAt(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
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
                          GestureDetector(
                            onTap: () async {
                              final success = await submitPostWithRoute(
                              );

                              if (success) {
                                Get.find<WriteContentController>().reset();
                                Get.find<PlaceTimelineController>().onClose();
                                Get.offAllNamed("/list");
                                Get.snackbar("완료", "게시글과 루트가 함께 등록되었습니다");
                              } else {
                                final msg =
                                    Get.find<PostApiController>()
                                        .errorMessage
                                        .value;
                                Get.snackbar("실패", msg);
                              }
                            },
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            ),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: writeController.titleController.value,
                      decoration: InputDecoration(
                        hintText: ' 제목',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        isCollapsed: true,

                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 213, 205, 205),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(5, 8, 5, 15),
                      child: Divider(height: 2, color: Color(0xFFE4E4E4)),
                    ),
                    // TextField(
                    //   controller: contentController,
                    //   maxLines: null,
                    //   style: const TextStyle(fontSize: 16, color: TextColor),
                    //   decoration: InputDecoration(
                    //     hintText: '추천하고 싶은 코스를 글로 남겨보세요!',
                    //     border: InputBorder.none,
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    //     isCollapsed: true,
                    //     hintStyle: TextStyle(
                    //       color: Color.fromARGB(255, 213, 205, 205),
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    // ),
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: writeController.contents.length,
                        itemBuilder: (context, index) {
                          final item = writeController.contents[index];
                          if (item["type"] == "text") {
                            // 모든 텍스트필드가 비어있을 때만 안내 문구 변경
                            final bool allEmpty = writeController.contents
                                .every(
                                  (e) =>
                                      e["type"] == "text" &&
                                      (e["controller"]?.text?.trim().isEmpty ??
                                          true),
                                );

                            return TextField(
                              controller: item["controller"],
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 16,
                                color: TextColor,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    allEmpty
                                        ? '추천하고 싶은 코스를 글로 남겨보세요!'
                                        : '내용을 입력하세요',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                isCollapsed: true,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 213, 205, 205),
                                  fontSize: 15,
                                ),
                              ),
                            );
                          } else if (item["type"] == "image") {
                            return _buildImageWithDeleteButton(item, index);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () => _pickImages(writeController.contents.length - 1),
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
