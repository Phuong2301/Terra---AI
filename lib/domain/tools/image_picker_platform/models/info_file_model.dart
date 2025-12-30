import 'dart:typed_data';

class MInfoFile {
  final String? fileName;
  Uint8List? data;

  MInfoFile({required this.fileName, this.data});
}
