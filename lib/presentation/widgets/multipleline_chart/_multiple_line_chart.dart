// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../../domain/core/static/static.dart';
import '../../../domain/core/theme/theme.dart';

class MultipleLineChart extends StatelessWidget {
  const MultipleLineChart({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final titleFontSize = rf.ResponsiveValue<double?>(
      context,
      conditionalValues: [
        rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 14)
      ],
    ).value;
    final kBarWidth = rf.ResponsiveValue<double?>(context,
                conditionalValues: [
                  rf.Condition.smallerThan(
                      name: BreakpointName.SM.name, value: 2),
                ],
                defaultValue: 4)
            .value ??
        4;
    return LayoutBuilder(
      builder: (context, constraints) {
        final kReverzeSize = rf.ResponsiveValue<double?>(context,
                    conditionalValues: [
                      rf.Condition.smallerThan(
                          name: BreakpointName.SM.name, value: 30),
                    ],
                    defaultValue: 40)
                .value ??
            40;
        return AspectRatio(
          aspectRatio: constraints.maxWidth / constraints.maxHeight,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 5),
                  child: Text(
                    lang.multipleLineChart,
                    //'Multiple Line Chart',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: titleFontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: AcnooAppColors.kNeutral300,
                  height: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 8),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 5),
                              FlSpot(1, 10),
                              FlSpot(2, 8),
                              FlSpot(3, 15),
                              FlSpot(4, 10),
                              FlSpot(5, 20),
                              FlSpot(6, 18),
                              FlSpot(7, 25),
                              FlSpot(8, 22),
                              FlSpot(9, 30),
                              FlSpot(10, 28),
                              FlSpot(11, 35),
                            ],
                            isCurved: true,
                            color: AcnooAppColors.kPrimary600,
                            barWidth: kBarWidth,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3),
                              FlSpot(1, 8),
                              FlSpot(2, 5),
                              FlSpot(3, 12),
                              FlSpot(4, 7),
                              FlSpot(5, 15),
                              FlSpot(6, 13),
                              FlSpot(7, 20),
                              FlSpot(8, 17),
                              FlSpot(9, 25),
                              FlSpot(10, 22),
                              FlSpot(11, 30),
                            ],
                            isCurved: true,
                            color: AcnooAppColors.kWarning,
                            barWidth: kBarWidth,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
                              reservedSize: kReverzeSize,
                              getTitlesWidget: (value, _) {
                                final fontSize = rf.ResponsiveValue<double?>(
                                    context,
                                    conditionalValues: [
                                      rf.Condition.smallerThan(
                                          name: BreakpointName.SM.name,
                                          value: 12)
                                    ]).value;
                                final style = Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: fontSize);
                                switch (value.toInt()) {
                                  case 0:
                                    return Text(
                                      '0k',
                                      style: style,
                                    );
                                  case 5:
                                    return Text(
                                      '5k',
                                      style: style,
                                    );
                                  case 10:
                                    return Text(
                                      '10k',
                                      style: style,
                                    );
                                  case 20:
                                    return Text(
                                      '20k',
                                      style: style,
                                    );
                                  case 30:
                                    return Text(
                                      '30k',
                                      style: style,
                                    );
                                  case 40:
                                    return Text(
                                      '40k',
                                      style: style,
                                    );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                final fontSize = rf.ResponsiveValue<double?>(
                                    context,
                                    conditionalValues: [
                                      rf.Condition.smallerThan(
                                          name: BreakpointName.SM.name,
                                          value: 10)
                                    ]).value;
                                final style = Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: fontSize);
                                switch (value.toInt()) {
                                  case 0:
                                    return Text(
                                      'Jan',
                                      style: style,
                                    );
                                  case 1:
                                    return Text(
                                      'Feb',
                                      style: style,
                                    );
                                  case 2:
                                    return Text(
                                      'Mar',
                                      style: style,
                                    );
                                  case 3:
                                    return Text(
                                      'Apr',
                                      style: style,
                                    );
                                  case 4:
                                    return Text(
                                      'May',
                                      style: style,
                                    );
                                  case 5:
                                    return Text(
                                      'Jun',
                                      style: style,
                                    );
                                  case 6:
                                    return Text(
                                      'Jul',
                                      style: style,
                                    );
                                  case 7:
                                    return Text(
                                      'Aug',
                                      style: style,
                                    );
                                  case 8:
                                    return Text(
                                      'Sep',
                                      style: style,
                                    );
                                  case 9:
                                    return Text(
                                      'Oct',
                                      style: style,
                                    );
                                  case 10:
                                    return Text(
                                      'Nov',
                                      style: style,
                                    );
                                  case 11:
                                    return Text(
                                      'Dec',
                                      style: style,
                                    );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                          border: Border.all(color: const Color(0xff37434d)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return const FlLine(
                              color: AcnooAppColors.kNeutral300,
                              strokeWidth: 1,
                              dashArray: [
                                3,
                                3
                              ], // Add dash array for dashed lines
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return const FlLine(
                              color: AcnooAppColors.kNeutral300,
                              strokeWidth: 1,
                              dashArray: [
                                3,
                                3
                              ], // Add dash array for dashed lines
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
