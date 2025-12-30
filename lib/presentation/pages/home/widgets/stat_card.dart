import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.animatedValue,      
    this.animatedPrefix = '',  
    this.duration = const Duration(milliseconds: 850),
  });

  final String title;
  final String value;        
  final String subtitle;
  final IconData icon;

  final int? animatedValue;       
  final String animatedPrefix;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget valueWidget() {
      if (animatedValue == null) {
        return Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        );
      }

      return TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: animatedValue!),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (_, v, __) {
          return Text(
            '$animatedPrefix$v',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.onSurfaceVariant),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: cs.onSurfaceVariant)),
          const SizedBox(height: 6),

          valueWidget(),

          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }
}
