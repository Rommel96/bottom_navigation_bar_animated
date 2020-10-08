import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  final Color color;
  final Rect rect;

  MyCustomPainter({
    @required this.rect,
    @required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(4.0)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}
