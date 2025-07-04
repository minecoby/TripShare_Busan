import 'package:flutter/material.dart';
import 'package:seagull/components/LoginSignupInput.dart';
import 'package:seagull/constants/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                      // 이동 기능
                    },
                    child: Text(
                      'sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        fontFamily: 'RiaSans',
                      ),
                    ),
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
                  SizedBox(height: 60),
                  Text(
                    "LOGIN",
                    style: TextStyle(
                      fontFamily: 'RiaSans',
                      fontSize: 28,
                      color: SubTextColor,
                      letterSpacing: MediaQuery.of(context).size.width * 0.015,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const InputField(title: "ID"),
                  const SizedBox(height: 15),
                  const InputField(title: "Password", obscureText: true),

                  //입력 틀렸을 경우 -> 맞는 경우 25 빈칸
                  const SizedBox(height: 3),
                  const Text(
                    "아이디 또는 비밀번호가 틀렸습니다",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                  const SizedBox(height: 3),
                  //
                  CustomButton(label: "log in", onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
