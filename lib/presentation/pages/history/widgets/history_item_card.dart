import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../history_helpers.dart';

class HistoryItemCard extends StatelessWidget {
  const HistoryItemCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final Map<String, dynamic> item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final name = (item['fullName'] ?? 'Farmer').toString();
    final createdAt = fmtDate((item['createdAt'] ?? '').toString());

    final score = int.tryParse((item['score'] ?? '').toString()) ?? 0;
    final category = (item['category'] ?? '').toString();
    final c = scoreColor(score);

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // ✅ mở lại ResultsScreen để xem full details
          context.push('/results', extra: item);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: c.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '$score',
                    style: TextStyle(fontWeight: FontWeight.w900, color: c, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(createdAt, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(category, style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
