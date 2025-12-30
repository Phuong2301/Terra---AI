import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:app_mobile/domain/helpers/extensions/extention_helper.dart';
import 'package:app_mobile/domain/models/other/version_model.dart';
import 'package:app_mobile/infrastructure/apis/other/api_version.dart';

class AppVersion {
  AppVersion._();
  static final AppVersion instance = AppVersion._();

  final String _local = AppConfig.version;

  VersionModel? remote;
  bool _prompted = false;

  bool get mustUpdate => (remote?.forceUpdate ?? 0) == 1;
  bool get hasUpdate => remote != null && isUpdate(_local, remote!.versionName);
  bool get shouldShowUpdate => mustUpdate || (hasUpdate && !_prompted);

  void markPrompted() {
    if (mustUpdate) return;
    _prompted = true;
  }

  Future<void> checkForUpdate() async {
    try {
      final res = await fetch();
      remote = res;
    } catch (e, s) {
      if (kDebugMode) {
        print('VersionService.checkForUpdate error: $e\n$s');
      }
      remote = null;
    }
  }

  bool isUpdate(String oldVersion, String newVersion) {
    final _old = oldVersion.replaceAll('.', '').stringToInt();
    final _new = newVersion.replaceAll('.', '').stringToInt();
    return _old != _new;
  }

  Future<VersionModel?> fetch() async {
    try {
      final res = await ApiVersion.fetch();
      return VersionModel.fromJson(res);
    } catch (e) {
      if (kDebugMode) print('AppVersion fetch error $e');
      return null;
    }
  }
}
