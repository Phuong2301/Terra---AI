import 'dart:convert';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/api_request_client/api_request_client.dart';

class ApiOther {
  static Future<List<dynamic>> currencies() async {
    try {
      String url = ('${AppConfig.baseURL}/master/currencies');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther currencies error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> timezones() async {
    try {
      String url = ('${AppConfig.baseURL}/master/timezones');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther timezones error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> countries() async {
    try {
      String url = ('${AppConfig.baseURL}/master/countries');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther countries error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> provinces(int id) async {
    try {
      String url = ('${AppConfig.baseURL}/master/provinces?country_id=$id');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther provinces error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> districts(int id) async {
    try {
      String url = ('${AppConfig.baseURL}/master/districts?province_id=$id');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther districts error: $e");
      }
      return [];
    }
  }

  static Future<Map<String, dynamic>> preStage() async {
    try {
      String url = ('${AppConfig.baseURL}/master/pre_stages');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? {};
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther preStage error: $e");
      }
      return {};
    }
  }

  static Future<List<dynamic>> catalogues() async {
    try {
      String url = ('${AppConfig.baseURL}/master/dropdown');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther catalogues error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> fetchLots(String param) async {
    try {
      String url = ('${AppConfig.baseURL}/frk/dropdown?models=$param');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data']['models'][param] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther fetchLots error: $e");
      }
      return [];
    }
  }
}
