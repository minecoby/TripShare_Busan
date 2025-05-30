import 'package:flutter/material.dart';

class NoLayout extends StatelessWidget {
  final Widget child;

  const NoLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: child));
  }
}
