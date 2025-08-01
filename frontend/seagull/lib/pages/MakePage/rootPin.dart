import 'package:flutter/material.dart';
import 'package:seagull/api/controller/PostPage/RouteController.dart';
import 'package:seagull/constants/colors.dart';
import 'package:get/get.dart';
import 'package:seagull/pages/MakePage/mapPage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AnimatedRoadPainter extends CustomPainter {
  final Path fullPath;
  final double progress;

  AnimatedRoadPainter({required this.fullPath, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF707070)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 30
          ..strokeCap = StrokeCap.butt;

    final pathMetrics = fullPath.computeMetrics();
    final animatedPath = Path();

    for (final metric in pathMetrics) {
      final length = metric.length * progress;
      animatedPath.addPath(metric.extractPath(0, length), Offset.zero);
    }

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant AnimatedRoadPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

Path buildRoadPath(Size size, int num) {
  final radius = 35.0;
  final path = Path();

  path.moveTo(0, size.height * 0.18);
  path.lineTo(size.width * 0.85 - radius, size.height * 0.18);
  path.quadraticBezierTo(
    size.width * 0.85,
    size.height * 0.18,
    size.width * 0.85,
    size.height * 0.18 + radius,
  );

  if (num == 3) {
    path.lineTo(size.width * 0.85, size.height * 0.7 - radius);
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.7,
      size.width * 0.85 - radius,
      size.height * 0.7,
    );
    path.lineTo(0, size.height * 0.7);
  } else if (num == 4 || num == 5) {
    path.lineTo(size.width * 0.85, size.height * 0.5 - radius);
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.5,
      size.width * 0.85 - radius,
      size.height * 0.5,
    );
    path.lineTo(size.width * 0.15 + radius, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.5,
      size.width * 0.15,
      size.height * 0.5 + radius,
    );
  }

  if (num == 4) {
    path.lineTo(size.width * 0.15, size.height);
  } else if (num == 5) {
    path.lineTo(size.width * 0.15, size.height * 0.85 - radius);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.85,
      size.width * 0.15 + radius,
      size.height * 0.85,
    );
    path.lineTo(size.width, size.height * 0.85);
  }

  return path;
}

class RoadAnimatedWidget extends StatefulWidget {
  final int num;

  const RoadAnimatedWidget({super.key, required this.num});

  @override
  State<RoadAnimatedWidget> createState() => _RoadAnimatedWidgetState();
}

class _RoadAnimatedWidgetState extends State<RoadAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Path _roadPath;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant RoadAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.num != widget.num) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _roadPath = buildRoadPath(size, widget.num);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                CustomPaint(
                  size: size,
                  painter: AnimatedRoadPainter(
                    fullPath: _roadPath,
                    progress: _animation.value,
                  ),
                ),
                AnimatedPlaceTimeline(num: widget.num),
              ],
            );
          },
        );
      },
    );
  }
}

class PinMarker extends StatelessWidget {
  final String? imagePath;
  final File? imageFile;
  final VoidCallback? onTap;

  const PinMarker({super.key, this.imagePath, this.imageFile, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageWidget =
        imageFile != null
            ? Image.file(imageFile!, fit: BoxFit.cover)
            : imagePath != null
            ? Image.asset(imagePath!, fit: BoxFit.cover)
            : const SizedBox();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 55,
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            const Positioned(
              top: 0,
              child: Icon(
                Icons.location_on_rounded,
                size: 80,
                color: Color(0xFFE4CCFF),
              ),
            ),
            Positioned(
              top: 15,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(child: imageWidget),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedPlaceTimeline extends StatefulWidget {
  final int num;
  const AnimatedPlaceTimeline({super.key, required this.num});

  @override
  State<AnimatedPlaceTimeline> createState() => _AnimatedPlaceTimelineState();
}

class _AnimatedPlaceTimelineState extends State<AnimatedPlaceTimeline>
    with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  late List<Animation<Offset>> markerAnimations;
  late List<Animation<double>> fadeAnimations;
  // late List<TextEditingController> titleControllers;
  // late List<TextEditingController> addressControllers;

  final placeController = Get.put(SearchPlaceController());

  final placeTimelineController = Get.put(PlaceTimelineController());

  // List<File?> imageFiles = [];
  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        placeTimelineController.imageFiles[index] = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    placeTimelineController.initialize(widget.num);
    placeTimelineController.imageFiles.value = List<File?>.filled(
      widget.num,
      null,
    );

    placeTimelineController.titleControllers.value = List.generate(
      widget.num,
      (i) => TextEditingController(),
    );

    placeTimelineController.addressControllers.value = List.generate(
      widget.num,
      (i) => TextEditingController(),
    );

    controllers = List.generate(widget.num, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    });

    markerAnimations =
        controllers.map((controller) {
          return Tween<Offset>(
            begin: const Offset(0, -0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
        }).toList();

    fadeAnimations =
        controllers.map((controller) {
          return Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
        }).toList();

    for (int i = 0; i < controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        controllers[i].forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPlaceTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.num != widget.num) {
      final oldTitleControllers = placeTimelineController.titleControllers;
      final oldAddressControllers = placeTimelineController.addressControllers;
      final oldAnimControllers = controllers;

      placeTimelineController.imageFiles.value = List<File?>.generate(
        widget.num,
        (i) {
          return i < placeTimelineController.imageFiles.length
              ? placeTimelineController.imageFiles[i]
              : null;
        },
      );

      placeTimelineController.titleControllers.value = List.generate(
        widget.num,
        (i) {
          return i < oldTitleControllers.length
              ? oldTitleControllers[i]
              : TextEditingController();
        },
      );

      placeTimelineController.addressControllers.value = List.generate(
        widget.num,
        (i) {
          return i < oldAddressControllers.length
              ? oldAddressControllers[i]
              : TextEditingController();
        },
      );

      controllers = List.generate(widget.num, (i) {
        return i < oldAnimControllers.length
            ? oldAnimControllers[i]
            : AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            );
      });

      for (int i = widget.num; i < oldTitleControllers.length; i++) {
        oldTitleControllers[i].dispose();
      }
      for (int i = widget.num; i < oldAddressControllers.length; i++) {
        oldAddressControllers[i].dispose();
      }
      for (int i = widget.num; i < oldAnimControllers.length; i++) {
        oldAnimControllers[i].dispose();
      }

      markerAnimations =
          controllers.map((controller) {
            return Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOut),
            );
          }).toList();

      fadeAnimations =
          controllers.map((controller) {
            return Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeIn),
            );
          }).toList();

