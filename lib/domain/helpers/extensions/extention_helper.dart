import 'package:app_mobile/domain/core/static/_static_values.dart';
import 'package:intl/intl.dart';

extension StringToDateTime on String {
  DateTime get convertToDate =>
      DateFormat(AppDateConfig.appNumberOnlyDateFormat).parse(this);
  DateTime get convertDateToFilter =>
      DateFormat(AppDateConfig.appNumberDateFormatToFilter).parse(this);
  DateTime get convertDateTimeToFilter =>
      DateFormat(AppDateConfig.appNumberDateTimeFormatToFilter).parse(this);

  DateTime get convertToDateTime =>
      DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat).parse(this);
}

extension DateTimeToInt on DateTime {
  int get convertToInt => millisecondsSinceEpoch;
}

extension DateTimeToString on DateTime {
  String get convertDateToString =>
      DateFormat(AppDateConfig.appNumberOnlyDateFormat).format(this);
  String get convertDateToStringFilter =>
      DateFormat(AppDateConfig.appNumberDateFormatToFilter).format(this);
  String get convertDateTimeToStringFilter =>
      DateFormat(AppDateConfig.appNumberDateTimeFormatToFilter).format(this);

  String get convertDateTimeToString =>
      DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat).format(this);
}

extension IntToDateTime on int {
  DateTime get convertToDate => DateTime.fromMillisecondsSinceEpoch(this);
}

extension ExtentionInt on int {
  DateTime get intToDateTime => DateTime.fromMillisecondsSinceEpoch(this);
}

extension ExtentionNum on num {
  DateTime get numToDateTime => DateTime.fromMillisecondsSinceEpoch(toInt());
}

extension ExtentionString on String? {
  /// convert string to DateTime, check is number then convert to datatime
  int get stringToTimeStamp {
    try {
      if (this == null) return DateTime.now().millisecondsSinceEpoch;
      if (!isValidNumber) return DateTime.now().millisecondsSinceEpoch;
      return stringToInt();
    } catch (e) {
      // If parsing fails, return current time
      return DateTime.now().millisecondsSinceEpoch;
    }
  }

  DateTime get stringToDate =>
      DateFormat(AppDateConfig.appNumberOnlyDateFormat).parse(this!);

  DateTime get stringToDateTime =>
      DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat).parse(this!);

  /// validate if a string is a valid number
  bool get isValidNumber {
    final numValue = num.tryParse(this ?? '0');
    return numValue != null && numValue >= 0;
  }

  ///validate if a string is a valid datatime
  bool get isValidDateTime {
    try {
      DateTime.parse(this ?? '');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// convert string to num, return 0 if conversion fails
  num get stringToNum {
    final numValue = num.tryParse(this ?? '0');
    return numValue ?? 0;
  }

  /// convert string to int, return 0 if conversion fails
  int stringToInt({int defaultValue = 0}) {
    final intValue = int.tryParse(this ?? '$defaultValue');
    return intValue ?? defaultValue;
  }

  /// convert string to List, return [] if conversion fails
  List<String> toList({String separator = ','}) {
    if (this == null || this!.isEmpty) return [];
    return this!.split(separator).map((e) => e.trim()).toList();
  }
}

extension ListExtension<T> on List<T> {
  List<T> addBetween(T separator) {
    if (length <= 1) return toList();

    final _newItems = <T>[];
    for (int i = 0; i < length - 1; i++) {
      _newItems.add(this[i]);
      _newItems.add(separator);
    }
    _newItems.add(this[length - 1]);

    return _newItems;
  }
}

extension IterableExtension<T> on List<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    final idSet = <Object>{};
    final distinct = <T>[];
    for (final d in this) {
      if (idSet.add(getCompareValue(d))) {
        distinct.add(d);
      }
    }
    return distinct;
  }

  String? indexWhereOrNull(bool Function(T e) getCompareValue) {
    for (final d in this) {
      if (getCompareValue(d)) return indexOf(d).toString();
    }
    return null;
  }
}