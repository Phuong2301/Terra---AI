// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:app_mobile/application/other/app_notification.dart';
import 'package:app_mobile/domain/models/other/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  static const _kLocaleLangKey = 'app_locale_lang';
  static const _kLocaleCountryKey = 'app_locale_country';

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
    "English": Locale('en', 'US'),
    "VietNamese": Locale('vi', 'VN'),
  };

  Locale _currentLocale = const Locale('en', 'US');
  Locale get currentLocale => _currentLocale;

  bool isRTL = false;

  AppProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_kLocaleLangKey);
    final country = prefs.getString(_kLocaleCountryKey);

    if (lang == null || lang.isEmpty) return;

    _currentLocale = Locale(lang, (country?.isEmpty ?? true) ? null : country);
    isRTL = _isRtlLocale(_currentLocale);

    notifyListeners();
  }

  Future<void> changeLocale(Locale? value) async {
    if (value == null) return;

    _currentLocale = value;
    isRTL = _isRtlLocale(value);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleLangKey, value.languageCode);
    await prefs.setString(_kLocaleCountryKey, value.countryCode ?? '');
  }

  Future<void> toggleLocale() async {
    final isVi = _currentLocale.languageCode == 'vi';
    await changeLocale(isVi ? const Locale('en', 'US') : const Locale('vi', 'VN'));
  }

  bool _isRtlLocale(Locale locale) {
    const rtlLangs = {'ar', 'fa', 'he', 'ur'};
    return rtlLangs.contains(locale.languageCode.toLowerCase());
  }
}
