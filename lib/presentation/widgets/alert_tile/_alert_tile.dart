// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 📦 Package imports:

class AcnooAlertTile extends StatelessWidget {
  const AcnooAlertTile._(
    this.alertText, {
    super.key,
    this.icon,
    this.iconAlignment,
    this.decoration,
    this.foregroundColor,
    this.onClose,
  });
  final String alertText;
  final IconData? icon;
  final IconAlignment? iconAlignment;
  final BoxDecoration? decoration;
  final Color? foregroundColor;
  final void Function()? onClose;

  AcnooAlertTile.solid(
    String alertText, {
    Key? key,
    IconData? icon,
    IconAlignment iconAlignment = IconAlignment.start,
    Color? backgroundColor,
    Color? foregroundColor,
    void Function()? onClose,
  }) : this._(
          key: key,
          alertText,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: foregroundColor ?? Colors.white,
          onClose: onClose,
        );

  AcnooAlertTile.border(
    String alertText, {
    Key? key,
    IconData? icon,
    IconAlignment iconAlignment = IconAlignment.start,
    Color? backgroundColor,
    Color? foregroundColor,
    void Function()? onClose,
  }) : this._(
          key: key,
          alertText,
          icon: icon,
          iconAlignment: iconAlignment,
          decoration: BoxDecoration(
            color: backgroundColor?.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(
                color: backgroundColor ?? Colors.white,
                width: 2.5,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          ),
          foregroundColor: foregroundColor ?? backgroundColor ?? Colors.white,
          onClose: onClose,
        );

  AcnooAlertTile.outline(
    String alertText, {
    Key? key,
    IconData? icon,
    IconAlignment iconAlignment = IconAlignment.start,
    Color? backgroundColor,
    Color? foregroundColor,
    void Function()? onClose,
  }) : this._(
          key: key,
          alertText,
          icon: icon,
          iconAlignment: iconAlignment,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: backgroundColor ?? Colors.white,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          foregroundColor: foregroundColor ?? backgroundColor ?? Colors.white,
          onClose: onClose,
        );

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _fontSize = responsiveValue<double?>(
      context,
      xs: 12,
      sm: 12,
      md: 12,
      lg: 16,
    );

    final _alertContent = [
      if (icon != null)
        Flexible(
          child: Padding(
            padding: iconAlignment == IconAlignment.start
                ? const EdgeInsets.only(right: 8)
                : const EdgeInsets.only(left: 8),
            child: Icon(
              icon,
              color: foregroundColor,
              size: _fontSize,
            ),
          ),
        ),
      Expanded(
        flex: 12,
        child: Text(
          alertText,
          style: _theme.textTheme.bodyLarge?.copyWith(
            fontSize: _fontSize,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      ),
    ];
    return Container(
      decoration: decoration,
      padding: responsiveValue<EdgeInsetsGeometry?>(
        context,
        xs: const EdgeInsets.symmetric(horizontal: 10, vertical: 6 / 2.5),
        sm: const EdgeInsets.symmetric(horizontal: 12, vertical: 6 / 2.5),
        md: const EdgeInsets.symmetric(horizontal: 14, vertical: 8 / 2.5),
        lg: const EdgeInsets.symmetric(horizontal: 24, vertical: 14 / 2.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: iconAlignment == IconAlignment.start
                  ? _alertContent
                  : _alertContent.reversed.toList(),
            ),
          ),
          IconButton(
            onPressed: onClose,
            visualDensity: const VisualDensity(
              horizontal: -4,
              vertical: -4,
            ),
            padding: EdgeInsets.zero,
            color: foregroundColor,
            iconSize: (_fontSize ?? 0) + 2,
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
