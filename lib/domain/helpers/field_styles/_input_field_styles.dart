// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AcnooInputFieldStyles {
  AcnooInputFieldStyles(this.context);

  final BuildContext context;

  // Theme
  ThemeData get _theme => Theme.of(context);

  Color get disabledFieldColor => _theme.colorScheme.tertiaryContainer;

  BoxConstraints? get iconConstraints {
    return const BoxConstraints.tightFor(
      height: 24,
      width: 24 * 1.65,
    );
  }

  OutlineInputBorder? getRoundedBorder({
    RoundedBorderType? getRoundedBorderType = RoundedBorderType.border,
    BorderRadius? borderRadius,
    Color? borderColor,
    double borderWidth = 1,
    BorderStyle? style,
    double? strokeAlign,
    double gapPadding = 4.0,
  }) {
    final _tID = _theme.inputDecorationTheme;
    final _currentBorderSide = switch (getRoundedBorderType) {
      RoundedBorderType.border => _tID.border?.borderSide,
      RoundedBorderType.enabledBorder => _tID.enabledBorder?.borderSide,
      RoundedBorderType.focusedBorder => _tID.focusedBorder?.borderSide,
      RoundedBorderType.errorBorder => _tID.errorBorder?.borderSide,
      RoundedBorderType.focusedErrorBorder =>
        _tID.focusedErrorBorder?.borderSide,
      RoundedBorderType.disabledBorder => _tID.disabledBorder?.borderSide,
      _ => null,
    };

    return OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(40),
      borderSide: _currentBorderSide ?? BorderSide.none,
      gapPadding: gapPadding,
    );
  }
}

enum RoundedBorderType {
  border,
  enabledBorder,
  focusedBorder,
  errorBorder,
  focusedErrorBorder,
  disabledBorder,
}
