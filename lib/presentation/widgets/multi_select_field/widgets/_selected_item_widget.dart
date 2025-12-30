part of '../_multi_select_field.dart';

class SelectedItemButton extends StatelessWidget {
  const SelectedItemButton({
    super.key,
    required this.labelText,
    this.padding,
    this.onTap,
    this.showCloseButton = true,
  });
  final String labelText;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
      decoration: BoxDecoration(
        color: _theme.primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text.rich(
        TextSpan(
          text: labelText,
          children: [
            if (showCloseButton)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: InkWell(
                    onTap: onTap,
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        style: TextStyle(color: _theme.colorScheme.onPrimary),
      ),
    );
  }
}
