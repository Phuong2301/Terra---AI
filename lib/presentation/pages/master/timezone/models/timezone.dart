import 'package:app_mobile/application/app_other.dart';
import 'package:app_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:app_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:app_mobile/domain/models/other/timezone_model.dart';

class StoreTimeZone {
  StoreTimeZone._privateConstructor();
  static final StoreTimeZone instance = StoreTimeZone._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MTimeZone> {
  @override
  Future<MBaseNextPage<MTimeZone>?> getApiNextPage() async {
    final timezones = await AppOther.timezones();
    return MBaseNextPage(totalPage: 1, datas: timezones);
  }
}
