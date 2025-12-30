// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 🌎 Project imports:
import '../../../domain/helpers/helpers.dart';

class OverviewTileWidget extends StatefulWidget {
  const OverviewTileWidget({
    super.key,
    this.imagePath,
    this.icon,
    this.iconSize = 48,
    this.iconRadius,
    this.iconAlignment = IconAlignment.start,
    this.iconBackgroundColor,
    required this.value,
    this.showCurrency = false,
    this.decimalDigits = 0,
    this.valueStyle,
    required this.title,
    this.titleStyle,
    this.tileColor,
    this.tileDecoration,
  })  : assert(
          imagePath == null || icon == null,
          'imagePath & icon cannot be used together',
        ),
        assert(
          tileColor == null || tileDecoration == null,
          'tileColor & tileDecoration cannot be used together',
        );

  /// Use imagePath if the leading widget is any kind of image [such as: Network, Asset or SVG]
  final String? imagePath;
  final Widget? icon;
  final double iconSize;
  final BorderRadiusGeometry? iconRadius;
  final IconAlignment iconAlignment;
  final Color? iconBackgroundColor;

  final num value;
  final bool showCurrency;
  final int decimalDigits;
  final TextStyle? valueStyle;
  final String title;
  final TextStyle? titleStyle;

  final Color? tileColor;
  final BoxDecoration? tileDecoration;

  @override
  State<OverviewTileWidget> createState() => _OverviewTileWidgetState();
}

class _OverviewTileWidgetState extends State<OverviewTileWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _cardPadding = responsiveValue<double>(
      context,
      xs: 12,
      sm: 12,
      md: 14,
      lg: 16,
    );

    final _content = [
      // Icon
      Container(
        constraints: BoxConstraints.tight(Size.square(widget.iconSize)),
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: widget.iconRadius ?? BorderRadius.circular(8),
          color: widget.iconBackgroundColor ??
              _theme.primaryColor.withOpacity(0.25),
        ),
        child: widget.icon ??
            getImageType(
              widget.imagePath,
              fit: BoxFit.cover,
              height: double.maxFinite,
              width: double.maxFinite,
            ),
      ),

      const SizedBox(width: 14),

      // Info
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Value
            Text(
              NumberFormat.currency(
                symbol: widget.showCurrency ? context.getLocaleCurrency() : '',
                decimalDigits: widget.decimalDigits,
              ).format(widget.value),
              style:
                  (widget.valueStyle ?? _theme.textTheme.titleLarge)?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: responsiveValue<double>(
                  context,
                  xs: 18,
                  md: 20,
                  lg: 20,
                ),
              ),
            ),

            // Title
            Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  (widget.titleStyle ?? _theme.textTheme.bodyLarge)?.copyWith(
                color: widget.titleStyle?.color ??
                    _theme.colorScheme.onTertiaryContainer,
                fontSize: responsiveValue<double>(
                  context,
                  xs: 14,
                  md: 16,
                  lg: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    final _tileColor = widget.tileColor ??
        widget.tileDecoration?.color ??
        _theme.colorScheme.primaryContainer;
    final _tileBorderRadius = widget.tileDecoration?.borderRadius ??
        BorderRadiusDirectional.circular(8);

    return MouseRegion(
      onEnter: (_) => changeHoverState(true),
      onExit: (_) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: _tileColor,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: _tileBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsetsDirectional.all(_cardPadding + 2),
          decoration: widget.tileDecoration,
          child: Row(
            mainAxisAlignment: widget.iconAlignment == IconAlignment.end
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: widget.iconAlignment == IconAlignment.end
                ? _content.reversed.toList()
                : _content,
          ),
        ),
      ),
    );
  }
}
