// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    this.headerTitle,
    this.headerStyle,
    this.leading,
    this.headerPadding,
    this.onClose,
    this.showCloseButton = true,
    this.trailing,
    this.trailingConstraints,
  }) : assert(!showCloseButton || trailing == null);

  final String? headerTitle;
  final TextStyle? headerStyle;
  final Widget? leading;
  final EdgeInsetsGeometry? headerPadding;

  final void Function()? onClose;
  final bool showCloseButton;
  final Widget? trailing;
  final BoxConstraints? trailingConstraints;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: const [
        rf.Condition.between(
          start: 0,
          end: 350,
          value: _SizeInfo(
            fonstSize: 16,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        rf.Condition.between(
          start: 351,
          end: 410,
          value: _SizeInfo(
            fonstSize: 18,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        rf.Condition.between(
          start: 411,
          end: 675,
          value: _SizeInfo(
            fonstSize: 18,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _theme.colorScheme.outline),
        ),
      ),
      padding: headerPadding ?? _sizeInfo.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) leading!,
          if (headerTitle != null)
            Expanded(
              child: Text(
                headerTitle!,
                style: _theme.textTheme.titleLarge?.copyWith(
                  fontSize: _sizeInfo.fonstSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Close Button
          if (showCloseButton)
            IconButton(
              onPressed: () {
                onClose?.call();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              color: _theme.colorScheme.error,
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
            )
          else if (trailing != null)
            ConstrainedBox(
              constraints: trailingConstraints ??
                  BoxConstraints.loose(
                    const Size.fromHeight(48),
                  ),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  const _SizeInfo({
    this.fonstSize = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  });
}
