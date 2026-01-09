import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../risk_scoring.dart';
import 'pdf_i18n.dart';

class PdfExportService {
  PdfExportService._();

  static const String _logoAssetPath = 'assets/branding/logo.png';

  static PdfColor _scoreColor(int score) {
    if (score >= 75) return const PdfColor.fromInt(0xFF16A34A); // green
    if (score >= 50) return const PdfColor.fromInt(0xFFF59E0B); // yellow
    return const PdfColor.fromInt(0xFFDC2626); // red
  }
  static Future<pw.Font> _loadPdfFont(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return pw.Font.ttf(data);
  }

  static PdfColor _tint(PdfColor c, {double strength = 0.12}) {
    final s = strength.clamp(0.0, 1.0);
    return PdfColor(
      1 - (1 - c.red) * s,
      1 - (1 - c.green) * s,
      1 - (1 - c.blue) * s,
    );
  }

  static Future<Uint8List?> _loadLogoBytes() async {
    try {
      final data = await rootBundle.load(_logoAssetPath);
      return data.buffer.asUint8List();
    } catch (_) {
      return null; // logo optional
    }
  }

  static Future<Uint8List> buildPdfBytes({
    required Map<String, dynamic> payload,
    required RiskScoreResult result,
    required PdfI18n i18n,
  }) async {
    final logoBytes = await _loadLogoBytes();
    final logo = logoBytes != null ? pw.MemoryImage(logoBytes) : null;

    // ---- Extract data ----
    final name = (payload['fullName'] ?? '').toString().trim();
    final phone = (payload['phone'] ?? '').toString().trim();
    final address = (payload['address'] ?? '').toString().trim();
    final province = (payload['province'] ?? '').toString().trim();
    final district = (payload['district'] ?? '').toString().trim();
    final crop = (payload['mainCrop'] ?? '').toString().trim();
    final farmSizeHa = payload['farmSizeHa'];

    final createdAt =
        DateTime.tryParse((payload['createdAt'] ?? '').toString()) ?? DateTime.now();
    final createdText =
        '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} '
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

    final score = result.finalScore;
    final scoreColor = _scoreColor(score);

    final regular = await _loadPdfFont('fonts/Inter/Inter-Regular.ttf');
    final bold = await _loadPdfFont('fonts/Inter/Inter-Bold.ttf');
    final medium = await _loadPdfFont('fonts/Inter/Inter-Medium.ttf'); // optional

    final theme = pw.ThemeData.withFont(
      base: regular,
      bold: bold,
    );

    final doc = pw.Document(theme: theme);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 30, 28, 30),
        build: (context) => [
          _header(logo: logo, createdText: createdText, i18n: i18n),
          pw.SizedBox(height: 18),

          pw.Text(
            i18n.reportTitle,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            i18n.reportSubtitle,
            style: pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
          ),

          pw.SizedBox(height: 18),

          _sectionTitle(i18n.farmerInformation),
          _kvGrid([
            _kv(i18n.name, name.isEmpty ? '—' : name),
            _kv(i18n.phone, phone.isEmpty ? '—' : phone),
            _kv(i18n.address, address.isEmpty ? '—' : address),
            _kv(i18n.provinceDistrict, _join(province, district)),
            _kv(i18n.mainCrop, crop.isEmpty ? '—' : crop),
            _kv(i18n.farmSizeHa, farmSizeHa == null ? '—' : farmSizeHa.toString()),
          ]),

          pw.SizedBox(height: 14),

          _sectionTitle(i18n.riskScore),
          _scoreBlock(
            score: score,
            category: result.category, // should already be localized by engine
            recommendation: result.recommendation, // should already be localized by engine
            color: scoreColor,
            base: result.baseScore,
            aiAdj: result.aiAdjustment,
            fpoBoost: result.fpoBoost,
            i18n: i18n,
          ),

          pw.SizedBox(height: 14),

          _sectionTitle(i18n.recommendedLoanTerms),
          _termsTable(result.termsWith, i18n: i18n),

          pw.SizedBox(height: 14),

          _sectionTitle(i18n.aiReasoning),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(10),
              color: PdfColors.grey50,
            ),
            child: pw.Text(
              result.reasoning, // should already be localized by engine
              style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800, lineSpacing: 4),
            ),
          ),

          pw.SizedBox(height: 18),
          _footer(i18n: i18n),
        ],
      ),
    );

    return doc.save();
  }

  static Future<File> saveToDevice({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Share native sheet (Android/iOS)
  static Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
    String? text,
  }) async {
    // Share bytes directly (printing)
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  static Future<void> openFile(File file) async {
    await OpenFilex.open(file.path);
  }

  static pw.Widget _header({
    pw.ImageProvider? logo,
    required String createdText,
    required PdfI18n i18n,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 1)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (logo != null)
            pw.Container(
              width: 34,
              height: 34,
              margin: const pw.EdgeInsets.only(right: 10),
              child: pw.Image(logo, fit: pw.BoxFit.contain),
            ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  i18n.brandName,
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${i18n.generatedAt}: $createdText',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _kvGrid(List<pw.Widget> items) {
    // 2 columns
    final rows = <pw.Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        pw.Row(
          children: [
            pw.Expanded(child: items[i]),
            pw.SizedBox(width: 12),
            pw.Expanded(child: i + 1 < items.length ? items[i + 1] : pw.SizedBox()),
          ],
        ),
      );
      rows.add(pw.SizedBox(height: 8));
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(children: rows),
    );
  }

  static pw.Widget _kv(String k, String v) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(k, style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
        pw.SizedBox(height: 2),
        pw.Text(v, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static String _join(String a, String b) {
    final aa = a.trim();
    final bb = b.trim();
    if (aa.isEmpty && bb.isEmpty) return '—';
    if (aa.isEmpty) return bb;
    if (bb.isEmpty) return aa;
    return '$aa / $bb';
  }

  static pw.Widget _scoreBlock({
    required int score,
    required String category,
    required String recommendation,
    required PdfColor color,
    required int base,
    required int aiAdj,
    required int fpoBoost,
    required PdfI18n i18n,
  }) {
    String fmtAdj(int v) => '${v >= 0 ? '+' : ''}$v';

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 84,
            height: 84,
            decoration: pw.BoxDecoration(
              color: _tint(color, strength: 0.12),
              borderRadius: pw.BorderRadius.circular(14),
              border: pw.Border.all(color: color, width: 2),
            ),
            child: pw.Center(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    '$score',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                    ),
                  ),
                  pw.Text(
                    i18n.score,
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  category,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: color,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  recommendation,
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '${i18n.base}: $base',
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      '${i18n.ai}: ${fmtAdj(aiAdj)}',
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                    ),
                    pw.Text(
                      '${i18n.fpo}: ${fpoBoost > 0 ? '+$fpoBoost' : '0'}',
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _termsTable(LoanTerms terms, {required PdfI18n i18n}) {
    pw.TableRow row(String k, String v) => pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: pw.Text(k, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: pw.Text(v, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        );

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(3),
        },
        border: pw.TableBorder(
          horizontalInside: pw.BorderSide(color: PdfColors.grey200),
        ),
        children: [
          row(i18n.maxAmount, '\$${terms.maxAmount.toStringAsFixed(0)}'),
          row(i18n.interest, '${terms.interestRate.toStringAsFixed(1)}% / yr'),
          row(i18n.tenure, '${terms.tenureMonths} months'),
          row(i18n.repayment, terms.repayment), // should already be localized by engine
        ],
      ),
    );
  }

  static pw.Widget _footer({required PdfI18n i18n}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 6),
        pw.Text(
          i18n.note,
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static Future<void> previewPdf({
    required Uint8List bytes,
    String fileName = 'report.pdf',
  }) async {
    await Printing.layoutPdf(
      name: fileName,
      onLayout: (_) async => bytes,
    );
  }
}
