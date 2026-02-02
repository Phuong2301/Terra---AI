import 'package:app_mobile/domain/services/submission_sync_service.dart';
import 'package:app_mobile/presentation/api_service/api_admin_stats.dart';
import 'package:app_mobile/presentation/model/ai_model_stats.dart';
import 'package:flutter/foundation.dart';

import '../api_service/assessment_local_store.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    this.fallbackFarmersTotal = 127,
  });

  final int fallbackFarmersTotal;

  int _farmersTotal = 127;
  int _myAssessments = 0;
  int _thisWeekGrowth = 0; 
  bool _loading = true;

  AiModelStats? _ai;
  AiModelStats? get ai => _ai;

  int get farmersTotal => _farmersTotal;
  int get myAssessments => _myAssessments;
  int get thisWeekGrowth => _thisWeekGrowth;
  bool get loading => _loading;

  Future<void> init() async {
    await loadStats();
    SubmissionSyncService.start();
  }

  Future<void> loadStats() async {
    _loading = true;
    notifyListeners();

    final localTotal = await AssessmentLocalStore.getFarmersTotal(
      fallback: fallbackFarmersTotal,
    );
    final mine = await AssessmentLocalStore.getSubmittedCount();

    _farmersTotal = localTotal;
    _myAssessments = mine;
    notifyListeners();

    final data = await ApiAdminStats.fetchStats();

    if (data != null) {
      final total = _toInt(data['farmersAssessedTotal']);
      final week = _toInt(data['farmersAssessedThisWeek']);

      if (total > 0) _farmersTotal = total;
      _thisWeekGrowth = week;

      final aiStats = await ApiAdminStats.fetchAiModelStats();
        if (aiStats != null) {
          _ai = aiStats;
        } else {
          _ai ??= const AiModelStats(version: 'v1.3', trainedOnFarmers: 89, accuracy: 0.82);
        }
    }

    _loading = false;
    notifyListeners();
  }

  int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
