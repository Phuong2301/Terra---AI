import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import '../../../domain/api_request_client/api_request_client.dart';

class ApiUpload {
  static Future<List<dynamic>> fetchFiles() async {
    try {
      String url = ('${AppConfig.baseURL}/upload');
      final response = await ApiRequestClient.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiUpload fetchFiles error: $e");
      }
      return [];
    }
  }

  static Future<String?> uploadFile(String fileName, dynamic fileData) async {
    try {
      String url = ('${AppConfig.baseURL}/upload');
      final response = await ApiRequestClient.postSingleFile(
          url: url,
          fileData: fileData,
          keyFile: 'file',
          fileName: fileName,);
      final body = jsonDecode(response ?? '{}') as Map<String, dynamic>;
      return body['data']['external_link'] as String;
    } catch (e) {
      if (kDebugMode) {
        print("ApiUpload uploadFile error: $e");
      }
      return null;
    }
  }
}
