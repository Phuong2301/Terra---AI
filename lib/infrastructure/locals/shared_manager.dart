import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_mobile/domain/models/user/profile_info.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:upstream/domain/l10n/model/app_language.dart';
//import 'package:upstream/infrastructure/store_data/data_orther_info.dart';
//import 'package:upstream/infrastructure/store_data/user_info.dart';
//import 'package:upstream/models/farmer_local/farmer_local_model.dart';
//import 'package:upstream/models/user/user_model.dart';

enum SharedKey {
  accessToken,
  sellerToken,
  userName,
  userInfo,
  applang,
  appRoute,
}

enum EAppLang {
  en,
  vi,
  th,
  tl,
}

enum EAppMode {
  dev,
  pro,
}

class SharedPreferencesProvider {
  SharedPreferencesProvider._privateConstructor();
  static final SharedPreferencesProvider instance =
      SharedPreferencesProvider._privateConstructor();

  late SharedPreferences _shared;
  late String accessToken;
  late String sellerToken;
  late String appLang;
  late String appRoute;
  bool isEnvPro = true;
  bool isInstance = false;
  MProfileInfo? profile;
  //late MAppLang localLang;

  Future init() async {
    _shared = await SharedPreferences.getInstance();
    await dotenv.load(fileName: ".env");
    isInstance = true;
    _fetchProfileInfo();
    accessToken = _getString(SharedKey.accessToken.name) ?? '';
    sellerToken = _getString(SharedKey.sellerToken.name) ?? '';
    appLang = _getString(SharedKey.applang.name) ?? EAppLang.en.name;
    appRoute = _getString(SharedKey.appRoute.name) ?? '/';
    //localLang = await DOrtherInfo.instance.setAppLang(appLang);
    // devLogger("Access_token => $accessToken");
    //debugPrint("UserInfo ${userInfo?.toJson}");
  }

  setAppLang(String value) async {
    appLang = value;
    _setString(SharedKey.applang.name, value);
  }

  setAppRoute(String value) async {
    if (!isInstance) {
      _shared = await SharedPreferences.getInstance();
    }
    appRoute = value;
    _setString(SharedKey.appRoute.name, value);
  }

  setAccessToken(String value) {
    accessToken = value;
    _setString(SharedKey.accessToken.name, value);
  }

  setSellerToken(String value) {
    sellerToken = value;
    _setString(SharedKey.sellerToken.name, value);
  }

  setUserInfo(MProfileInfo? value) {
    profile = value;
    _setString(SharedKey.userInfo.name,
        jsonEncode(value == null ? {} : value.toMapLocal()));
  }

  _fetchProfileInfo() {
    try {
      final userInfoString = _getString(SharedKey.userInfo.name);
      if (userInfoString == null) return;
      profile = MProfileInfo.fromJson(jsonDecode(userInfoString));
    } catch (e) {
      debugPrint('error fetchUserInfo: $e');
    }
  }

  // _fetchFarmerLocal() {
  //   try {
  //     if (userInfo == null) return;
  //     final farmers = _getList(userInfo!.id.toString());
  //     if (farmers.isEmpty) return;
  //     for (var element in farmers) {
  //       farmerLocal.add(MFarmerLocal.fromJson(element));
  //     }
  //   } catch (e) {
  //     debugPrint('error fetchFarmerLocal: $e');
  //   }
  // }

  // _isFarmerExist(int idFarmer) {
  //   return farmerLocal
  //       .where((element) => element.id == idFarmer)
  //       .toList()
  //       .isNotEmpty;
  // }

  // _saveToLocal() {
  //   final datas = farmerLocal.map((e) => e.toJson()).toList();
  //   _setList(userInfo!.id.toString(), datas);
  // }

  // saveFarmerDataToLocal(MFarmerLocal mFarmerLocal) {
  //   try {
  //     if (_isFarmerExist(mFarmerLocal.id)) {
  //       farmerLocal.removeWhere((element) => element.id == mFarmerLocal.id);
  //     }
  //     farmerLocal.insert(0, mFarmerLocal);
  //     _saveToLocal();
  //   } catch (e) {
  //     debugPrint("error saveFarmerDataToLocal: $e");
  //   }
  // }

  // deleteFarmerDataToLocal(int farmerId) {
  //   try {
  //     if (!_isFarmerExist(farmerId)) return;
  //     farmerLocal.removeWhere((element) => element.id == farmerId);
  //     _saveToLocal();
  //   } catch (e) {
  //     debugPrint("error deleteFarmerDataToLocal: $e");
  //   }
  // }

  _setString(String key, String value) {
    _shared.setString(key, value);
  }

  String? _getString(String key) {
    return _shared.getString(key);
  }

  // _setList(String key, List<String> values) {
  //   _shared.setStringList(key, values);
  // }

  // List<String> _getList(String key) {
  //   return _shared.getStringList(key) ?? [];
  // }

  clearKey(String key) {
    _shared.remove(key);
  }

  clearToken(){
    clearKey(SharedKey.accessToken.name);
    accessToken = '';
  }

  clear() {
    //userInfo = null;
    setAccessToken('');
    //DUserInfo.instance.user = null;
    clearKey(SharedKey.sellerToken.name);
    clearKey(SharedKey.userInfo.name);
    clearKey(SharedKey.userName.name);
  }

  switchMode() {
    setAccessToken('');
    clearKey(SharedKey.sellerToken.name);
    clearKey(SharedKey.userInfo.name);
    clearKey(SharedKey.userName.name);
  }
}

class DataConstant {
  static double lat = 0;
  static double lng = 0;
}
