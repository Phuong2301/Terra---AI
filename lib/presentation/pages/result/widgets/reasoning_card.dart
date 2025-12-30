import 'package:flutter/material.dart';

class ReasoningCard extends StatelessWidget {
  const ReasoningCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Reasoning',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.35),
          ),
        ],
      ),
    );
  }
}
