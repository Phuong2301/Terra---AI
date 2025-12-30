import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  const CustomRangeSlider({
    super.key,
    this.barWidth,
    this.barSpacing,
    this.maxBarHeight,
  });

  final double? barWidth;
  final double? barSpacing;
  final double? maxBarHeight;

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  RangeValues rangeValues = const RangeValues(0, 500);
  List<(double, double)> barHeights = [];

  void _generateBarHeights(
    int barCount,
    double maxBarHeight,
    double splitValue,
  ) {
    final _random = math.Random();
    barHeights.clear();
    for (var i = 0; i < barCount; i++) {
      final _barHeight = _random.nextDouble() * maxBarHeight;
      var _newValue = splitValue * (i + 1);
      barHeights.add((_barHeight, _newValue));
    }
  }

  void _updateBarsIfNeeded(BoxConstraints constraints) {
    final _barWidth = widget.barWidth ?? 2;
    final _barSpacing = widget.barSpacing ?? 8;
    final _maxBarHeight = widget.maxBarHeight ?? 60;

    final _barCount = constraints.biggest.width ~/ (_barWidth + _barSpacing);

    if (barHeights.length != _barCount) {
      final _splitValue = rangeValues.end / _barCount;
      _generateBarHeights(_barCount, _maxBarHeight, _splitValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        _updateBarsIfNeeded(constraints);

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                barHeights.length,
                (index) {
                  final _value = barHeights[index];

                  bool _isActive = (_value.$2 >= rangeValues.start &&
                      _value.$2 <= rangeValues.end);

                  return Flexible(
                    child: Container(
                      width: widget.barWidth ?? 2,
                      height: _value.$1.clamp(10, widget.maxBarHeight ?? 60),
                      margin: EdgeInsets.symmetric(
                        horizontal: (widget.barSpacing ?? 8) / 2,
                      ),
                      decoration: BoxDecoration(
                        color: _isActive
                            ? _theme.colorScheme.primary
                            : _theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(
                          (widget.barWidth ?? 2) / 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                overlayShape: SliderComponentShape.noThumb,
              ),
              child: RangeSlider(
                values: rangeValues,
                min: 0,
                max: 500,
                divisions: 500,
                labels: RangeLabels(
                  rangeValues.start.toStringAsFixed(0),
                  rangeValues.end.toStringAsFixed(0),
                ),
                onChanged: (v) => setState(() => rangeValues = v),
              ),
            ),
          ],
        );
      },
    );
  }
}
