// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class PieChartIndicator extends StatelessWidget {
  const PieChartIndicator({
    super.key,
    required this.color,
    required this.text,
    required this.heading,
  });

  final Color color;
  final String text;
  final String heading;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8), // Increased spacing for better readability
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  heading,
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                ':',
                style: textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 4),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  text,
                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
