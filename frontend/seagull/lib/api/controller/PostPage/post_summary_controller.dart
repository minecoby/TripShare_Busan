import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seagull/api/model/PostPage/post_summary_model.dart';
import 'package:seagull/constants/url.dart';
import 'package:get/get.dart';

class PostSummaryController extends GetxController {
  PostDetail? post;

  Future<void> fetchPost(int postId) async {
    final uri = Uri.parse("${Urls.apiUrl}posts/$postId");
    print("요청 URI: $uri");

    try {
      final response = await http.get(uri);
      print("statusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("response.body: ${response.body}");

        post = PostDetail.fromJson(data['data']);
      } else {
        print("게시글을 불러오는 데 실패했습니다");
      }
    } catch (e) {
      print("네트워크 오류 발생: $e");
    }
  }
}
