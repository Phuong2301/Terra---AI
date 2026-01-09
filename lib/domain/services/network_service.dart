import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  NetworkService._();

  static final _connectivity = Connectivity();

  static Future<bool> isOnline() async {
    final r = await _connectivity.checkConnectivity();
    return r != ConnectivityResult.none;
  }

  static Stream<bool> onlineStream() {
    return _connectivity.onConnectivityChanged.map((r) => r != ConnectivityResult.none);
  }
}
