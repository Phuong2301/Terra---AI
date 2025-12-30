import 'package:flutter/material.dart';

Color scoreColor(int score) {
  if (score >= 75) return const Color(0xFF16A34A);
  if (score >= 50) return const Color(0xFFF59E0B);
  return const Color(0xFFDC2626);
}

String fmtDate(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return '—';
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return '$y-$m-$day $hh:$mm';
}
