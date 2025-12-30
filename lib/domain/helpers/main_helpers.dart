import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:intl/intl.dart';

bool isNumber(String text) {
  return RegExp('^[0-9]+\$').hasMatch(text);
}

String capitalize(String text) {
  return toBeginningOfSentenceCase(text) ?? text;
}

String checkImagePath(String path) {
  return path.contains('https://') ? path : "${AppConfig.rawBaseURL}/$path";
}

// Map<String, String> get commonHeader => {
//       "Accept": "*/*",
//       "Content-Type": "application/json; charset=UTF-8",
//       //"App-Language": app_language.$!,
//     };

// Map<String, String> get authHeader => {
//       "Authorization":
//           "Bearer ${SharedPreferencesProvider.instance.accessToken}",
//       "Location":
//           SharedPreferencesProvider.instance.profile?.locationId.toString() ??
//               '',
//     };

// Map<String, String> get currencyHeader =>
//     SystemConfig.systemCurrency?.code == null
//         ? {}
//         : {
//             "Currency-Code": SystemConfig.systemCurrency!.code!,
//             "Currency-Exchange-Rate":
//                 SystemConfig.systemCurrency!.exchangeRate.toString(),
//           };

// String convertPrice(String amount) {
//   return amount.replaceAll(
//       SystemConfig.systemCurrency!.code!, SystemConfig.systemCurrency!.symbol!);
// }
