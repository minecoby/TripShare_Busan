import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';

class InputField extends StatelessWidget {
  final String title;
  final bool obscureText;

  const InputField({super.key, required this.title, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0x337C88A5),
            offset: Offset(0, 0),
            blurRadius: 14,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'RiaSans',
              fontSize: 12,
              color: SubTextColor,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            obscureText: obscureText,
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
            ),
            style: const TextStyle(color: TextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CustomButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          color: MainColor,
          boxShadow: [
            BoxShadow(
              color: Color(0x667C88A5),
              offset: Offset(0, 4),
              blurRadius: 14,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'RiaSans',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
