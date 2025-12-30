import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoItemDropdown {
  final String label;
  final String value;
  final IconData? icon;
  final bool copyable;

  const InfoItemDropdown({
    required this.label,
    required this.value,
    this.icon,
    this.copyable = true,
  });
}

class InfoPairsList extends StatelessWidget {
  final List<InfoItemDropdown> items;
  final bool hideEmpty;
  final EdgeInsets padding;
  final double spacing;

  const InfoPairsList({
    super.key,
    required this.items,
    this.hideEmpty = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = hideEmpty
        ? items.where((e) {
            final t = e.value.trim().toLowerCase();
            return t.isNotEmpty && t != 'null';
          }).toList()
        : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final it in filtered) ...[
          _RowItem(it: it),
          SizedBox(height: spacing),
        ],
      ],
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({required this.it});
  final InfoItemDropdown it;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (it.icon != null) ...[
            Icon(it.icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: theme.textTheme.labelMedium!
                      .copyWith(color: theme.colorScheme.primary),
                  child: Text(it.label),
                ),
                const SizedBox(height: 2),
                Text(it.value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          if (it.copyable)
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Copy',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: it.value));
                if(!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã copy vào clipboard')),
                );
              },
            ),
        ],
      ),
    );
  }
}
