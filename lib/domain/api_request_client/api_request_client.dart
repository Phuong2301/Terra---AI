import 'dart:typed_data';

import 'package:api_network/api_network.dart';
import 'package:http/http.dart';
import 'package:app_mobile/domain/api_request_client/header.dart';
import 'package:app_mobile/domain/middlewares/check_auth.dart';

class ApiRequestClient {
  static final _checkAuth = CheckAuth();
  static Map<String, String>? get _authHeaer => authHeader();
  static final _commonHeader = {...commonHeader()};
  static Future<Response> post({
    required String url,
    String? body,
    bool needAuth = true
  }) {
    final _header = needAuth ? _authHeaer : _commonHeader;
    return ApiRequest.post(
      url: url, 
      body: body, 
      middleware: _checkAuth, 
      headers: _header
    );
  }
 
  static Future<Response> get({
    required String url,
    Map<String, String>? queryParam,
    bool needAuth = true
  }) {
    final _header = needAuth ? _authHeaer : _commonHeader;
    return ApiRequest.get(
      url: url, 
      queryParam: queryParam, 
      middleware: _checkAuth, 
      headers: _header
    );
  }

  static Future<String?> postSingleFile({
    required String url,
    required String keyFile,
    required String fileName,
    required Uint8List fileData,
    Map<String, String>? body,
  }) async {
    return ApiRequest.postSingleFile(
      url: url, 
      keyFile: keyFile, 
      fileName: fileName, 
      fileData: fileData,
      body: body,
      headers: _authHeaer,
      middleware: _checkAuth
    );
  }
}