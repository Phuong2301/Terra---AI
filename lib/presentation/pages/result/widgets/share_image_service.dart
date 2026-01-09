import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareImageService {
  ShareImageService._();

  static Future<Uint8List> captureToPngBytes({
    required BuildContext context,
    required Widget child,
    Size size = const Size(1200, 630),
    double pixelRatio = 3,
  }) async {
    final key = GlobalKey();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: -99999,
          top: -99999,
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
                child: RepaintBoundary(
                  key: key,
                  child: SizedBox(width: size.width, height: size.height, child: child),
                ),
              ),
            ),
          ),
        );
      },
    );

    final overlay = Overlay.of(context, rootOverlay: true);
    overlay.insert(entry);

    await Future<void>.delayed(const Duration(milliseconds: 30));
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 30));

    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    entry.remove();

    if (byteData == null) {
      throw Exception('Failed to encode image');
    }
    return byteData.buffer.asUint8List();
  }

  static Future<void> sharePng({
    required Uint8List bytes,
    required String fileName,
    String? text,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles([XFile(file.path)], text: text ?? '');
  }
}
