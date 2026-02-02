import 'package:app_mobile/presentation/pages/result/risk_scoring.dart';
import 'package:flutter/material.dart';

Color scoreColor(int score) {
  if (score >= 75) return const Color(0xFF16A34A); // green
  if (score >= 50) return const Color(0xFFF59E0B); // yellow
  return const Color(0xFFDC2626); // red
}

IconData scoreIcon(String category) {
  if (category == 'Low Risk') return Icons.verified_rounded;
  if (category == 'Medium Risk') return Icons.warning_rounded;
  return Icons.report_rounded;
}
LoanTerms loanTermsFromBe(Map<String, dynamic> raw, {required bool isVi}) {
  final lt = (raw['loanTerms'] as Map?)?.cast<String, dynamic>() ?? const {};

  final amount = (lt['recommendedAmount'] as num?)?.toDouble() ?? 0.0;
  final interest = (lt['interestRateAnnual'] as num?)?.toDouble() ?? 0.0;
  final tenure = (lt['tenureMonths'] as num?)?.toInt() ?? 0;

  // BE không trả repayment cadence => suy luận đơn giản (bạn có thể đổi rule sau)
  final repayment = tenure >= 12
      ? (isVi ? 'Hàng tháng' : 'Monthly')
      : (isVi ? 'Mỗi 2 tuần' : 'Bi-weekly');

  return LoanTerms(
    maxAmount: amount,
    interestRate: interest,
    tenureMonths: tenure,
    repayment: repayment,
  );
}

String categoryFromBe(Map<String, dynamic> raw, {required bool isVi}) {
  final score = (raw['score'] as Map?)?.cast<String, dynamic>() ?? const {};
  final s = (score['riskCategory'] ?? '').toString().trim();
  if (s.isEmpty) return isVi ? 'Rủi ro trung bình' : 'Medium Risk';
  return s; // BE đã trả 'Low Risk'...
}

String recommendationFromBe(Map<String, dynamic> raw, {required bool isVi}) {
  final lt = (raw['loanTerms'] as Map?)?.cast<String, dynamic>() ?? const {};
  final decision = (lt['decision'] ?? '').toString().toLowerCase();

  if (decision == 'approve') {
    return isVi
        ? 'Khuyến nghị duyệt theo điều kiện tiêu chuẩn.'
        : 'Recommend approval with standard terms.';
  }
  if (decision == 'review') {
    return isVi
        ? 'Khuyến nghị duyệt có điều kiện: cần xem xét thêm.'
        : 'Recommend conditional approval: needs further review.';
  }
  return isVi
      ? 'Khuyến nghị thận trọng: cần xác minh thêm trước khi duyệt.'
      : 'Recommend caution: verify more information before approval.';
}

String reasoningFromBe(Map<String, dynamic> raw, {required bool isVi}) {
  final reasons = raw['decisionReasons'];
  if (reasons is List && reasons.isNotEmpty) {
    // hiển thị code reasons dạng list cho MVP
    return reasons.map((e) => '• ${e.toString()}').join('\n');
  }
  final explainable = raw['explainable'];
  if (explainable is Map && explainable['base'] != null) {
    return explainable['base'].toString();
  }
  return isVi ? 'Không có giải thích.' : 'No explanation available.';
}

RiskScoreResult resultFromBe(Map<String, dynamic> raw, {required String langCode}) {
  final isVi = langCode.toLowerCase().startsWith('vi');
  final score = (raw['score'] as Map?)?.cast<String, dynamic>() ?? const {};

  final base = (score['baseScore'] as num?)?.toInt() ?? 0;
  final finalScore = (score['finalScore'] as num?)?.toInt() ?? base;
  final fpoBoost = (score['fpoBoost'] as num?)?.toInt() ?? 0;
  final aiAdj = (score['aiAdjustment'] as num?)?.toInt() ?? 0;

  final termsWith = loanTermsFromBe(raw, isVi: isVi);

  // BE hiện chưa trả termsWithout => tạm dùng engine để tính "without" dựa trên baseScore
  // (không đổi UX của card comparison)
  final without = RiskScoringEngine.evaluate(summaryOrFlat(raw), langCode: langCode).termsWithout;

  return RiskScoreResult(
    baseScore: base,
    aiAdjustment: aiAdj,
    fpoBoost: fpoBoost,
    finalScore: finalScore,
    category: categoryFromBe(raw, isVi: isVi),
    recommendation: recommendationFromBe(raw, isVi: isVi),
    reasoning: reasoningFromBe(raw, isVi: isVi),
    termsWith: termsWith,
    termsWithout: without,
  );
}

// dùng lại logic unwrap summary -> map phẳng (đúng key engine cần)
Map<String, dynamic> summaryOrFlat(Map<String, dynamic> raw) {
  final summary = (raw['summary'] is Map) ? (raw['summary'] as Map).cast<String, dynamic>() : null;
  final p = <String, dynamic>{...(summary ?? raw)};

  // normalize seasonalIncome (BE trả bool)
  final si = p['seasonalIncome'];
  if (si is bool) p['seasonalIncome'] = si ? 1.0 : 0.0;
  if (si is num) p['seasonalIncome'] = si.toDouble();

  // đảm bảo debt key để engine dùng
  if (!p.containsKey('monthlyDebt') && p.containsKey('monthlyDebtPayment')) {
    p['monthlyDebt'] = p['monthlyDebtPayment'];
  }
  return p;
}
Map<String, dynamic> flattenBeResult({
  required Map<String, dynamic> be,
  required Map<String, dynamic> fallbackAssessment,
}) {
  final summary = (be['summary'] is Map)
      ? (be['summary'] as Map).cast<String, dynamic>()
      : const <String, dynamic>{};

  final score = (be['score'] is Map)
      ? (be['score'] as Map).cast<String, dynamic>()
      : const <String, dynamic>{};

  final loanTerms = (be['loanTerms'] is Map)
      ? (be['loanTerms'] as Map).cast<String, dynamic>()
      : const <String, dynamic>{};

  return <String, dynamic>{
    ...fallbackAssessment,
    ...summary,

    'finalScore': (score['finalScore'] as num?)?.toInt() ?? 0,
    'baseScore': (score['baseScore'] as num?)?.toInt() ?? 0,
    'aiAdjustment': (score['aiAdjustment'] as num?)?.toInt() ?? 0,
    'fpoBoost': (score['fpoBoost'] as num?)?.toInt() ?? 0,
    'category': (score['riskCategory'] ?? '').toString(),
    'loanTerms': loanTerms,

    'createdAt': be['createdAt'] ?? fallbackAssessment['createdAt'],
    'assessmentId': be['assessmentId'],
    'status': 'submitted_remote',
    'calcMode': 'be',

    '_be': be,
  };
}
