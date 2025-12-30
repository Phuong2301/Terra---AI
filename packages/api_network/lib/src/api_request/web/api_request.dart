import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../api_response.dart';
import '../../group_middleware.dart';
import '../../middleware.dart';

class HttpRequestBase extends http.BaseRequest {
  HttpRequestBase(super.method, super.url);
}

class ApiRequest {
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {...headers ?? {}};
    final res = await html.HttpRequest.request(
      url,
      sendData: queryParam,
      method: 'GET',
      requestHeaders: headerMap,
    );
    final response = http.Response(
      res.responseText ?? '{"message": "data not found!"}',
      res.status ?? 404,
      headers: headerMap,
      request: HttpRequestBase('GET', Uri.parse(url)),
    );
    return ApiResponse.check(
      response,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  static Future<http.Response> post({
    required String url,
    String body = '',
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {...headers ?? {}};
    final res = await html.HttpRequest.request(
      url,
      sendData: body,
      method: 'POST',
      requestHeaders: headerMap,
    );
    final response = http.Response(
      res.responseText ?? '{"message": "data not found!"}',
      res.status ?? 404,
      headers: headerMap,
      request: HttpRequestBase('POST', Uri.parse(url)),
    );
    return ApiResponse.check(
      response,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  static Future<http.Response> delete({
    required String url,
    String body = '',
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {...headers ?? {}};
    final res = await html.HttpRequest.request(
      url,
      method: 'DELETE',
      sendData: body,
      requestHeaders: headerMap,
    );
    final response = http.Response(
      res.responseText ?? '{"message": "data not found!"}',
      res.status ?? 404,
      headers: headerMap,
      request: HttpRequestBase('DELETE', Uri.parse(url)),
    );
    return ApiResponse.check(
      response,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  static Future<String?> postFormData({
    required String url,
    Map<String, String>? headers,
    required Map<String, String> body,
    List<html.File>? files,
    List<String>? keyFiles,
    String keyFile = 'photo[]',
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {...headers ?? {}};
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(body)
      ..headers.addAll(headerMap);
    if (files != null) {
      files.asMap().entries.forEach((e) async {
        if (keyFiles == null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              keyFile,
              e.value.name,
              contentType: MediaType.parse(lookupMimeType(e.value.name) ?? ''),
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              keyFiles[e.key],
              e.value.name,
              contentType: MediaType.parse(lookupMimeType(e.value.name) ?? ''),
            ),
          );
        }
      });
    }
    try {
      final response = await request.send();
      final res = await response.stream.bytesToString();
      return res;
    } catch (err) {
      return null;
    }
  }

  static Future<String?> postSingleFile({
    required String url,
    required Map<String, String> body,
    required html.File? fileData,
    required String keyFile,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {...headers ?? {}};
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(body)
      ..headers.addAll(headerMap);
    if (fileData != null) {
      request.files.addAll([
        await http.MultipartFile.fromPath(
          keyFile,
          fileData.name,
          contentType: MediaType.parse(lookupMimeType(fileData.name) ?? ''),
        ),
      ]);
    }

    try {
      final response = await request.send();
      final res = await response.stream.bytesToString();
      return res;
    } catch (err) {
      return null;
    }
  }
}
