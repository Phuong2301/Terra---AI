import 'package:api_network/api_network.dart';
import 'package:http/http.dart';
import 'package:app_mobile/presentation/widgets/overlay/session_expired_overlay.dart';

class CheckAuth extends Middleware {
  @override
  bool next(Response response) {
    if (response.statusCode == 401) {
      SessionExpiredOverlay.show();
      return false;
    }
    return true;
  }
}