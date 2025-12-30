import 'package:api_network/src/group_middleware.dart';
import 'package:api_network/src/interceptor_logger.dart';
import 'package:api_network/src/middleware.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  static http.Response check(
    http.Response response, {
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) {
    LoggerInterceptor(response);
    if (middleware != null) {
      middleware.next(response);
    }
    if (groupMiddleWare != null) {
      groupMiddleWare.next(response);
    }
    return response;
  }
}
