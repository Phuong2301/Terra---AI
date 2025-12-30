import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultsActionsRow extends StatelessWidget {
  const ResultsActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History: FE-110 (next)')),
              );
            },
            icon: const Icon(Icons.history_rounded),
            label: const Text('View History'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved (local). Hook FE-109 next.')),
              );
              context.go('/home');
            },
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Done'),
          ),
        ),
      ],
    );
  }
}
