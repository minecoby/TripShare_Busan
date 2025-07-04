import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seagull/components/LoginSignupInput.dart';
import 'package:seagull/constants/colors.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontFamily: 'RiaSans',
                      fontSize: 28,
                      color: Colors.white,
                      letterSpacing: MediaQuery.of(context).size.width * 0.015,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: MediaQuery.of(context).size.height * 0.14 / 2 - 24,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  const InputField(title: "Name"),
                  const SizedBox(height: 15),
                  const InputField(title: "ID"),
                  const SizedBox(height: 15),
                  const InputField(title: "Password", obscureText: true),
                  const SizedBox(height: 15),
                  const InputSendField(
                    title: "E-mail",
                    send: "전송",
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  const InputSendField(
                    title: "인증번호",
                    send: "전송",
                    obscureText: false,
                  ),

                  //입력 틀렸을 경우 -> 맞는 경우 25 빈칸
                  const SizedBox(height: 3),
                  const Text(
                    "인증번호가 틀렸습니다",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 3),
                  //
                  CustomButton(label: "sign up", onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
