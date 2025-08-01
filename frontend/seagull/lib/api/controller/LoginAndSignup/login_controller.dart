import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:seagull/constants/url.dart';
import 'package:seagull/api/model/LoginAndSignUp/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        print('response.body: ${response.body}');
        var responseData = jsonDecode(response.body);
        var userData = responseData['data'];
        var userName = userData['username'];
        var userId = userData['userId'].toString();
        var accessToken = userData['token'];

        print('Access Token: $accessToken');
        print('userId: $userId');
        print('userName: $userName');

        //로그인 정보 저장
        await saveLoginInfo(accessToken, userId, userName);

        Get.offAllNamed('/main');
      } else {
        final data = json.decode(response.body);
        errorMessage.value = data['message'] ?? "아이디 또는 비밀번호가 틀렸습니다.";
      }
    } catch (e) {
      errorMessage.value = "서버와 연결할 수 없습니다.";
    }
  }

  Future<void> saveLoginInfo(
    String accessToken,
    String userId,
    String userName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('user_id', userId);
    await prefs.setString('user_name', userName);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // 저장된 모든 로그인 정보 삭제
    await prefs.remove('access_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');

    Get.offAllNamed('/login');
  }
}
