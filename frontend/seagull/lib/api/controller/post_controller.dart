import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seagull/api/model/post_model.dart';
import 'package:seagull/constants/url.dart';

class PostController {
  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse('${Urls.apiUrl}posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];

      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
