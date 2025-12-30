import 'package:flutter/material.dart';

Color scoreColor(int score) {
  if (score >= 75) return const Color(0xFF16A34A); // green
  if (score >= 50) return const Color(0xFFF59E0B); // yellow
  return const Color(0xFFDC2626); // red
}

IconData scoreIcon(String category) {
  if (category == 'Low Risk') return Icons.verified_rounded;
  if (category == 'Medium Risk') return Icons.warning_rounded;
  return Icons.report_rounded;
}
