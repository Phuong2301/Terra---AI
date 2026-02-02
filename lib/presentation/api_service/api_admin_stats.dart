import 'dart:convert';
import 'package:app_mobile/presentation/model/ai_model_stats.dart';
import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/api_request_client/api_request_client.dart';
import 'package:app_mobile/domain/configs/app_config.dart';

class ApiAdminStats {
  // ---------------------------
  //  AI MODEL STATS (admin)
  // ---------------------------
  static Future<AiModelStats?> fetchAiModelStats() async {
    try {
      final url = '${AppConfig.baseURL}/api/admin/stats';
      final res = await ApiRequestClient.get(url: url);

      if (res.statusCode != 200) return null;

      final decoded = json.decode(res.body);
      final data =
          (decoded is Map && decoded['data'] is Map) ? decoded['data'] as Map : decoded;

      final ai = (data is Map && data['aiModel'] is Map)
          ? (data['aiModel'] as Map).map((k, v) => MapEntry(k.toString(), v))
          : null;

      if (ai == null) return null;
      return AiModelStats.fromJson(ai.cast<String, dynamic>());
    } catch (e) {
      if (kDebugMode) {
        print('ApiAdminStats fetchAiModelStats error: $e');
      }
      return null;
    }
  }

  // ---------------------------
  //  EXPORT (shared)
  //  Single source of truth for calling /export
  // ---------------------------
  static Future<Map<String, dynamic>?> _fetchExportRaw() async {
    try {
      final url = '${AppConfig.baseURL}/api/v1/export?format=json';
      final response = await ApiRequestClient.get(url: url);
      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return null;

      // normalize key => String
      return decoded.map((k, v) => MapEntry(k.toString(), v)).cast<String, dynamic>();
    } catch (e) {
      if (kDebugMode) {
        print('ApiAdminStats _fetchExportRaw error: $e');
      }
      return null;
    }
  }

  /// Trả danh sách record export: decoded['data'] (List<Map<String,dynamic>>)
  static Future<List<Map<String, dynamic>>> fetchExportList() async {
    final raw = await _fetchExportRaw();
    if (raw == null) return const [];

    final data = raw['data'];
    if (data is! List) return const [];

    return data.whereType<Map>().map((m) {
      return m.map((k, v) => MapEntry(k.toString(), v)).cast<String, dynamic>();
    }).toList();
  }

  /// Trả stats tổng hợp dùng cho Home (tính thisWeek từ createdAt)
  static Future<Map<String, dynamic>?> fetchStats() async {
    try {
      final raw = await _fetchExportRaw();
      if (raw == null) return null;

      final total = _toInt(raw['totalAssessments']);
      final dataList = (raw['data'] is List) ? (raw['data'] as List) : const [];

      final weekStart = _weekStartUtcIso(DateTime.now().toUtc());
      final thisWeek = _countFromIsoAfterOrEqual(dataList, weekStart);

      return <String, dynamic>{
        'farmersAssessedTotal': total > 0 ? total : dataList.length,
        'farmersAssessedThisWeek': thisWeek,
        'weekStartIso': weekStart,
        // export không trả aiModel => nơi dùng tự fallback nếu cần
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

      final utc = dt.toUtc();
      if (utc.isAfter(start) || utc.isAtSameMomentAs(start)) {
        count++;
      }
    }
    return count;
  }

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
