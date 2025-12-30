// 🎯 Dart imports:
import 'dart:ui';

class OverviewItem {
  final String iconPath;
  final num value;
  final String subtitle;
  final Color? iconColor;
  const OverviewItem({
    required this.iconPath,
    required this.value,
    required this.subtitle,
    this.iconColor,
  });
}
