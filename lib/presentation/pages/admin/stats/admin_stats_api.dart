import 'dart:convert';
import 'package:app_mobile/domain/api_request_client/api_request_client.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:flutter/foundation.dart';

class ApiAdminStats {
  /// GET /api/admin/stats
  /// Response gợi ý:
  /// {
  ///   "data": {
  ///     "regionName": "Mekong",
  ///     "farmersAssessedTotal": 812,
  ///     "farmersAssessedThisWeek": 15,
  ///     "weekStartIso": "2025-12-22"
  ///   }
  /// }
  static Future<Map<String, dynamic>?> fetchStats() async {
    try {
      final url = ('${AppConfig.baseURL}/api/admin/stats');
      final response = await ApiRequestClient.get(url: url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map) {
          final map = decoded.map((k, v) => MapEntry(k.toString(), v));
          final data = map['data'];

          if (data is Map) {
            return data.map((k, v) => MapEntry(k.toString(), v));
          }

          return map.map((k, v) => MapEntry(k.toString(), v));
        }
      }

      return null;
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

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
