import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart' as l;

class OneLineChart extends StatelessWidget {
  const OneLineChart({super.key, required this.params});
  final Map<String, double> params;

  static const double _yAxisWidth = 56.0;
  static const double _bottomReserved = 60.0;
  static const double _topReserved = 0.0;

  double _niceStep(double maxY) {
    if (maxY <= 10) return 5;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 25;
    if (maxY <= 200) return 50;
    return 1000;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.sizeOf(context);
    final lang = l.S.of(context);
    if (params.isEmpty) {
      return Container(
        alignment: Alignment.center,
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surface : Colors.grey[200],
        child: Text(lang.noData),
      );
    }
    final stageNames = params.keys.toList();
    final values = params.values.toList();

    final spots = <FlSpot>[
      const FlSpot(0, 0),
      for (var i = 0; i < values.length; i++) FlSpot((i + 1).toDouble(), values[i]),
      FlSpot((values.length + 1).toDouble(), 0),
    ];
    final maxVal = values.reduce(max);
    final step = _niceStep(maxVal);
    final yMaxBase = max(10, ((maxVal / step).ceil() * step).toDouble());
    final yMax = yMaxBase + step * 0.6;
    final yTicks = [for (double v = 0; v <= yMaxBase + 1e-6; v += step) v];
    const perPoint = 100.0;
    final totalPoints = values.length + 2;
    final chartWidth = max(MediaQuery.sizeOf(context).width, totalPoints * perPoint);

    return LayoutBuilder(
      builder: (_, constraints) {
        final totalHeight = constraints.maxHeight;
        final plotHeight = (totalHeight - _topReserved - _bottomReserved).clamp(0.0, double.infinity);

        double mapYToTop(double value) {
          final clamped = value.clamp(0, yMax);
          final ratio = (clamped / yMax);
          final yInsidePlot = (1 - ratio) * plotHeight;
          return _topReserved + yInsidePlot;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _yAxisWidth,
              child: Stack(
                children: [
                  for (final v in yTicks)
                    Positioned(
                      top: mapYToTop(v) - 8,
                      right: 8,
                      child: Text(
                        v.toInt().toString(),
                        style: TextStyle(
                          color: theme.colorScheme.onTertiary,
                          fontSize: mq.width < 480 ? 12 : 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartWidth,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (values.length + 1).toDouble(),
                      minY: 0,
                      maxY: yMax,
                      clipData: const FlClipData.none(),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: step,
                        getDrawingHorizontalLine: (value) {
                          final isZero = (value.abs() < 1e-6);
                          return FlLine(
                            color: theme.colorScheme.outline.withOpacity(isZero ? 0.9 : 0.6),
                            strokeWidth: isZero ? 2.0 : 1.2,
                            dashArray: isZero ? null : const [10, 5],
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.6), width: 1),
                          right: BorderSide(color: theme.colorScheme.outline.withOpacity(0.6), width: 1),
                          bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.6), width: 1),
                          left: const BorderSide(color: Colors.transparent, width: 0),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 2,
                          color: theme.colorScheme.primary,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.15),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchSpotThreshold: 30,
                        touchTooltipData: LineTouchTooltipData(
                          maxContentWidth: 220,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipRoundedRadius: 6,
                          getTooltipColor: (_) => theme.colorScheme.surface,
                          getTooltipItems: (touched) => touched.map((s) {
                            final idx = s.spotIndex;
                            if (idx == 0 || idx == spots.length - 1) {
                              return const LineTooltipItem('', TextStyle(fontSize: 0));
                            }
                            final label = stageNames[idx - 1];
                            final val = values[idx - 1];
                            return LineTooltipItem(
                              '$label\n$val Hours',
                              TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: _bottomReserved,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              Widget w = const SizedBox.shrink();
                              if (i == 0) {
                                w = const SizedBox.shrink();
                              } else if (i >= 1 && i <= stageNames.length) {
                                final label = stageNames[i - 1];
                                w = Text(
                                  label,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.colorScheme.onTertiary,
                                    fontSize: mq.width < 480 ? 11 : 13,
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Transform.rotate(
                                  angle: mq.width < 480 ? (-45 * 3.1416 / 180) : 0,
                                  child: w,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}