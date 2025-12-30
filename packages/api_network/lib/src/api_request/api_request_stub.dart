import 'package:api_network/src/group_middleware.dart';
import 'package:api_network/src/middleware.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ApiRequest {
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }

  static Future<http.Response> post({
    required String url,
    String? body,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }

  static Future<http.Response> delete({
    required String url,
    String? body,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }

  static Future<String?> postSingleFile({
    required String url,
    required String keyFile,
    required String fileName,
    required Uint8List fileData,
    Map<String, String>? body,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }
}
