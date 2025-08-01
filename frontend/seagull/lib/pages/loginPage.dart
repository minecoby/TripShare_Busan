import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seagull/components/LoginSignupInput.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/api/controller/LoginAndSignup/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MainColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.26,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed("/signup");
                    },
                    child: Text(
                      'sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontFamily: 'RiaSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(75),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 60),
                            Text(
                              "LOGIN",
                              style: TextStyle(
                                fontFamily: 'RiaSans',
                                fontSize: 28,
                                color: SubTextColor,
                                letterSpacing:
                                    MediaQuery.of(context).size.width * 0.015,
                              ),
                            ),
                            const SizedBox(height: 60),
                            InputField(
                              title: "ID",
                              controller: controller.idController,
                            ),
                            const SizedBox(height: 15),
                            InputField(
                              title: "Password",
                              controller: controller.pwController,
                              obscureText: true,
                            ),

                            //입력 틀렸을 경우 -> 맞는 경우 25 빈칸
                            const SizedBox(height: 3),
                            Obx(() {
                              if (controller.errorMessage.value.isEmpty) {
                                return const SizedBox(height: 25);
                              } else {
                                return Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.red,
                                  ),
                                );
                              }
                            }),

                            const SizedBox(height: 3),
                            //
                            CustomButton(
                              label: "log in",
                              onTap: controller.login,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
