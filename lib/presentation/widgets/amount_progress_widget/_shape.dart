// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class HexagonShape extends CustomPainter {
  const HexagonShape({this.color});
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    // Scale the size to the desired dimensions of width 52 and height 60
    double targetWidth = 52;
    double targetHeight = 60;

    // Calculate the scale factors for both width and height
    double scaleX = targetWidth / size.width;
    double scaleY = targetHeight / size.height;

    // Apply the scaling factors to maintain aspect ratio and fit within the target size
    canvas.scale(scaleX, scaleY);

    // Define the path as per the original design
    Path path0 = Path();
    path0.moveTo(size.width * 0.4039000, size.height * 0.03246569);
    path0.cubicTo(
        size.width * 0.4633731,
        size.height * 0.001703817,
        size.width * 0.5366269,
        size.height * 0.001703829,
        size.width * 0.5961000,
        size.height * 0.03246569);
    path0.lineTo(size.width * 0.9037923, size.height * 0.1916172);
    path0.cubicTo(size.width * 0.9633231, size.height * 0.2224086, size.width,
        size.height * 0.2793414, size.width, size.height * 0.3409586);
    path0.lineTo(size.width, size.height * 0.6590414);
    path0.cubicTo(
        size.width,
        size.height * 0.7206586,
        size.width * 0.9633231,
        size.height * 0.7775914,
        size.width * 0.9037923,
        size.height * 0.8083828);
    path0.lineTo(size.width * 0.5961000, size.height * 0.9675345);
    path0.cubicTo(
        size.width * 0.5366269,
        size.height * 0.9982966,
        size.width * 0.4633731,
        size.height * 0.9982966,
        size.width * 0.4039000,
        size.height * 0.9675345);
    path0.lineTo(size.width * 0.09620712, size.height * 0.8083828);
    path0.cubicTo(size.width * 0.03667692, size.height * 0.7775914, 0,
        size.height * 0.7206586, 0, size.height * 0.6590414);
    path0.lineTo(0, size.height * 0.3409586);
    path0.cubicTo(
        0,
        size.height * 0.2793414,
        size.width * 0.03667692,
        size.height * 0.2224086,
        size.width * 0.09620731,
        size.height * 0.1916172);
    path0.lineTo(size.width * 0.4039000, size.height * 0.03246569);
    path0.close();

    // Paint the shape with the specified color
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color ?? Colors.red;
    canvas.drawPath(path0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
