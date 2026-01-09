import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/api_request_client/api_request_client.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:app_mobile/presentation/pages/demo/demo_mode_store.dart';
import 'package:app_mobile/presentation/pages/demo/demo_samples.dart';

class ApiAssessment {
  static Future<Map<String, dynamic>?> submit(Map<String, dynamic> body) async {
    try {
      final isDemo = await DemoModeStore.isEnabled();
      if (isDemo) {
        if (kDebugMode) {
          print('[DEMO MODE] Skip API submit, use local sample');
        }
        await Future.delayed(const Duration(milliseconds: 600));
        return DemoSamples.bestCaseAssessment();
      }

      final url = '${AppConfig.baseURL}/api/assessments';
      final res = await ApiRequestClient.post(
        url: url,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return decoded.cast<String, dynamic>();
      }

      if (kDebugMode) {
        print('ApiAssessment submit failed: ${res.statusCode} ${res.body}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('ApiAssessment submit error: $e');
      }
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAdminExport({String format = 'json'}) async {
    try {
      final isDemo = await DemoModeStore.isEnabled();
      if (isDemo) {
        if (kDebugMode) {
          print('[DEMO MODE] Skip API admin export, return local sample');
        }

        await Future.delayed(const Duration(milliseconds: 350));

        return {
          "ok": true,
          "totalAssessments": 0,
          "data": <dynamic>[],
          "meta": {
            "collection": "assessments",
            "format": format,
            "anonymized": true,
            "latencyMs": 0,
            "from": null,
            "to": null,
          }
        };
      }

      final url = '${AppConfig.baseURL}/api/admin/export?format=$format';

      final res = await ApiRequestClient.get(url: url);

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return decoded.cast<String, dynamic>();
      }

      if (kDebugMode) {
        print('ApiAssessment fetchAdminExport failed: ${res.statusCode} ${res.body}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('ApiAssessment fetchAdminExport error: $e');
      }
      return null;
    }
  }
}
