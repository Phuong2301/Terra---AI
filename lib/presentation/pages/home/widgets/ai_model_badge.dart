import 'package:app_mobile/presentation/pages/ai/model/ai_model_stats.dart';
import 'package:flutter/material.dart';

class AiModelBadge extends StatelessWidget {
  const AiModelBadge({super.key, required this.ai});

  final AiModelStats ai;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = const Color(0xFF16A34A);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => _showAiInfoSheet(context, ai),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(0.45),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧠', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text(
              'AI Model ${ai.version}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.info_outline_rounded, size: 16, color: accent.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }

  void _showAiInfoSheet(BuildContext context, AiModelStats ai) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        final pct = (ai.accuracy * 100).clamp(0, 100).toStringAsFixed(0);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Learning', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: cs.onSurface)),
              const SizedBox(height: 8),
              Text(
                'Trained on ${ai.trainedOnFarmers} farmers',
                style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _AccuracyBar(value: ai.accuracy),
              const SizedBox(height: 8),
              Text('Accuracy: $pct%', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 10),
              Text(
                'Note: This is a demo learning indicator for MVP.',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccuracyBar extends StatelessWidget {
  const _AccuracyBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final v = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: v,
        minHeight: 10,
        backgroundColor: cs.outlineVariant.withOpacity(0.35),
      ),
    );
  }
}
