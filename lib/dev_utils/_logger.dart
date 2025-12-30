// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

void devLogger(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = 'devLogger',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (kDebugMode) {
    return log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
