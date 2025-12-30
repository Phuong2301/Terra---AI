import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

String prettyJsonStr(Map<dynamic, dynamic> json) {
  final encoder = JsonEncoder.withIndent('  ', (data) => data.toString());
  return encoder.convert(json);
}

class LoggerInterceptor {
  final Response response;
  final bool isDebug = true;
  LoggerInterceptor(this.response) {
    if (isDebug) onRequest();
  }

  void onRequest() {
    debugPrint(prettyJsonStr({
      'from': 'onRequest',
      'Time': DateTime.now().millisecondsSinceEpoch,
      'statusCode': response.statusCode,
      'baseUrl': response.request?.url,
      'method': response.request?.method,
      'headers': response.request?.headers,
      'params': response.request?.url.queryParameters,
      //'response_data': jsonDecode(response.body),
    }));
  }
}
