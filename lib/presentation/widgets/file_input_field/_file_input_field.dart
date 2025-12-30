// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AcnooFileInputField extends StatelessWidget {
  const AcnooFileInputField({
    super.key,
    this.onTap,
    this.decoration,
    this.filePath,
    this.prefixText,
    this.prefixStyle,
    this.textStyle,
  });
  final void Function()? onTap;
  final InputDecoration? decoration;
  final String? filePath;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _currentDecoration = decoration ?? const InputDecoration();

    final _enabledBorder =
        _currentDecoration.enabledBorder as OutlineInputBorder?;

    return Material(
      borderRadius: _enabledBorder?.borderRadius,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final _size = constraints.biggest;
            return InputDecorator(
              decoration: _currentDecoration.copyWith(
                contentPadding: EdgeInsetsDirectional.zero,
                prefix: Container(
                  margin: EdgeInsetsDirectional.all(
                    _currentDecoration.enabledBorder?.borderSide.width ?? 1,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 100,
                    maxWidth: _size.width > 120 ? 120 : _size.width * 0.35,
                  ),
                  decoration: BoxDecoration(
                    color: _theme.colorScheme.tertiaryContainer,
                    border: Border(
                      right: BorderSide(
                        color: _enabledBorder?.borderSide.color ??
                            (_theme.inputDecorationTheme.enabledBorder
                                    as OutlineInputBorder?)
                                ?.borderSide
                                .color ??
                            Colors.black,
                      ),
                    ),
                    borderRadius: BorderRadius.horizontal(
                      left: (_currentDecoration.enabledBorder
                                  as OutlineInputBorder?)
                              ?.borderRadius
                              .topLeft ??
                          const Radius.circular(4),
                    ),
                  ),
                  padding: _currentDecoration.contentPadding,
                  alignment: Alignment.center,
                  child: Text(
                    prefixText ?? 'Choose File',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyLarge?.copyWith(
                      color: _theme.colorScheme.onTertiaryContainer,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Text(
                  filePath ?? _currentDecoration.hintText ?? 'Select File',
                  style: textStyle ??
                      _theme.textTheme.bodyMedium?.copyWith(
                        color: _theme.colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
