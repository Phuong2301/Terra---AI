import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../generated/l10n.dart' as l;
class NumericAxisChart extends StatefulWidget {
  const NumericAxisChart(this.chartDatas, {super.key});
  final List<ChartData> chartDatas;

  @override
  State<NumericAxisChart> createState() => _NumericAxisChartState();
}

class _NumericAxisChartState extends State<NumericAxisChart> {
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final delta = responsiveValue<int>(context, xs: 3, md: 6, lg: 10);
    final _zoomPan = ZoomPanBehavior(enablePanning: true, enablePinching: true);
    final _tooltip = TooltipBehavior(enable: false, animationDuration: 0);
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          zoomPanBehavior: _zoomPan,
          tooltipBehavior: _tooltip,
          enableAxisAnimation: false,
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
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              animationDuration: 0,
              name: lang.sales,
              onPointTap: (details) {
                final item = widget.chartDatas[details.pointIndex!];
                _showPopup(context, item, lang);
              },
              dataLabelSettings: const DataLabelSettings(isVisible: false),
              pointColorMapper: (ChartData data, _) => Color(data.color),
            ),
          ],
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, ChartData d, l.S lang) {
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
          Text(
            d.x
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.circle, size: 10),
              const SizedBox(width: 6),
              Text(
                d.y.toStringAsFixed(0)
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final double y;
  final int color;
}