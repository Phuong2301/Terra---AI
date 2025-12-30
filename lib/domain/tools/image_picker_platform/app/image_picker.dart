import 'package:app_mobile/domain/tools/image_picker_platform/models/info_file_model.dart';
import 'package:image_picker/image_picker.dart' as img;

class ImagePickerPlatform {
  static Future<MInfoFile?> pickSingleFile() async {
    final info =
        await img.ImagePicker().pickImage(source: img.ImageSource.gallery);
    if (info == null) return null;
    return MInfoFile(fileName: info.name, data: await info.readAsBytes());
  }
}
