// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:extended_text_library/extended_text_library.dart';

// class ImageText extends SpecialText {
//   final List<File> imageFiles;
//   final int index;

//   ImageText(
//     String startFlag,
//     this.imageFiles,
//     TextStyle textStyle,
//     SpecialTextGestureTapCallback? onTap,
//     this.index,
//   ) : super(startFlag, '>', textStyle, onTap: onTap);

//   @override
//   InlineSpan finishText() {
//     if (index >= imageFiles.length) return const TextSpan(text: '');

//     return WidgetSpan(
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         width: 150,
//         height: 150,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.25),
//               offset: const Offset(0, 4),
//               blurRadius: 4,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(5),
//           child: Image.file(imageFiles[index], fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }
