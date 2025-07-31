import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seagull/api/model/PostPage/root_summation_model.dart';
import 'package:seagull/constants/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class RouteController extends GetxController {
  RouteModel? route;

  Future<RouteModel> fetchRoute(int routeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('Access token이 존재하지 않습니다.');
    }

    final uri = Uri.parse('${Urls.apiUrl}routes/$routeId');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return RouteModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('루트 조회 실패: ${response.statusCode}');
    }
  }
}
