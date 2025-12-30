import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/domain/core/static/_static_strings.dart';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';
import '../../../../../generated/l10n.dart' as l;

const colorList = <Color>[
  AcnooAppColors.kWarning,
  AcnooAppColors.kSuccess,
  AcnooAppColors.kError,
  AcnooAppColors.kPrimary600,
];

class PieChartWidget extends StatefulWidget {
  const PieChartWidget(this.data, {super.key});
  final Map<String, double>? data;

  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lang = l.S.of(context);
        final data = widget.data;
        if (data == null || data.isEmpty) {
          return Container(
            padding: const EdgeInsetsDirectional.all(8),
            child: Center(child: Text(lang.noData)),
          );
        }

        const double pieSide = 164;
        const double chartSize = pieSide / 2;

        final hasAnyValue = data.values.any((v) => v > 0);
        final noData = !hasAnyValue;

        final entries = data.entries.toList();
        final total = entries.fold<double>(0, (prev, e) => prev + e.value);

        final bool hasSelection =
            touchedIndex >= 0 && touchedIndex < entries.length;
        final selectedEntry = hasSelection ? entries[touchedIndex] : null;
        final selectedPercent = (hasSelection && total > 0)
            ? (selectedEntry!.value / total * 100.0)
            : 0.0;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                child: noData
                    ? Center(child: Text(lang.noData))
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Center(
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: PieChart(
                                      PieChartData(
                                        centerSpaceRadius: chartSize * 0.5,
                                        pieTouchData: PieTouchData(
                                          touchCallback: (
                                            FlTouchEvent event,
                                            pieTouchResponse,
                                          ) {
                                            setState(() {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse
                                                          .touchedSection ==
                                                      null) {
                                                touchedIndex = -1;
                                                return;
                                              }
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          },
                                        ),
                                        borderData: FlBorderData(show: false),
                                        sectionsSpace: 0,
                                        sections: showingSection(
                                          chartSize,
                                          entries,
                                          total,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(right: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: entries
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  final index = e.key;
                                  final entry = e.value;
                                  final color =
                                      colorList[index % colorList.length];

                                  final isActive = index == touchedIndex;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            entry.key,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: isActive
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                            softWrap: true,
                                            maxLines: 3,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              if (hasSelection)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text(
                    '${selectedEntry!.key}: '
                    '${selectedEntry.value.toStringAsFixed(2)} '
                    '(${selectedPercent.toStringAsFixed(1)}%)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSection(
    double chartSize,
    List<MapEntry<String, double>> entries,
    double total,
  ) {
    final fontSize = rf.ResponsiveValue<double?>(
      context,
      conditionalValues: [
        rf.Condition.smallerThan(
          name: BreakpointName.SM.name,
          value: 13,
        )
      ],
    ).value;

    final theme = Theme.of(context);

    return List.generate(entries.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? chartSize * 0.6 : chartSize * 0.5;

      final value = entries[i].value;
      final percent = total > 0 ? (value / total * 100) : 0.0;

      final style = theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: AcnooAppColors.kWhiteColor,
      );

      final color = colorList[i % colorList.length];

      return PieChartSectionData(
        color: color,
        radius: radius,
        title: '${percent.toStringAsFixed(1)}%',
        value: percent,
        titleStyle: style,
      );
    });
  }
}
