import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:app_mobile/domain/models/other/notification_model.dart';
import 'package:app_mobile/infrastructure/apis/other/api_notification.dart';

class AppNotification {
  static Future<MNotification?> fetchById(String id) async {
    try {
      final res = await ApiNotification.fetchById(id);
      if (res == null) return null;
      return MNotification.fromJson(res);
    } catch (e) {
      if (kDebugMode) {
        print('AppNotification fetchById error $e');
      }
      return null;
    }
  }

  static Future<MBaseNextPage<MNotification>?> fetch({int? status}) async {
    try {
      final res = await ApiNotification.fetch();
      final datas = res.map((e) => MNotification.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppNotification fetch error $e');
      }
      return null;
    }
  }

    static Future<bool> registerNotification(String fcmToken) async {
    try {
      final res = await ApiNotification.registerNotification(fcmToken);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppNotification registerNotification error $e');
      }
      return false;
    }
  }
}
