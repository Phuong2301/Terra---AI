// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

extension LocaleExtension on BuildContext {
  /// if [locale] is null, it takes the current locale of current context
  String getLocaleCurrency({Locale? locale}) {
    final currentLocale = locale ?? Localizations.localeOf(this);

    return NumberFormat.simpleCurrency(locale: currentLocale.countryCode)
        .currencySymbol;
  }
}
