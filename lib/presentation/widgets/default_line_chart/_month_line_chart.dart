// 🐦 Flutter imports:
import 'dart:math';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/domain/core/static/_static_strings.dart';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';

// 🌎 Project imports:
//import '../../../generated/l10n.dart' as l;

class MonthLineChart extends StatefulWidget {
  const MonthLineChart({super.key, required this.params});

  final List<double> params;

  @override
  State<MonthLineChart> createState() => _DefaultLineChartState();
}

class _DefaultLineChartState extends State<MonthLineChart> {
  List<Color> gradientColors = [
    AcnooAppColors.kPrimary600,
    AcnooAppColors.kPrimary600,
  ];

  bool showAvg = false;
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  List<FlSpot> flSpot = [];
  List<int> avgs = [];

  String getAvg(value) {
    if(value > 1000000) return '${value ~/ 1000000}M'; 
    if (value > 1000) return '${value ~/ 1000}K';
    return value;
  }

  @override
  void initState() {
    super.initState();
    flSpot = widget.params
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final avg = widget.params.reduce(max) ~/ 5;
    avgs = [0, avg * 1, avg * 2, avg * 3, avg * 4, avg * 5];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final lang = l.S.of(context);
    final titleFontSize = rf.ResponsiveValue<double?>(
      context,
      conditionalValues: [
        rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 14)
      ],
    ).value;
    return LayoutBuilder(
      builder: (context, constraints) {
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
                    "Sales in Current Financial Year",
                    //lang.defaultLineChart,
                    //'Default Line Chart',
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
                      // showAvg ? avgData() :
                      mainData(),
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final fontSize = rf.ResponsiveValue<double?>(
      context,
      conditionalValues: [
        // const rf.Condition.between(start: 280, end: 320, value: 7.0),
        rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 10.0),
      ],
    ).value;
    final style =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize);
    Widget text = Text(months[value.toInt()], style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final fontSize = rf.ResponsiveValue<double?>(context, conditionalValues: [
      rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 10)
    ]).value;
    final style =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize);
    String text = avgs.contains(value.toInt()) ? getAvg(value) : '';
    return Text(text, style: style);
  }

  LineChartData mainData() {
    final kReverzeSize = rf.ResponsiveValue<double?>(context,
                conditionalValues: [
                  rf.Condition.smallerThan(
                      name: BreakpointName.SM.name, value: 25),
                ],
                defaultValue: 40)
            .value ??
        40;
    final kBarWidth = rf.ResponsiveValue<double?>(context,
                conditionalValues: [
                  rf.Condition.smallerThan(
                      name: BreakpointName.SM.name, value: 2),
                ],
                defaultValue: 4)
            .value ??
        4;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false, // Remove vertical grid lines
        horizontalInterval: 5000,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AcnooAppColors.kNeutral300,
            strokeWidth: 1,
            dashArray: [3, 3], // Add dash array for dotted line
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: avgs[1].toDouble(),
            getTitlesWidget: leftTitleWidgets,
            reservedSize: kReverzeSize,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: flSpot.length.toDouble() - 1,
      minY: widget.params.reduce(min),
      maxY: widget.params.reduce(max),
      lineBarsData: [
        LineChartBarData(
          spots: [...flSpot],
          isCurved: true,
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          barWidth: kBarWidth,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          // belowBarData: BarAreaData(
          //   show: true,
          //   gradient: LinearGradient(
          //       colors: [
          //         const Color(0xff7500FD).withOpacity(0.09),
          //         const Color(0xffDAC0FE).withOpacity(0.15)
          //       ],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter
          //
          //   ),
          // ),
        ),
      ],
    );
  }

  // LineChartData avgData() {
  //   return LineChartData(
  //     lineTouchData: const LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: true,
  //       drawVerticalLine: false, // Remove vertical grid lines
  //       horizontalInterval: 5000,
  //       getDrawingHorizontalLine: (value) {
  //         return const FlLine(
  //           color: AcnooAppColors.kNeutral300,
  //           strokeWidth: 1,
  //           dashArray: [3, 3], // Add dash array for dotted line
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           getTitlesWidget: bottomTitleWidgets,
  //           interval: 1,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           getTitlesWidget: leftTitleWidgets,
  //           reservedSize: 42,
  //           interval: 5000,
  //         ),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: false,
  //       border: Border.all(color: const Color(0xff37434d)),
  //     ),
  //     minX: 1,
  //     maxX: 30,
  //     minY: 0,
  //     maxY: 45000,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: const [
  //           FlSpot(1, 15000),
  //           FlSpot(4, 15000),
  //           FlSpot(7, 15000),
  //           FlSpot(10, 15000),
  //           FlSpot(13, 15000),
  //           FlSpot(16, 15000),
  //           FlSpot(19, 15000),
  //           FlSpot(22, 15000),
  //           FlSpot(25, 15000),
  //           FlSpot(28, 15000),
  //           FlSpot(30, 15000),
  //           FlSpot(35, 5000),
  //         ],
  //         isCurved: true,
  //         gradient: LinearGradient(
  //           colors: [
  //             ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                 .lerp(0.2)!,
  //             ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                 .lerp(0.2)!,
  //           ],
  //         ),
  //         barWidth: 2,
  //         isStrokeCapRound: true,
  //         dotData: const FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           // gradient: LinearGradient(
  //           //     colors: [
  //           //       ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //           //           .lerp(0.2)!
  //           //           .withOpacity(0.5),
  //           //       ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //           //           .lerp(0.2)!
  //           //           .withOpacity(0.5),
  //           //     ],
  //           //     begin: Alignment.topCenter,
  //           //     end: Alignment.bottomCenter
  //           // ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
