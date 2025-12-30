// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

class AcnooToggleButtonStyles {
  AcnooToggleButtonStyles(this.context);
  final BuildContext context;

  // Theme
  ThemeData get _theme => Theme.of(context);

  // Responsive Values
  SizingInfo get sizeInfo => rf.ResponsiveValue(
        context,
        conditionalValues: <rf.Condition<SizingInfo>>[
          rf.Condition.between(
            start: 0,
            end: 375,
            value: SizingInfo(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textStyle: _theme.textTheme.bodyLarge?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          rf.Condition.between(
            start: 376,
            end: 490,
            value: SizingInfo(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              textStyle: _theme.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
        defaultValue: SizingInfo(
          textStyle: _theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ).value;

  Color get fillColor => _theme.primaryColor;
  Color get selectedBorderColor => fillColor;
  Color get selectedColor => _theme.colorScheme.onPrimary;
  Color get unselectedColor => _theme.colorScheme.onTertiary;
}

@immutable
class SizingInfo {
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  const SizingInfo({
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.textStyle,
  });
}
