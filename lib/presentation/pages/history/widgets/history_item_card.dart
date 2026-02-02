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

  int _toInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? fallback;
  }

  String _toStr(dynamic v, {String fallback = ''}) {
    final s = (v ?? '').toString().trim();
    return s.isEmpty ? fallback : s;
  }

  Map<String, dynamic>? _asMap(dynamic v) {
    if (v is Map) return v.cast<String, dynamic>();
    return null;
  }

  int _readFinalScore(Map<String, dynamic> it) {
    // 1) flattened
    final s1 = _toInt(it['finalScore'], fallback: -1);
    if (s1 >= 0) return s1;

    // 2) BE raw map (score.finalScore)
    final scoreMap = _asMap(it['score']);
    final s2 = _toInt(scoreMap?['finalScore'], fallback: -1);
    if (s2 >= 0) return s2;

    // 3) snapshot _be.score.finalScore
    final be = _asMap(it['_be']);
    final beScore = _asMap(be?['score']);
    final s3 = _toInt(beScore?['finalScore'], fallback: 0);
    return s3;
  }

  String _readRiskCategory(Map<String, dynamic> it) {
    // 1) canonical flattened
    final c1 = _toStr(it['riskCategory']);
    if (c1.isNotEmpty) return c1;

    // 2) backward compatible
    final c2 = _toStr(it['category']);
    if (c2.isNotEmpty) return c2;

    // 3) BE raw map (score.riskCategory)
    final scoreMap = _asMap(it['score']);
    final c3 = _toStr(scoreMap?['riskCategory']);
    if (c3.isNotEmpty) return c3;

    // 4) snapshot _be.score.riskCategory
    final be = _asMap(it['_be']);
    final beScore = _asMap(be?['score']);
    return _toStr(beScore?['riskCategory']);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final name = (item['fullName'] ?? 'Farmer').toString();
    final createdAt = fmtDate((item['createdAt'] ?? '').toString());

    final score = _readFinalScore(item);
    final category = _readRiskCategory(item);
    final c = scoreColor(score);

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // mở ResultsScreen
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
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: c,
                      fontSize: 16,
                    ),
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
                      Text(
                        category,
                        style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
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
