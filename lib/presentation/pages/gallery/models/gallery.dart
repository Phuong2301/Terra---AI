import 'package:app_mobile/application/other/app_upload.dart';
import 'package:app_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:app_mobile/domain/fetch_data/models/base_nextpage_model.dart';

import 'gallery_model.dart';

class StoreGallery {
  StoreGallery._privateConstructor();
  static final StoreGallery instance = StoreGallery._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MGalleryItem> {
  @override
  Future<MBaseNextPage<MGalleryItem>?> getApiNextPage() async {
    return await AppUpload.fetch();
  }
}