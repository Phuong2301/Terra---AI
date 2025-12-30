import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoItem {
  final String label;
  final String value;
  final IconData? leadingIcon;
  final bool copyable;
  final VoidCallback? onTap; 

  const InfoItem({
    required this.label,
    required this.value,
    this.leadingIcon,
    this.copyable = true,
    this.onTap,
  });
}

class InfoPairsBottomSheet extends StatelessWidget {
  final String? title;
  final List<InfoItem> items;
  final bool hideEmpty; 

  const InfoPairsBottomSheet({
    super.key,
    this.title,
    required this.items,
    this.hideEmpty = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required List<InfoItem> items,
    bool hideEmpty = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => InfoPairsBottomSheet(
        title: title,
        items: items,
        hideEmpty: hideEmpty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = hideEmpty
        ? items.where((e) {
            final t = e.value.trim().toLowerCase();
            return t.isNotEmpty && t != 'null';
          }).toList()
        : items;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 12),
              Text(title!, style: theme.textTheme.titleMedium),
            ],
            const SizedBox(height: 8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (ctx, i) {
                  final it = filtered[i];
                  return ListTile(
                    leading: it.leadingIcon == null ? null : Icon(it.leadingIcon),
                    title: Text(it.label),
                    subtitle: Text(it.value),
                    onTap: it.onTap,
                    trailing: it.copyable
                        ? IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy',
                            onPressed: () => _copy(ctx, it.value),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã copy vào clipboard')),
    );
  }
}
