import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seagull/components/bottomNavigation.dart';
import 'package:seagull/components/bottomNavigationController.dart';

class NavigationLayout extends StatelessWidget {
  final Widget child;

  const NavigationLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Get.put(MyBottomNavigationController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MyBottomNavigation(),
            ),
          ],
        ),
      ),
    );
  }
}
