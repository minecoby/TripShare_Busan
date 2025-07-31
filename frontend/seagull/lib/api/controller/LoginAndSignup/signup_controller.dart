import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:seagull/constants/url.dart';
import 'package:seagull/api/model/LoginAndSignUp/signup_model.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  var errorMessage = ''.obs;

  final specialCharReg = RegExp(r'[!@^#\$%&*(),.?":{}|<>]');

  void signUp() async {
    errorMessage.value = '';

    String apiUrl = '${Urls.apiUrl}users/signup';
    final user = UserModel(
      id: idController.text,
      password: pwController.text,
      name: nameController.text,
      email: emailController.text,
      // code: codeController.text,
    );

    try {
      if (nameController.text.isEmpty ||
          idController.text.isEmpty ||
          pwController.text.isEmpty ||
          emailController.text.isEmpty) {
        errorMessage.value = "모두 항목을 입력해주세요.";
        return;
      }

      if (specialCharReg.hasMatch(nameController.text)) {
        errorMessage.value = "이름에는 특수문자를 사용할 수 없습니다.";
        return;
      }
      if (specialCharReg.hasMatch(idController.text)) {
        errorMessage.value = "아이디에는 특수문자를 사용할 수 없습니다.";
        return;
      }

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/login');
      } else {
        final data = json.decode(response.body);
        errorMessage.value = data['message'] ?? "회원가입에 실패했습니다.";
      }
    } catch (e) {
      errorMessage.value = "서버와 연결할 수 없습니다.";
    }
  }
}
