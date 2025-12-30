import 'package:app_mobile/application/providers/_user_provider.dart';
import 'package:app_mobile/domain/models/user/permission_model.dart';
import 'package:app_mobile/infrastructure/apis/api_auth.dart';
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';
import 'package:flutter/foundation.dart';

class AppAuth {
  static Future<bool> login(String userName, String password) async {
    try {
      final body = {'username': userName, 'password': password};
      final result = await ApiAuth.login(body);
      if (result == null) throw Exception('data login is null!');
      await SharedPreferencesProvider.instance
          .setAccessToken(result.accessToken);
      await SharedPreferencesProvider.instance.setUserInfo(result);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AppAuth login error $e');
      }
      return false;
    }
  }

  static Future<List<MPermission>> fetchPermissions() async {
    try {
      final results = await ApiAuth.fetchPermissions();
      return results.map((e) => MPermission.fromJson(e)).toList()
        ..add(MPermission(code: '', name: '', id: 0));
    } catch (e) {
      if (kDebugMode) {
        print('AppAuth fetchPermissions error $e');
      }
      return [];
    }
  }

  static Future<bool> logout() async {
    try {
      if (SharedPreferencesProvider.instance.accessToken.isEmpty) return true;
      ApiAuth.logout();
      SharedPreferencesProvider.instance.setAccessToken('');
      SharedPreferencesProvider.instance.setUserInfo(null);
      UserProvider.instance.permissions = null;
      UserProvider.instance.profile = null;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AppAuth logout error $e');
      }
      return false;
    }
  }
}
