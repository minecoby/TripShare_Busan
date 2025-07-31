import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seagull/api/model/post_model.dart';
import 'package:seagull/constants/url.dart'; // ✅ 이거 추가!

class PostController {
  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse('${Urls.apiUrl}posts'); // ✅ 이 부분 반영
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
