import 'package:image_picker_web/image_picker_web.dart';
import 'package:app_mobile/domain/tools/image_picker_platform/models/info_file_model.dart';

class ImagePickerPlatform {
  static Future<MInfoFile?> pickSingleFile() async {
    final info = await ImagePickerWeb.getImageInfo();
    if(info == null) return null;
    return MInfoFile(fileName: info.fileName, data: info.data);
  }
}