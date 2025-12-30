import 'package:app_mobile/domain/models/user/permission_model.dart';
import 'package:app_mobile/domain/models/user/profile_info.dart';

class UserProvider {
  UserProvider._privateConstructor();
  static final UserProvider instance = UserProvider._privateConstructor();

  MProfileInfo? profile;
  List<MPermission>? permissions;
  bool justLogin = false;
}
