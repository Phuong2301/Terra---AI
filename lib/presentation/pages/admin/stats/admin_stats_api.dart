import 'dart:convert';
import 'package:app_mobile/domain/api_request_client/api_request_client.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:flutter/foundation.dart';

class ApiAdminStats {
  /// ✅ Dùng API export thay cho stats
  /// GET /api/admin/export?format=json
  /// Response:
  /// {
  ///   "ok": true,
  ///   "totalAssessments": 24,
  ///   "data": [ { "createdAt": "...", ... } ],
  ///   "meta": { ... }
  /// }
  ///
  /// Hàm này trả về map dạng "stats" để HomeController dùng như cũ:
  /// {
  ///   "farmersAssessedTotal": <int>,
  ///   "farmersAssessedThisWeek": <int>,
  ///   "weekStartIso": <String>,
  ///   // "aiModel": ... (không có từ export)
  /// }
  static Future<Map<String, dynamic>?> fetchStats() async {
    try {
      final url = ('${AppConfig.baseURL}/api/admin/export?format=json');
      final response = await ApiRequestClient.get(url: url);

      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return null;

      final map = decoded.map((k, v) => MapEntry(k.toString(), v));

      final total = _toInt(map['totalAssessments']);
      final dataList = (map['data'] is List) ? (map['data'] as List) : const [];

      final weekStart = _weekStartUtcIso(DateTime.now().toUtc());
      final thisWeek = _countFromIsoAfterOrEqual(dataList, weekStart);

      return <String, dynamic>{
        'farmersAssessedTotal': total > 0 ? total : dataList.length,
        'farmersAssessedThisWeek': thisWeek,
        'weekStartIso': weekStart,
        // export không trả aiModel => HomeController sẽ fallback
      };
    } catch (e) {
      if (kDebugMode) {
        print("ApiAdminStats fetchStats error: $e");
      }
      return null;
    }
  }

  static Future<int?> fetchFarmersTotal() async {
    final data = await fetchStats();
    if (data == null) return null;
    return _toInt(data['farmersAssessedTotal']);
  }

  /// Đếm record có createdAt >= weekStartIso
  static int _countFromIsoAfterOrEqual(List<dynamic> dataList, String weekStartIso) {
    final start = DateTime.tryParse(weekStartIso);
    if (start == null) return 0;

    int count = 0;
    for (final item in dataList) {
      if (item is! Map) continue;

      final createdAtRaw = item['createdAt']?.toString();
      if (createdAtRaw == null) continue;

      final dt = DateTime.tryParse(createdAtRaw);
      if (dt == null) continue;

      if (dt.toUtc().isAfter(start) || dt.toUtc().isAtSameMomentAs(start)) {
        count++;
      }
    }
    return count;
  }

  /// Week start (UTC) theo thứ 2 (Monday) 00:00:00
  static String _weekStartUtcIso(DateTime nowUtc) {
    final day = nowUtc.weekday; // Mon=1..Sun=7
    final monday = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day)
        .subtract(Duration(days: day - 1));
    return monday.toIso8601String();
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
