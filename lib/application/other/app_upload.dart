import 'package:flutter/foundation.dart';
import 'package:app_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:app_mobile/infrastructure/apis/other/api_upload.dart';
import 'package:app_mobile/presentation/pages/gallery/models/gallery_model.dart';

class AppUpload {
  static Future<MBaseNextPage<MGalleryItem>?> fetch() async {
    try {
      final res = await ApiUpload.fetchFiles();
      final datas = res.map((e) => MGalleryItem.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppUpload fetch error $e');
      }
      return null;
    }
  }

  static Future<String?> uploadFile(String fileName, dynamic fileData) async {
    final res = await ApiUpload.uploadFile(fileName, fileData);
    return res;
  }
}
