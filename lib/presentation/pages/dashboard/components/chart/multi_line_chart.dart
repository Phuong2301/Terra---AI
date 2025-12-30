import 'dart:math';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';

import '../../../../../generated/l10n.dart' as l;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MultiLineChart extends StatelessWidget {
  const MultiLineChart({super.key, required this.bottomTitle, required this.dataMap});
  final List<String> bottomTitle;
  final Map<String, List<double>> dataMap;

  static const _colors = [
    AcnooAppColors.kChartColor1,
    AcnooAppColors.kChartColor2,
    AcnooAppColors.kChartColor3,
    AcnooAppColors.kChartColor4,
    AcnooAppColors.kChartColor5,
    AcnooAppColors.kChartColor6,
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final keys = dataMap.keys.toList();
    const perPoint = 200.0;
    final totalPoints = dataMap.length + 2;
    final chartWidth = max(MediaQuery.sizeOf(context).width, totalPoints * perPoint);
    final allValues = dataMap.values.expand((v) => v).toList();
    if (allValues.isEmpty) {
      return Center(child: Text(lang.noData));
    }

    final maxVal = allValues.reduce(max);
    if (maxVal <= 0) {
      return Center(child: Text(lang.noData));
    }

    final seriesList = <LineChartBarData>[];
    int colorIndex = 0;
    for (final entry in dataMap.entries) {
      final values = entry.value;
      final spots = [
        for (var i = 0; i < values.length; i++)
          FlSpot((i + 1).toDouble(), values[i]),
      ];
      seriesList.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 2,
          color: _colors[colorIndex % _colors.length],
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );
      colorIndex++;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: bottomTitle.length.toDouble(),
                  minY: 0,
                  maxY: maxVal * 1.2,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 46,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 1 || i > bottomTitle.length) {
                            return const SizedBox.shrink();
                          }
                          final raw = bottomTitle[i - 1];
                          final label =
                              raw.length >= 10 ? raw.substring(5) : raw;
              
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: mq.width < 480 ? 11 : 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipRoundedRadius: 6,
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipColor: (_) => theme.colorScheme.surface,
                      getTooltipItems: (touchedSpots) {
                        if (touchedSpots.isEmpty) return [];
              
                        final xIndex = touchedSpots.first.x.toInt() - 1;
                        final raw = bottomTitle[xIndex];
                        final dateLabel =
                            raw.length >= 10 ? raw.substring(5) : raw; 
              
                        final items = <LineTooltipItem>[];
              
                        for (var i = 0; i < touchedSpots.length; i++) {
                          final s = touchedSpots[i];
                          final barIndex = s.barIndex;
                          final seriesName = keys[barIndex];                 
                          final color = _colors[barIndex % _colors.length];
                          final valueStr = s.y.toStringAsFixed(0);
              
                          final text = i == 0
                              ? '$dateLabel\n$seriesName: $valueStr'
                              : '$seriesName: $valueStr';
              
                          items.add(
                            LineTooltipItem(
                              text,
                              TextStyle(
                                color: color,
                                fontWeight: i == 0 ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return items;
                      },
                    ),
                  ),
                  lineBarsData: seriesList,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (var i = 0; i < keys.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _colors[i % _colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      keys[i],
                      style: TextStyle(
                        fontSize: mq.width < 480 ? 10 : 11,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}