// 🐦 Flutter imports:
import 'package:flutter/material.dart';

abstract class AppDateConfig {
  static final appFirstDate = DateTime(2000);
  static final appLastDate = DateTime(2077);

  static const appNumberOnlyDateFormat = 'dd/MM/yyyy';
  static const appNumberOnlyDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const appMonthNameDateFormat = 'dd MMM yyyy';
  static const appNumberDateFormatToFilter = 'yyyy-MM-dd';
  static const appNumberDateTimeFormatToFilter = 'yyyy-MM-dd HH:mm';
}

class AppLocale {
  AppLocale._();
  static AppLocale? _instance = AppLocale._();
  factory AppLocale() => _instance ??= AppLocale._();
  void dispose() {
    _instance = null;
  }

  static String _currency = '\$';
  static String get appCurrency => _currency;
  static set currency(String value) => _currency = value;

  static Locale _defaultLocale = const Locale('en_US');
  static Locale get defaultLocale => _defaultLocale;
  static set appLocale(Locale value) => _defaultLocale = value;
}
