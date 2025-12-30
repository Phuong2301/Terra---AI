import 'package:flutter/material.dart';

class AppTappableField extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool showChevron;
  final IconData chevronIcon;
  final double chevronSize;
  final EdgeInsets chevronPadding;

  final BorderRadiusGeometry borderRadius;

  final Color? chevronColor;
  final double extraRightPaddingForChevron;

  const AppTappableField({
    super.key,
    required this.child,
    this.onTap,
    this.showChevron = true,
    this.chevronIcon = Icons.chevron_right,
    this.chevronSize = 18,
    this.chevronPadding = const EdgeInsets.only(right: 6),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.chevronColor,
    this.extraRightPaddingForChevron = 26,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final childWithSpace = showChevron
        ? Padding(padding: EdgeInsets.only(right: extraRightPaddingForChevron), child: child)
        : child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(borderRadius: borderRadius),
        child: Stack(
          children: [
            childWithSpace,
            if (showChevron)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: chevronPadding,
                    child: Icon(
                      chevronIcon,
                      size: chevronSize,
                      color: chevronColor ?? theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
