import 'dart:io';
import 'dart:typed_data';
import 'package:api_network/src/api_response.dart';
import 'package:api_network/src/group_middleware.dart';
import 'package:api_network/src/interceptor_logger.dart';
import 'package:api_network/src/middleware.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiRequest {
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headerMap = {
      ...headers ?? {},
    };
    final response = await http.get(uri, headers: headerMap);
    return ApiResponse.check(
      response,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  static Future<http.Response> post({
    required String url,
    String? body = '',
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headerMap = {
      ...headers ?? {},
    };
    final response = await http.post(uri, headers: headerMap, body: body);
    return ApiResponse.check(
      response,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  static Future<http.Response> delete({
    required String url,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headerMap = {
      ...headers ?? {},
    };
    final response = await http.delete(uri, headers: headerMap);
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
    List<File>? files,
    List<String>? keyFiles,
    String keyFile = 'photo[]',
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {
      ...headers ?? {},
    };
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
              e.value.path,
              contentType: MediaType.parse(lookupMimeType(e.value.path) ?? ''),
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              keyFiles[e.key],
              e.value.path,
              contentType: MediaType.parse(lookupMimeType(e.value.path) ?? ''),
            ),
          );
        }
      });
    }
    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      LoggerInterceptor(response);
      return response.body;
    } catch (err) {
      return null;
    }
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
    Map<String, String> headerMap = {
      ...headers ?? {}
    };
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(body ?? {})
      ..headers.addAll(headerMap);
    request.files.addAll([
      http.MultipartFile.fromBytes(
        keyFile,
        fileData,
        filename: fileName,
        contentType: MediaType.parse(lookupMimeType(fileName) ?? ''),
      ),
    ]);

    try {
      final response = await request.send();
      final res = await response.stream.bytesToString();
      return res;
    } catch (err) {
      return null;
    }
  }
}
