import 'package:app_mobile/infrastructure/locals/shared_manager.dart';

class HeaderConfig {
  static String? get readToken =>
      SharedPreferencesProvider.instance.accessToken;

  static String? get readLocation =>
      SharedPreferencesProvider.instance.profile?.locationId.toString();

  static const String defaultAccept = '*/*';
  static const String defaultContentType = 'application/json; charset=UTF-8';
}

Map<String, String> commonHeader({String? contentType}) => {
  'Accept': HeaderConfig.defaultAccept,
  'Content-Type': contentType ?? HeaderConfig.defaultContentType,
};

Map<String, String> authHeader({String? contentType}) {
  final h = commonHeader(contentType: contentType);
  final token = HeaderConfig.readToken;
  if (token != null && token.isNotEmpty) {
    h['Authorization'] = 'Bearer $token';
  }
  final loc = HeaderConfig.readLocation;
  if (loc != null && loc.isNotEmpty) {
    h['Location'] = loc;
  }
  return h;
}