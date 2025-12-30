export 'image_picker_stub.dart'
    if (dart.library.html) 'web/image_picker.dart'
    if (dart.library.io) 'app/image_picker.dart';