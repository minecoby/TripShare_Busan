import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:8080';
}

class Urls {
  static final String apiUrl = '${BaseUrl.baseUrl}/';
}

class AppKey {
  static final String appKey = dotenv.env['APP_KEY'] ?? '';
}
