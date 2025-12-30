import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../generated/l10n.dart' as l;


class TwoColumnChart extends StatefulWidget {
  const TwoColumnChart(this.chartDatas, {super.key});
  final List<ChartData> chartDatas;

  @override
  State<TwoColumnChart> createState() => _TwoColumnChartState();
}

class _TwoColumnChartState extends State<TwoColumnChart> {
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final delta = responsiveValue<int>(context, xs: 3, md: 6, lg: 10);
    final _zoomPan = ZoomPanBehavior(enablePanning: true, enablePinching: true);
    final _tooltip = TooltipBehavior(enable: false, animationDuration: 0);

    return SfCartesianChart(
      zoomPanBehavior: _zoomPan,
      tooltipBehavior: _tooltip,
      enableAxisAnimation: false,
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelRotation: -30,
        autoScrollingDelta: delta,
        autoScrollingMode: AutoScrollingMode.start,
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        majorGridLines: MajorGridLines(
          color: Color(0xffD1D5DB),
          dashArray: [5, 5],
        ),
      ),
      plotAreaBorderWidth: 0,
      series: <CartesianSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: widget.chartDatas,
          spacing: 0.3,
          width: 0.5,
          xValueMapper: (ChartData data, _) => data.location,
          yValueMapper: (ChartData data, _) => data.passed,
          name: lang.passed,
          animationDuration: 0,
          onPointTap: (details) {
            final item = widget.chartDatas[details.pointIndex!];
            _showPopup(
              context,
              item.location,
              lang.passed,
              item.passed,
              lang,
            );
          },
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          pointColorMapper: (_, __) => const Color(0xff1cc88a),
        ),

        ColumnSeries<ChartData, String>(
          dataSource: widget.chartDatas,
          spacing: 0.3,
          width: 0.5,
          xValueMapper: (ChartData data, _) => data.location,
          yValueMapper: (ChartData data, _) => data.failed,
          name: lang.failed,
          animationDuration: 0,
          onPointTap: (details) {
            final item = widget.chartDatas[details.pointIndex!];
            _showPopup(
              context,
              item.location,
              lang.failed,
              item.failed,
              lang,
            );
          },
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          pointColorMapper: (_, __) => const Color(0xffe74a3a),
        ),
      ],
    );
  }
}
void _showPopup(
  BuildContext context,
  String location,
  String typeLabel,
  double value,
  l.S lang,
) {
  final textTheme = Theme.of(context).textTheme;
  final color = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: color.primaryContainer,
      contentPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "${lang.qcComplianceByLocation}: ",
              style: textTheme.titleSmall?.copyWith(fontSize: 12),
              children: [TextSpan(text: location)],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.circle, size: 10),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  text: '$typeLabel: ',
                  style: textTheme.bodySmall?.copyWith(fontSize: 12),
                  children: [
                    TextSpan(
                      text: value.toStringAsFixed(0),
                      style: textTheme.titleSmall?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
class ChartData {
  ChartData(this.location, this.passed, this.failed);

  final String location;
  final double passed;
  final double failed;
}