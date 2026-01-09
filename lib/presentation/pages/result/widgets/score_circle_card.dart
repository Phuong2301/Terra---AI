import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart' as l;


class ScoreCircleCard extends StatelessWidget {
  const ScoreCircleCard({
    super.key,
    required this.score,
    required this.color,
    required this.category,
  });

  final int score;
  final Color color;
  final String category;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final value = (score / 100).clamp(0.0, 1.0);
    final lang = l.S.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          SizedBox(
            width: 118,
            height: 118,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        value: 1,
                        strokeWidth: 12,
                        valueColor: AlwaysStoppedAnimation(
                          cs.outlineVariant.withOpacity(0.35),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        value: v,
                        strokeWidth: 12,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang.score,
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 11,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
