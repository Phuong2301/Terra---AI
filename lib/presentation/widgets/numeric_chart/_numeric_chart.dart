// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l ;
import '../../../domain/core/theme/theme.dart';

class NumericAxisChart extends StatefulWidget {
  const NumericAxisChart({super.key});

  @override
  State<NumericAxisChart> createState() => _NumericAxisChartState();
}

class _NumericAxisChartState extends State<NumericAxisChart> {
  final List<ChartData> chartData = [
    ChartData('01', 5),
    ChartData('02', 15),
    ChartData('03', 20),
    ChartData('07', 30),
    ChartData('10', 13),
    ChartData('13', 25),
    ChartData('16', 44),
    ChartData('19', 30),
    ChartData('21', 20),
    ChartData('23', 16),
    ChartData('25', 20),
    ChartData('27', 10),
    ChartData('29', 17),
    ChartData('31', 14),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Scaffold(
      body: Center(
        child: Container(
          color: theme.colorScheme.primaryContainer,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(
              axisLine: AxisLine(width: 0), // Remove bottom axis line
              majorGridLines:
                  MajorGridLines(width: 0), // Remove vertical grid lines
              majorTickLines: MajorTickLines(size: 0),
            ),
            primaryYAxis: const NumericAxis(
              axisLine: AxisLine(width: 0), // Remove left axis line
              majorGridLines: MajorGridLines(
                color: Color(0xffD1D5DB),
                dashArray: [
                  5,
                  5
                ], // Creates a dotted line pattern for horizontal grid lines
              ),
            ),
            plotAreaBorderWidth: 0,
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                spacing: 0.3,
                width: 0.5,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
               // name: 'Sales',
                name: lang.sales,
                onPointTap: (ChartPointDetails details) {
                  _showPopup(context, chartData[details.pointIndex!]);
                },
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                gradient: const LinearGradient(
                    colors: [Color(0xffB779FF), Color(0xff7500FD)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  // bottomRight: Radius.circular(10),
                  // bottomLeft: Radius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, ChartData data) {
  final lang = l.S.of(context);
  TextTheme textTheme = Theme.of(context).textTheme;
  ColorScheme color = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: color.primaryContainer,
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
                text: TextSpan(
                    text: '${lang.date}: ',
                    style: textTheme.titleSmall?.copyWith(fontSize: 12),
                    children: const [
                  TextSpan(
                    text: '13-16 Feb 2024',
                  )
                ])),
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: AcnooAppColors.kPrimary500,
                  size: 10,
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                    text: TextSpan(
                       // text: 'Word Generated: ',
                        text: '${lang.wordGenerated}: ',
                        style: textTheme.bodySmall?.copyWith(fontSize: 12),
                        children: [
                      TextSpan(
                          text: '7,000',
                          style: textTheme.titleSmall?.copyWith(fontSize: 12))
                    ]))
              ],
            )
          ],
        ),
      );
    },
  );
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