      for (int i = 0; i < controllers.length; i++) {
        controllers[i].reset();
        Future.delayed(Duration(milliseconds: 800 * i), () {
          if (mounted) controllers[i].forward();
        });
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);

        final markerPositions = _calculatePositions(size, widget.num);

        return Stack(
          children: List.generate(widget.num, (index) {
            bool isRightText = _isTextRight(index, widget.num);

            return Positioned(
              top: markerPositions[index].dy,
              left: isRightText ? markerPositions[index].dx : null,
              right: isRightText ? null : markerPositions[index].dx,
              child: SlideTransition(
                position: markerAnimations[index],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      isRightText
                          ? [
                            FadeTransition(
                              opacity: fadeAnimations[index],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: PinMarker(
                                  imageFile:
                                      placeTimelineController.imageFiles[index],
                                  imagePath: 'assets/images/sea.jpg',
                                  onTap: () => _pickImage(index),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FadeTransition(
                              opacity: fadeAnimations[index],
                              child: _placeInfo(
                                placeTimelineController.titleControllers[index],
                                placeTimelineController
                                    .addressControllers[index],
                                false, // 오른쪽 정렬
                              ),
                            ),
                          ]
                          : [
                            FadeTransition(
                              opacity: fadeAnimations[index],
                              child: _placeInfo(
                                placeTimelineController.titleControllers[index],
                                placeTimelineController
                                    .addressControllers[index],
                                true, // 왼쪽 정렬
                              ),
                            ),
                            const SizedBox(width: 8),
                            FadeTransition(
                              opacity: fadeAnimations[index],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: PinMarker(
                                  imageFile:
                                      placeTimelineController.imageFiles[index],
                                  imagePath: 'assets/images/sea.jpg',
                                  onTap: () => _pickImage(index),
                                ),
                              ),
                            ),
                          ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  List<Offset> _calculatePositions(Size size, int num) {
    if (num == 3) {
      return [
        Offset(size.width * 0.01, size.height * 0.05),
        Offset(size.width * 0.065, size.height * 0.32),
        Offset(size.width * 0.1, size.height * 0.57),
      ];
    } else if (num == 4) {
      return [
        Offset(size.width * 0.01, size.height * 0.05),
        Offset(size.width * 0.065, size.height * 0.27),
        Offset(size.width * 0.065, size.height * 0.53),
        Offset(size.width * 0.065, size.height * 0.7),
      ];
    } else {
      return [
        Offset(size.width * 0.01, size.height * 0.05),
        Offset(size.width * 0.065, size.height * 0.23),
        Offset(size.width * 0.12, size.height * 0.38),
        Offset(size.width * 0.065, size.height * 0.58),
        Offset(size.width * 0.03, size.height * 0.72),
      ];
    }
  }

  bool _isTextRight(int index, int num) {
    if (num == 3) return index == 0 || index == 2;
    if (num == 4) return index == 0 || index == 2 || index == 3;
    return index == 0 || index == 3;
  }

  Widget _placeInfo(
    TextEditingController titleController,
    TextEditingController addressController,
    bool isRightText,
  ) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment:
            isRightText ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding:
                isRightText
                    ? const EdgeInsets.only(right: 3)
                    : const EdgeInsets.only(left: 3),
            child: TextField(
              controller: titleController,
              textAlign: isRightText ? TextAlign.right : TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),

              decoration: const InputDecoration(
                hintText: "장소명을 입력해주세요",
                hintStyle: TextStyle(fontSize: 16, color: SubTextColor),
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
          TextField(
            controller: addressController,
            readOnly: true,
            textAlign: isRightText ? TextAlign.right : TextAlign.left,
            decoration: const InputDecoration(
              hintText: "위치를 설정해주세요",
              hintStyle: TextStyle(fontSize: 12, color: SubTextColor),
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 5),
              border: InputBorder.none,
            ),
            onTap: () async {
              placeController.clear();

              final keyword = titleController.text.trim();
              await Get.to(
                () => MapPage(initialKeyword: keyword.isEmpty ? null : keyword),
              );

              if (placeController.selectedAddress.isNotEmpty) {
                addressController.text = placeController.selectedAddress.value;
              }
              if (placeController.selectedPlaceName.isNotEmpty) {
                titleController.text = placeController.selectedPlaceName.value;
              }
            },
          ),
        ],
      ),
    );
  }
}
