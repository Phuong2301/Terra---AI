import 'dart:convert';
import 'package:app_mobile/domain/api_request_client/api_request_client.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:app_mobile/domain/models/user/profile_info.dart';
import 'package:flutter/foundation.dart';

class ApiAuth {
  static Future<MProfileInfo?> login(Map<String, dynamic> body) async {
    try {
      String url = ('${AppConfig.baseURL}/auth/login');
      final response = await ApiRequestClient.post(url: url, body: json.encode(body), needAuth: false);
      if (response.statusCode == 200) {
        return MProfileInfo.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("ApiAuth login error: $e");
      }
      return null;
    }
  }

  static Future<List<dynamic>> fetchPermissions() async {
    try {
      String url = ('${AppConfig.baseURL}/permissions');
      final response = await ApiRequestClient.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiAuth fetchPermissions error: $e");
      }
      return [];
    }
  }

  static Future<bool> logout() async {
    try {
      String url = ('${AppConfig.baseURL}/auth/logout');
      final response = await ApiRequestClient.post(url: url,);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiAuth logout error: $e");
      }
      return false;
    }
  }
}
