import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import '../../../domain/api_request_client/api_request_client.dart';

class ApiVersion {
  static Future<Map<String, dynamic>> fetch() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    try {
      String url = ('${AppConfig.baseURL}/master/app_version?platforms=$platform');
      final res = await ApiRequestClient.get(url: url);

      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final decoded = json.decode(res.body);
        final data = decoded['data'];
        return Map<String, dynamic>.from(data);
      }
      throw Exception('Load version error');
    } catch (e) {
      if (kDebugMode) print("ApiVersion fetch error: $e");
      return Map<String, dynamic>.from(_mockData(platform)['data'] as Map);
    }
  }
}

Map<String, dynamic> _mockData(String platform) =>
  {
    "data": {
        "id": 2,
        "version_name": AppConfig.version,
        "platforms": "android",
        "force_update": 0,
        "store_id": platform == 'ios' ? 'id00000001' : "id=com.terratech.rice.milling",
        "updated_at": 1761598780000
    }
};