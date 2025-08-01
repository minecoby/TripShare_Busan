import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:seagull/api/model/PostPage/write_content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seagull/constants/url.dart';

class PostApiController extends GetxController {
  final errorMessage = ''.obs;

  Future<bool> submitPost(PostCreateRequest post) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    errorMessage.value = '';

    if (token == null) {
      errorMessage.value = '로그인이 필요합니다.';
      return false;
    }

    final uri = Uri.parse('${Urls.apiUrl}posts');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      errorMessage.value = '서버 오류: ${response.statusCode}';
      return false;
    }
  }
}
