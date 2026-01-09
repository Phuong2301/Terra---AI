import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart' as l;

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
    final t = l.S.of(context);

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
          Text(
            t.scoreBreakdownTitle,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 10),

          _kv(t.baseScoreRuleBased, '$base'),
          _kv(t.aiAdjustment, '${aiAdj >= 0 ? '+' : ''}$aiAdj'),
          _kv(t.fpoBoost, fpo > 0 ? '+$fpo' : '0'),

          const Divider(height: 18),

          _kv(t.finalScoreCapped, '$finalScore', bold: true),
          const SizedBox(height: 2),

          Text(
            t.hybridModelHint,
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
