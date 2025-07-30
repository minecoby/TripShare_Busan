import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seagull/router/main_router.dart';
import 'package:seagull/pages/mainPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seagull/constants/url.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');

  await FlutterNaverMap().init(
      clientId: dotenv.env['NAVER_MAP_CLIENT_ID'],
      onAuthFailed: (ex) {
        switch (ex) {
          case NQuotaExceededException(:final message):
            print("사용량 초과 (message: $message)");
            break;
          case NUnauthorizedClientException() ||
          NClientUnspecifiedException() ||
          NAnotherAuthFailedException():
            print("인증 실패: $ex");
            break;
        }
      });
  await initializeDateFormatting('ko_KR', null);
  print('✅ dotenv에서 불러온 NAVER_MAP_CLIENT_ID: ${dotenv.env['NAVER_MAP_CLIENT_ID']}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/main',
      getPages: MainRouter.routes,
      // home: const MainPageView(),
    );
  }
}
