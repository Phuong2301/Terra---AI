import 'package:api_network/src/middleware.dart';
import 'package:http/http.dart' as http;

class GroupMiddleware {
  List<Middleware> middlewares = [];
  GroupMiddleware(this.middlewares);

  bool next(http.Response response) {
    for (Middleware middleware in middlewares) {
      if (!middleware.next(response)) {
        return false;
      }
    }
    return true;
  }
}
