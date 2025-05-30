import 'package:flutter/material.dart';

class ShowModal extends StatelessWidget {
  final List<String> districts;
  final Function(String) onSelect;

  const ShowModal({super.key, required this.districts, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 75 / 55,
              children:
                  districts.map((name) {
                    return GestureDetector(
                      onTap: () {
                        onSelect(name);
                        Navigator.pop(context);
                      },
                      child: TextBox(name),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                "닫기",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final String value;
  const TextBox(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Text(
        value,
        style: const TextStyle(
          fontSize: 16, // ✅ 기존 8 → 12로 증가
          color: Color(0xFF595959),
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.center,
      ),
    );
  }
}
