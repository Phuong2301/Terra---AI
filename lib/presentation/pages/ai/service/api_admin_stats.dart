import 'dart:convert';
import 'package:app_mobile/presentation/pages/ai/model/ai_model_stats.dart';
import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/api_request_client/api_request_client.dart';
import 'package:app_mobile/domain/configs/app_config.dart';


class ApiAdminStats {
  static Future<AiModelStats?> fetchAiModelStats() async {
    try {
      final url = '${AppConfig.baseURL}/api/admin/stats';
      final res = await ApiRequestClient.get(url: url);

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final data = (decoded is Map && decoded['data'] is Map) ? decoded['data'] as Map : decoded;

        final ai = (data is Map && data['aiModel'] is Map)
            ? (data['aiModel'] as Map).map((k, v) => MapEntry(k.toString(), v))
            : null;

        if (ai == null) return null;
        return AiModelStats.fromJson(ai.cast<String, dynamic>());
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('ApiAdminStats fetchAiModelStats error: $e');
      }
      return null;
    }
  }
}
