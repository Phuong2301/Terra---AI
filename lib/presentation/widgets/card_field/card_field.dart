import 'package:flutter/material.dart';

class CardField {
  const CardField._();

  static Widget label(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            content.isEmpty ? '—' : content,
          ),
        ),
      ],
    );
  }
}
