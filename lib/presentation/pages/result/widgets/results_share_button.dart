import 'package:app_mobile/presentation/pages/result/risk_scoring.dart';
import 'package:app_mobile/presentation/pages/result/services/pdf_export_service.dart';
import 'package:app_mobile/presentation/pages/result/widgets/pdf_loading_dialog.dart';
import 'package:flutter/material.dart';

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
  bool _exporting = false;

  Future<void> _share() async {
    if (_exporting) return;
    setState(() => _exporting = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PdfLoadingDialog(),
    );

    try {
      final safeName = (widget.payload['fullName'] ?? 'Farmer').toString().trim();
      final ts = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileName = 'credit_report_${safeName.isEmpty ? 'farmer' : safeName}_$ts.pdf';

      final bytes = await PdfExportService.buildPdfBytes(
        payload: widget.payload,
        result: widget.result,
      );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      await PdfExportService.sharePdf(bytes: bytes, fileName: fileName);

    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export PDF failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Share PDF',
      onPressed: _exporting ? null : _share,
      icon: _exporting
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.ios_share_rounded),
    );
  }
}
