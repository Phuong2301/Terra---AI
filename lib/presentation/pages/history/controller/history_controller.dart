import 'package:app_mobile/presentation/pages/result/risk_scoring.dart';
import 'package:flutter/material.dart';
import '../../assessment/services/assessment_local_store.dart';

class HistoryController extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  bool _disposed = false;

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    _notify();

    final list = await AssessmentLocalStore.loadAssessments();
    if (_disposed) return;

    list.sort((a, b) {
      final da = DateTime.tryParse((a['createdAt'] ?? '').toString());
      final db = DateTime.tryParse((b['createdAt'] ?? '').toString());
      return (db ?? DateTime(0)).compareTo(da ?? DateTime(0));
    });

    for (final it in list) {
      final id = (it['id'] ?? '').toString();
      final hasScore = it.containsKey('score') && it['score'] != null;

      if (!hasScore && id.isNotEmpty) {
        final r = RiskScoringEngine.evaluate(it);
        final patch = {
          'score': r.finalScore,
          'category': r.category,
        };
        await AssessmentLocalStore.updateAssessment(id, patch);
        it.addAll(patch);
      }
    }

    _items = list;
    _loading = false;
    _notify();
  }

  Future<void> deleteById(String id) async {
    await AssessmentLocalStore.deleteAssessment(id);
    _items.removeWhere((e) => (e['id']?.toString() ?? '') == id);
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
