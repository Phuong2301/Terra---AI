import 'package:app_mobile/domain/models/other/catalogue_model.dart';
import 'package:app_mobile/domain/models/other/country_model.dart';
import 'package:app_mobile/domain/models/other/currency_model.dart';
import 'package:app_mobile/domain/models/other/district_model.dart';
import 'package:app_mobile/domain/models/other/pre_stage_model.dart';
import 'package:app_mobile/domain/models/other/province_model.dart';
import 'package:app_mobile/domain/models/other/timezone_model.dart';
import 'package:app_mobile/infrastructure/apis/other/api_other.dart';
import 'package:app_mobile/infrastructure/storages/store_other.dart';
import 'package:flutter/foundation.dart';

class AppOther {
  AppOther._();
  static final AppOther instance = AppOther._();
  static List<MCatalogue> _catalogues = [];
  static Future<List<MCurrency>> currencies() async {
    try {
      if (StoreOther.instance.currencies != null) {
        return StoreOther.instance.currencies!;
      }
      final datas = await ApiOther.currencies();
      final currencies = datas.map((e) => MCurrency.fromJson(e)).toList();
      StoreOther.instance.currencies = currencies;
      return currencies;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther currencies error $e');
      }
      return [];
    }
  }

  static Future<List<MTimeZone>> timezones() async {
    try {
      if (StoreOther.instance.timezones != null) {
        return StoreOther.instance.timezones!;
      }
      final datas = await ApiOther.timezones();
      final timezones = datas.map((e) => MTimeZone.fromJson(e)).toList();
      StoreOther.instance.timezones = timezones;
      return timezones;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther timezones error $e');
      }
      return [];
    }
  }

  static Future<List<MCountry>> countries() async {
    try {
      if (StoreOther.instance.coutries != null) {
        return StoreOther.instance.coutries!;
      }
      final res = await ApiOther.countries();
      final datas = res.map((e) => MCountry.fromJson(e)).toList();
      StoreOther.instance.coutries = datas;
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther countries error $e');
      }
      return [];
    }
  }

  static Future<List<MProvince>> provinces(int countryId) async {
    try {
      final res = await ApiOther.provinces(countryId);
      final datas = res.map((e) => MProvince.fromJson(e)).toList();
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther provinces error $e');
      }
      return [];
    }
  }

  static Future<List<MDistrict>> districts(int provinceId) async {
    try {
      final res = await ApiOther.districts(provinceId);
      final datas = res.map((e) => MDistrict.fromJson(e)).toList();
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther districts error $e');
      }
      return [];
    }
  }

  static Future<MPreStage?> preStage() async {
    try {
      final res = await ApiOther.preStage();
      final datas = MPreStage.fromMap(res);
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther preStage error $e');
      }
      return MPreStage.fromMap({});
    }
  }

  static Future<List<MCatalogue>> catalogues() async {
    try {
      if(_catalogues.isNotEmpty) return _catalogues;
      final res = await ApiOther.catalogues();
      final datas = res
          .map((e) => MCatalogue.fromMap(e as Map<String, dynamic>))
          .toList();
      _catalogues = datas;
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther catalogues error $e');
      }
      return [];
    }
  }

  static Future<List<MDropdown>> fetchLots(String param) async {
    try {
      final res = await ApiOther.fetchLots(param);
      final datas =
          res.map((e) => MDropdown.fromMap(e as Map<String, dynamic>)).toList();
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppOther fetchLots error $e');
      }
      return [];
    }
  }
}
