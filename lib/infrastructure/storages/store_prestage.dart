import 'package:app_mobile/application/app_other.dart';
import 'package:app_mobile/domain/models/other/pre_stage_model.dart';

class StoragePreStage {
  StoragePreStage._privateConstructor();
  static final StoragePreStage instance = StoragePreStage._privateConstructor();

  MPreStage? _preStage;

  _initFetch() async {
    if (_preStage != null) return;
    final res = await AppOther.preStage();
    _preStage = res;
  }

  Future<MPreStage> preStage() async {
    await _initFetch();
    return _preStage!;
  }
}
