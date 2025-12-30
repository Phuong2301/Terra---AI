// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

class CustomSegmentButton<T> extends StatelessWidget {
  const CustomSegmentButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T> value)? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    const _borderRadius = 4.0;

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 350,
          value: _SizeInfo(
            fonstSize: 10,
            padding: EdgeInsets.all(8),
          ),
        ),
        const rf.Condition.between(
          start: 351,
          end: 410,
          value: _SizeInfo(
            fonstSize: 12,
            padding: EdgeInsets.all(8),
          ),
        ),
        const rf.Condition.between(
          start: 411,
          end: 675,
          value: _SizeInfo(fonstSize: 12),
        ),
      ],
      defaultValue: const _SizeInfo(
        fonstSize: 12,
      ),
    ).value;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        segments.length,
        (segmentIndex) {
          final _segment = segments[segmentIndex];
          final _isSelected = selected.firstOrNull == _segment.value;

          final _isFirstSegment = segmentIndex == 0;
          final _isLastSegment = segments.length == segmentIndex + 1;

          return Material(
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelectionChanged?.call({_segment.value}),
              splashColor: _theme.splashColor,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isSelected
                        ? _theme.primaryColor
                        : _theme.colorScheme.outline,
                    width: 1.25,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: !(_isFirstSegment || _isLastSegment)
                      ? null
                      : BorderRadiusDirectional.horizontal(
                          start: _isFirstSegment
                              ? const Radius.circular(_borderRadius)
                              : Radius.zero,
                          end: _isLastSegment
                              ? const Radius.circular(_borderRadius)
                              : Radius.zero,
                        ),
                ),
                padding: _sizeInfo.padding,
                child: Row(
                  children: [
                    if (_segment.icon != null) _segment.icon!,
                    if (_segment.label != null)
                      if (_segment.label is Text)
                        Text(
                          (_segment.label! as Text).data!,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: _sizeInfo.fonstSize,
                            color: _isSelected ? _theme.primaryColor : null,
                          ),
                        )
                      else
                        _segment.label!
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });
}
