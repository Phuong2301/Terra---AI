// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_animate/flutter_animate.dart';

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({
    super.key,
    this.height = 20,
    this.width = 20 * 5,
    this.color,
    this.colors,
    this.decoration,
  }) : assert(
          color == null || decoration == null,
          'Cannot provide both a color and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        );
  final double height;
  final double width;
  final Color? color;
  final List<Color>? colors;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration:
          decoration ?? BoxDecoration(color: color ?? Colors.greenAccent),
    ).animate(
      autoPlay: true,
      onPlay: (controller) => controller.repeat(),
      onComplete: (controller) {
        controller.stop();
        controller.dispose();
      },
      effects: [
        ShimmerEffect(colors: colors, delay: const Duration(milliseconds: 450)),
      ],
    );
  }
}
