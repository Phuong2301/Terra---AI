import 'package:flutter/material.dart';

class BreakdownCard extends StatelessWidget {
  const BreakdownCard({
    super.key,
    required this.base,
    required this.aiAdj,
    required this.fpo,
    required this.finalScore,
  });

  final int base;
  final int aiAdj;
  final int fpo;
  final int finalScore;

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
          const Text('Score Breakdown',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),
          _kv('Base score (rule-based)', '$base'),
          _kv('AI adjustment', '${aiAdj >= 0 ? '+' : ''}$aiAdj'),
          _kv('FPO boost', fpo > 0 ? '+$fpo' : '0'),
          const Divider(height: 18),
          _kv('Final score (capped)', '$finalScore', bold: true),
          const SizedBox(height: 2),
          Text(
            'Hybrid model = explainable base + data-driven adjustment.',
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
