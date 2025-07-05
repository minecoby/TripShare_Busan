import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:seagull/constants/url.dart';
import 'package:seagull/model/login_model.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final idController = TextEditingController();
  final pwController = TextEditingController();

  var errorMessage = ''.obs;

  void login() async {
    errorMessage.value = '';

    // 입력값 검사
    if (idController.text.isEmpty || pwController.text.isEmpty) {
      errorMessage.value = "아이디와 비밀번호 모두 입력해주세요.";
      return;
    }

    final user = UserModel(id: idController.text, password: pwController.text);

    try {
      final response = await http.post(
        Uri.parse('${Urls.apiUrl}users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/main');
      } else {
        final data = json.decode(response.body);
        errorMessage.value = data['message'] ?? "아이디 또는 비밀번호가 틀렸습니다.";
      }
    } catch (e) {
      errorMessage.value = "서버와 연결할 수 없습니다.";
    }
  }
}
