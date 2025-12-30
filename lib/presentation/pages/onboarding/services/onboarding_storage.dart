import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { loanOfficer, farmer, fpoAdmin }

extension UserRoleX on UserRole {
  String get key => switch (this) {
        UserRole.loanOfficer => 'LOAN_OFFICER',
        UserRole.farmer => 'FARMER',
        UserRole.fpoAdmin => 'FPO_ADMIN',
      };

  static UserRole? fromKey(String? key) {
    switch (key) {
      case 'LOAN_OFFICER':
        return UserRole.loanOfficer;
      case 'FARMER':
        return UserRole.farmer;
      case 'FPO_ADMIN':
        return UserRole.fpoAdmin;
      default:
        return null;
    }
  }
}

class OnboardingStorage {
  static const completedKey = 'onboarding_completed';
  static const farmersCountKey = 'onboarding_farmers_count';
  static const farmersFetchedAtKey = 'onboarding_farmers_count_fetched_at';
  static const roleKey = 'onboarding_role';
  static const nameKey = 'onboarding_name';
  static const phoneKey = 'onboarding_phone';

  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  static Future<bool> isCompleted() async {
    final prefs = await _prefs;

    final legacy = prefs.getBool(completedKey) ?? false;
    if (legacy) return true;

    final role = prefs.getString(roleKey);
    final name = (prefs.getString(nameKey) ?? '').trim();

    return (role != null && role.isNotEmpty) && name.isNotEmpty;
  }

  static Future<void> setCompleted(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(completedKey, value);
  }


  static Future<void> setRole(UserRole role) async {
    final prefs = await _prefs;
    await prefs.setString(roleKey, role.key);

    await prefs.setBool(completedKey, false);
  }

  static Future<UserRole?> getRole() async {
    final prefs = await _prefs;
    return UserRoleX.fromKey(prefs.getString(roleKey));
  }

  static Future<void> setProfile({
    required String name,
    String? phone,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(nameKey, name.trim());
    await prefs.setString(phoneKey, (phone ?? '').trim());

    await prefs.setBool(completedKey, true);
  }

  static Future<String> getName() async {
    final prefs = await _prefs;
    return prefs.getString(nameKey) ?? '';
  }

  static Future<String> getPhone() async {
    final prefs = await _prefs;
    return prefs.getString(phoneKey) ?? '';
  }

  static Future<void> markDoneIfPossible() async {
    final prefs = await _prefs;
    final role = prefs.getString(roleKey);
    final name = (prefs.getString(nameKey) ?? '').trim();
    final done = (role != null && role.isNotEmpty) && name.isNotEmpty;
    await prefs.setBool(completedKey, done);
  }

  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(completedKey);

    await prefs.remove(roleKey);
    await prefs.remove(nameKey);
    await prefs.remove(phoneKey);
  }


  static Future<int> getFarmersCountCachedOrDefault({int fallback = 100}) async {
    final prefs = await _prefs;
    final v = prefs.getInt(farmersCountKey);
    return (v != null && v > 0) ? v : fallback;
  }

  static Future<int?> getLastFetchedAtMs() async {
    final prefs = await _prefs;
    return prefs.getInt(farmersFetchedAtKey);
  }

  static Future<void> setFarmersCount(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(farmersCountKey, value);
  }

  static Future<void> setFetchedNow() async {
    final prefs = await _prefs;
    await prefs.setInt(
      farmersFetchedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// TODO: thay bằng API/Remote Config thật để update hàng tuần.
  static Future<int?> fetchFarmersCountFromServer() async {
    return null;
  }
}
