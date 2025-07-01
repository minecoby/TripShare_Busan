import 'package:flutter/material.dart';
import 'package:seagull/constants/colors.dart';
import 'package:seagull/components/postcard.dart';

class MylikedPostsPage extends StatelessWidget {
  const MylikedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  '내가 찜한 글',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: TextColor,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF757575),
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFF4EBEB)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 6),
              itemCount: 4,
              itemBuilder: (context, index) {
                return PostCard(onTap: () {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
