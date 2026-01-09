import 'package:shared_preferences/shared_preferences.dart';

class DemoModeStore {
  DemoModeStore._();

  static const _kDemo = 'demo_mode_enabled_v1';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDemo) ?? false;
  }

  static Future<void> setEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDemo, v);
  }

  /// ✅ returns the NEW value after toggle
  static Future<bool> toggle() async {
    final v = await isEnabled();
    final next = !v;
    await setEnabled(next);
    return next;
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDemo);
  }
}
