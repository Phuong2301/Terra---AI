import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import '../../../domain/api_request_client/api_request_client.dart';

class ApiNotification {
  static Future<dynamic> fetchById(String id) async {
    try {
      String url = ('${AppConfig.baseURL}/notification/$id');
      final response = await ApiRequestClient.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("ApiNotification fetchFiles error: $e");
      }
      return null;
    }
  }

  static Future<List<dynamic>> fetch() async {
    try {
      String url = ('${AppConfig.baseURL}/notification');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiNotification fetchFiles error: $e");
      }
      return [];
    }
  }

  static Future<bool> registerNotification(String fcmToken) async {
    try {
      String url = ('${AppConfig.baseURL}/notification/register');
      final response = await ApiRequestClient.post(
          url: url, body: jsonEncode({'fcm_token': fcmToken}));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiNotification registerNotification error: $e");
      }
      return false;
    }
  }
}
