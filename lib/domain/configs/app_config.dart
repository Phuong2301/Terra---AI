import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String appName = dotenv.get('APP_NAME', fallback: 'Rice Milling');
  //String.fromEnvironment("APP_NAME", defaultValue: 'Rice Milling');
  static String appIcon =
      dotenv.get('APP_ICON', fallback: 'assets/app_icons/app_icon_main.png');
  //String.fromEnvironment("APP_ICON", defaultValue: 'assets/app_icons/app_icon_main.png');
  static String organizationName =
      dotenv.get('ORGANIZTION_NAME', fallback: 'Rice Milling');
  //String.fromEnvironment("ORGANIZTION_NAME", defaultValue: 'Rice Milling');

  static String hostName =
      dotenv.get('HOST_NAME', fallback: 'http://milling-dev.terrahub.site'); //https://milling.terratech.vn/
  // String.fromEnvironment("HOST_NAME",
  // defaultValue: 'http://localhost:8080');
  static String apiEndPath = dotenv.get('API_END_PATH', fallback: '/api/v1');
  //String.fromEnvironment("API_END_PATH", defaultValue: "/api/v1");
  static String rawBaseURL = hostName;
  static String baseURL = rawBaseURL + apiEndPath;
  static String version = 
      dotenv.get('VERSION_NAME', fallback: '1.0.0');
}
