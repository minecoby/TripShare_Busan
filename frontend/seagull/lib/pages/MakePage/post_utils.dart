import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seagull/api/controller/PostPage/write_content_controller.dart';
import 'package:seagull/api/model/PostPage/write_content_model.dart';
import 'package:seagull/api/controller/LoginAndSignup/login_controller.dart';
import 'package:seagull/api/controller/PostPage/WriteContentController.dart';
import 'package:seagull/api/controller/PostPage/RouteController.dart';
import 'package:seagull/constants/url.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//주소에서 구 이름 추출
String extractRegionNameFromList(List<LocationDto> locations) {
  for (final location in locations) {
    final address = location.address.trim();
    if (address.isNotEmpty) {
      final parts = address.split(' ');
      if (parts.length >= 2) {
        final gu = parts[1];
        if (gu.endsWith('구') || gu.endsWith('군')) return gu;
      }
    }
  }
  return ""; // 유효한 주소가 없을 경우
}

//이미지 업로드 함수
Future<String?> uploadImageToCloudinary(File file) async {
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  final url = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
  );

  final request =
      http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

  try {
    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(resBody);
      return json['secure_url']; // 업로드된 이미지의 https URL
    } else {
      print("Cloudinary 업로드 실패: ${response.statusCode}");
      print(resBody);
      return null;
    }
  } catch (e) {
    print("Cloudinary 업로드 예외: $e");
    return null;
  }
}

bool isAddressInBusan(String address) {
  return address.trim().startsWith('부산');
}

//게시글 + 루트 동시 등록
Future<bool> submitPostWithRoute() async {
  final postController = Get.put(PostApiController());
  final writeController = Get.find<WriteContentController>();
  final placeController = Get.find<PlaceTimelineController>();

  final userId = int.parse(await LoginController().getUserId() ?? '0');
  final title = writeController.titleController.value.text;
  final content = writeController.contents
      .where((e) => e["type"] == "text")
      .map((e) => (e["controller"] as TextEditingController).text)
      .join('\n');

  // 제목 확인
  if (title.isEmpty) {
    Get.snackbar("입력 오류", "제목을 입력해주세요.");
    return false;
  }

  // 내용 확인
  if (content.isEmpty) {
    Get.snackbar("입력 오류", "내용을 작성해주세요.");
    return false;
  }

  final locations = <LocationDto>[];

  for (int i = 0; i < placeController.num.value; i++) {
    final name = placeController.titleControllers[i].text.trim();
    final address = placeController.addressControllers[i].text.trim();

    final imageFile = placeController.imageFiles[i];

    if (name.isEmpty) {
      Get.snackbar("입력 오류", "${i + 1}번 루트의 장소 이름을 입력해주세요.");
      return false;
    }

    // 주소 확인
    if (address.isEmpty) {
      Get.snackbar("입력 오류", "${i + 1}번 루트의 주소를 입력해주세요.");
      return false;
    }

    // 사진 확인
    if (imageFile == null) {
      Get.snackbar("입력 오류", "${i + 1}번 루트의 사진을 등록해주세요.");
      return false;
    }

    if (!isAddressInBusan(address)) {
      Get.snackbar("입력 오류", "${i + 1}번 루트의 주소가 부산이 아닙니다.");
      return false;
    }

    locations.add(
      LocationDto(
        locationName: name,
        address: address,
        imageUrl: imageFile.path.split('/').last,
        orderIndex: i + 1,
      ),
    );
  }

  final regionName = extractRegionNameFromList(locations);

  final request = PostCreateRequest(
    title: title,
    content: content,
    userId: userId,
    regionName: regionName,
    locations: locations,
  );

  print("📝 제목: $title");
  print("📄 내용:\n$content");
  print("🧍 사용자 ID: $userId");
  print("📍 지역 이름: $regionName");

  for (int i = 0; i < locations.length; i++) {
    final loc = locations[i];
    print("🔹 [${i + 1}번 루트]");
    print("   - 장소명: ${loc.locationName}");
    print("   - 주소: ${loc.address}");
    print("   - 이미지 URL: ${loc.imageUrl}");
    print("   - 순서: ${loc.orderIndex}");
  }

  final success = await postController.submitPost(request);
  return success;

  // return true;
}
