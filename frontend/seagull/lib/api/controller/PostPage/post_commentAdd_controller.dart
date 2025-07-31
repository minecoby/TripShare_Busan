import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:seagull/api/model/PostPage/post_commentAdd_model.dart';
import 'package:seagull/api/model/PostPage/post_summary_model.dart';
import 'package:seagull/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentController extends GetxController {
  var comments = <Comment>[].obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchComments(int postId) async {
    try {
      final response = await http.get(Uri.parse('${Urls.apiUrl}comments?postId=$postId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        comments.value = jsonList.map((e) => Comment.fromJson(e)).toList();
      } else {
        errorMessage.value = '댓글 불러오기 실패';
      }
    } catch (e) {
      errorMessage.value = '서버와의 연결이 불안정합니다.';
    }
  }

  Future<void> addComment(CommentAdd comment) async {
    errorMessage.value = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final uri = Uri.parse('${Urls.apiUrl}comments');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(comment.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchComments(comment.postId);
      } else {
        errorMessage.value = '댓글 작성 실패: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = '네트워크 오류가 발생했습니다.';
    }
  }
}
