// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class DottedBorder extends StatelessWidget {
  const DottedBorder({
    super.key,
    required this.child,
    // this.color,
    this.borderRadius = const Radius.circular(5.0),
  });
  final Widget child;
  // final Color? color;
  final Radius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return CustomPaint(
      painter: DottedBorderPainter(
        color: _theme.colorScheme.outline,
        borderRadius: borderRadius!,
      ),
      willChange: true,
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final Radius borderRadius;

  const DottedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, borderRadius);

    final path = Path()..addRRect(rrect);

    const dashWidth = 4.0;
    const dashSpace = 4.0;

    double distance = 0.0;
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      while (distance < pathMetric.length) {
        final start = distance;
        final end = distance + dashWidth;

        final lineSegment = pathMetric.extractPath(start, end);
        canvas.drawPath(lineSegment, paint);

        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
