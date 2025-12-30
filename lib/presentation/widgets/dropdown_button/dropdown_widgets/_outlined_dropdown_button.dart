part of '../_dropdown_button.dart';

class OutlinedDropdownButton extends StatelessWidget {
  const OutlinedDropdownButton({
    super.key,
    this.child,
    this.trailingIcon,
    this.decoration,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  final Widget? child;
  final Widget? trailingIcon;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);

    final _mqSize = MediaQuery.sizeOf(context);

    final _decoration = decoration ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _theme.colorScheme.outline,
          ),
        );

    return Container(
      padding: padding,
      decoration: _decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: child ?? const SizedBox.shrink()),
          SizedBox(width: _mqSize.width >= 480 ? 8 : 4),
          trailingIcon ?? _dropdownStyle.iconStyle.icon,
        ],
      ),
    );
  }
}
