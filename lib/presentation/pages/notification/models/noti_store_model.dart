// import 'package:app_mobile/application/other/app_notification.dart';
// import 'package:app_mobile/domain/fetch_data/fetching_next_page.dart';
// import 'package:app_mobile/domain/fetch_data/models/base_nextpage_model.dart';
// import 'package:app_mobile/domain/models/other/notification_model.dart';

// class StoreNotification {
//   StoreNotification._privateConstructor();
//   static final StoreNotification instance = StoreNotification._privateConstructor();

//   final FData data = FData();

//   clear() => data.clear();
// }

// class FData extends FetchingNextPage<MNotification> {
//   @override
//   Future<MBaseNextPage<MNotification>?> getApiNextPage() async {
//     return await AppNotification.fetch();
//   }
// }