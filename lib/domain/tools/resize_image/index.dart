import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_watermark/image_watermark.dart';

const defaultSize = 1024;
const quality = 85;

class ResizeImagePlatform {
  static Future<Uint8List?> resize(Uint8List? bytes) async {
    if (bytes == null) return null;
    final res = await compute(_compressAndResizeImage, bytes);
    return res;
  }

  static Future<Uint8List?> _compressAndResizeImage(Uint8List bytes) async {
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return null;

    img.Image resizedImage;
    Uint8List qualityImage;

    int width = defaultSize;
    int height = defaultSize;

    if (image.width > defaultSize && image.height > defaultSize) {
      if (image.width > image.height) {
        height = (image.height / image.width * defaultSize).round();
      } else {
        width = (image.width / image.height * defaultSize).round();
      }
      resizedImage = img.copyResize(image, width: width, height: height);
      qualityImage = img.encodeJpg(resizedImage, quality: 85);
    } else {
      width = image.width;
      height = image.height;
      resizedImage = image;
      qualityImage = img.encodeJpg(resizedImage);
    }
    return qualityImage;
  }

  static Future<Uint8List> waterMarkLogo(
      Uint8List imgBytes, int width, int height) async {
    final file = await rootBundle.load('assets/images/logo/logo.png');
    final imgLogo = file.buffer.asUint8List();
    return ImageWatermark.addImageWatermark(
      originalImageBytes: imgBytes, //image bytes
      waterkmarkImageBytes: imgLogo, //watermark img bytes
      imgWidth: 200, //watermark img width
      imgHeight: 66, //watermark img height
      dstX: width - 210, //watermark position X
      dstY: height - 76, //watermark position Y
    );
  }
}
