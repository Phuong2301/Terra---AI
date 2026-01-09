import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/l10n.dart' as l;

class ResultsActionsRow extends StatelessWidget {
  const ResultsActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final t = l.S.of(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.push('/history');
            },
            icon: const Icon(Icons.history_rounded),
            label: Text(t.viewHistory),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.savedLocalComingSoon)),
              );
              context.go('/home');
            },
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(t.done),
          ),
        ),
      ],
    );
  }
}
