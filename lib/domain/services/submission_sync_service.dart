import 'dart:async';
import 'package:app_mobile/domain/services/network_service.dart';
import 'package:app_mobile/presentation/pages/assessment/services/api_assessment.dart';
import 'package:app_mobile/presentation/pages/assessment/services/assessment_local_store.dart';
import 'package:app_mobile/presentation/pages/demo/demo_mode_store.dart';

class SubmissionSyncService {
  SubmissionSyncService._();

  static StreamSubscription<bool>? _sub;
  static bool _syncing = false;

  static void start() {
    _sub?.cancel();
    _sub = NetworkService.onlineStream().listen((online) async {
      if (online) {
        await syncOnce();
      }
    });
  }

  static Future<void> syncOnce() async {
    if (_syncing) return;
    _syncing = true;

    try {
      final online = await NetworkService.isOnline();
      if (!online) return;

      final isDemo = await DemoModeStore.isEnabled();
      if (isDemo) return;

      final queue = await AssessmentLocalStore.loadQueue();

      for (final item in List<Map<String, dynamic>>.from(queue)) {
        final res = await ApiAssessment.submit(item);
        final ok = res != null;

        if (ok) {
          await AssessmentLocalStore.removeFromQueue(item['id']?.toString() ?? '');
          await AssessmentLocalStore.updateAssessment(item['id']?.toString() ?? '', {
            'status': 'submitted_remote',
          });
        }
      }
    } finally {
      _syncing = false;
    }
  }

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
