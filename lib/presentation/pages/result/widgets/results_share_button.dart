import 'dart:typed_data';

import 'package:app_mobile/presentation/pages/result/widgets/share_image_service.dart';
import 'package:flutter/material.dart';

import '../risk_scoring.dart';
import '../services/pdf_export_service.dart';
import '../services/pdf_i18n.dart';
import '../widgets/pdf_loading_dialog.dart';

// FE-206 image share
import '../widgets/share_result_card.dart';
import '../../../../generated/l10n.dart' as l;

class ResultsShareButton extends StatefulWidget {
  const ResultsShareButton({
    super.key,
    required this.payload,
    required this.result,
  });

  final Map<String, dynamic> payload;
  final RiskScoreResult result;

  @override
  State<ResultsShareButton> createState() => _ResultsShareButtonState();
}

class _ResultsShareButtonState extends State<ResultsShareButton> {
  bool _busy = false;

  static const String _appDownloadUrl =
      'https://play.google.com/store/apps/details?id=YOUR_APP_ID'; // TODO: thay YOUR_APP_ID

  Future<void> _openShareSheet() async {
    if (_busy) return;
    final t = l.S.of(context);

    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        final ts = l.S.of(sheetCtx);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded),
                title: Text(ts.sharePdfReport),
                onTap: () => Navigator.pop(sheetCtx, 'pdf'),
              ),
              ListTile(
                leading: const Icon(Icons.image_rounded),
                title: Text(ts.shareImageSocial),
                onTap: () => Navigator.pop(sheetCtx, 'img'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || choice == null) return;

    if (choice == 'pdf') {
      await _sharePdf();
    } else if (choice == 'img') {
      await _shareImage();
    }
  }

  Future<bool?> _showSharePreview(Uint8List bytes) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false,
      builder: (sheetCtx) {
        final cs = Theme.of(sheetCtx).colorScheme;
        final t = l.S.of(sheetCtx);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.image_rounded),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.previewShareImageTitle,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                          tooltip: t.close,
                          onPressed: () => Navigator.pop(sheetCtx, false),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Preview image (1200x630 ~ social share)
                    AspectRatio(
                      aspectRatio: 1200 / 630,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: cs.surfaceContainerHighest.withOpacity(0.35),
                          child: InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            child: Image.memory(
                              bytes,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sheetCtx, false),
                            child: Text(t.close),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => Navigator.pop(sheetCtx, true),
                            icon: const Icon(Icons.ios_share_rounded),
                            label: Text(t.share),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _sharePdf() async {
    if (_busy) return;
    final t = l.S.of(context);
    final i18n = PdfI18n.fromS(t);

    setState(() => _busy = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PdfLoadingDialog(),
    );

    try {
      final safeName = (widget.payload['fullName'] ?? t.farmerDefaultName).toString().trim();
      final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileName = 'credit_report_${safeName.isEmpty ? t.farmerFileSafeName : safeName}_$ts.pdf';

      final bytes = await PdfExportService.buildPdfBytes(
        payload: widget.payload,
        result: widget.result,
        i18n: i18n,
      );

      if (!mounted) return;

      await Navigator.of(context, rootNavigator: true).maybePop();

      final file = await PdfExportService.saveToDevice(bytes: bytes, fileName: fileName);
      await PdfExportService.openFile(file);

      await PdfExportService.sharePdf(bytes: bytes, fileName: fileName);
    } catch (e) {
      if (!mounted) return;
      await Navigator.of(context, rootNavigator: true).maybePop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.exportPdfFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _shareImage() async {
    if (_busy) return;
    final t = l.S.of(context);

    setState(() => _busy = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PdfLoadingDialog(),
    );

    try {
      final bytes = await ShareImageService.captureToPngBytes(
        context: context,
        size: const Size(1200, 630),
        pixelRatio: 3,
        child: ShareResultCard(
          payload: widget.payload,
          result: widget.result,
          appDownloadUrl: _appDownloadUrl,
        ),
      );

      if (!mounted) return;

      await Navigator.of(context, rootNavigator: true).maybePop();

      final shouldShare = await _showSharePreview(bytes);
      if (shouldShare != true) return;

      final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
      await ShareImageService.sharePng(
        bytes: bytes,
        fileName: 'mekong_share_$ts.png',
        text: t.shareImageCaption,
      );
    } catch (e) {
      if (!mounted) return;
      await Navigator.of(context, rootNavigator: true).maybePop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.shareImageFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = l.S.of(context);

    return IconButton(
      tooltip: t.share,
      onPressed: _busy ? null : _openShareSheet,
      icon: _busy
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.ios_share_rounded),
    );
  }
}
