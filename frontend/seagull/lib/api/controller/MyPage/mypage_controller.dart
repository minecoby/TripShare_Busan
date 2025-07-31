import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:seagull/constants/url.dart';
import 'package:seagull/api/controller/LoginAndSignup/login_controller.dart';
import 'package:seagull/api/model/MyPage/mypage_model.dart';

class MyPageController extends GetxController {
  String name = '';
  String profileImage = '';

  /// 로그인된 상태에서만 호출되므로 userId/token은 null 체크 생략해도 됨
  Future<void> fetchMyPageData() async {

    try {
      final loginController = Get.find<LoginController>();
      final userId = await loginController.getUserId();
      final token = await loginController.getAccessToken();


      final uri = Uri.parse('${Urls.apiUrl}users/$userId/mypage');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = MyPageInfo.fromJson(data);

        name = user.name;
        profileImage = user.profileImage;
      } else {
        name = '서버 오류';
      }
    } catch (e) {
      name = '요청 실패: $e';
    }
  }
}
