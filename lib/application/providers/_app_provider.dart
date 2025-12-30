// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:app_mobile/application/other/app_notification.dart';
import 'package:app_mobile/domain/models/other/notification_model.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  void toggleTheme(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  List<MNotification>? notifications;
  Future<void> fetchNotifications() async {
    if (notifications != null) return;
    final res = await AppNotification.fetch();
    if (res == null) return;
    notifications = res.datas;
    notifyListeners();
  }
  Future<void> catchNotification(MNotification noti) async {
    notifications ??= [];
    notifications!.insert(0, noti);
    notifyListeners();
  }

  final locales = const <String, Locale>{
    //"Arabic": Locale('ar', 'SA'), // Arabic, Saudi Arabia
    //"Bengali": Locale('bn', 'BD'), // Bengali, Bangladesh
    "English": Locale('en', 'US'), // English, United States
    //"Hindi": Locale('hi', 'IN'), // Hindi, India
    //"Indonesian": Locale('id', 'ID'), // Indonesian, Indonesia
    //"Korean": Locale('ko', 'KR'), // Korean, South Korea (Republic of Korea)
    //"Portuguese": Locale('pt', 'BR'), // Portuguese, Brazil
    //"Swahili": Locale('sw', 'KE'), // Swahili, Kenya
    //"Thai": Locale('th', 'TH'), // Thai, Thailand
    //"Urdu": Locale('ur', 'PK'), // Urdu, Pakistan
    "VietNamese": Locale('vi', 'VN'), // VietNamese, Viet Nam
  };

  //Locale _currentLocale = const Locale("vi", "VN");
  Locale _currentLocale = const Locale('en', 'US');
  Locale get currentLocale => _currentLocale;
  bool isRTL = false;
  void changeLocale(Locale? value) {
    if (value == null) return;

    _currentLocale = value;
    notifyListeners();
  }
}
