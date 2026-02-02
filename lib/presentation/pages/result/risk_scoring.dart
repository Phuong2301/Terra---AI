import 'dart:math' as math;

class RiskScoreResult {
  final int baseScore;
  final int aiAdjustment;
  final int fpoBoost;
  final int finalScore;

  final String category;
  final String recommendation;
  final String reasoning;

  final LoanTerms termsWith;
  final LoanTerms termsWithout;

  RiskScoreResult({
    required this.baseScore,
    required this.aiAdjustment,
    required this.fpoBoost,
    required this.finalScore,
    required this.category,
    required this.recommendation,
    required this.reasoning,
    required this.termsWith,
    required this.termsWithout,
  });
}

class LoanTerms {
  final double maxAmount;
  final double interestRate;
  final int tenureMonths;
  final String repayment;

  LoanTerms({
    required this.maxAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.repayment,
  });
}

class RiskScoringEngine {
  static RiskScoreResult evaluate(
    Map<String, dynamic> payload, {
    String langCode = 'en',
  }) {
    final isVi = langCode.toLowerCase().startsWith('vi');

    final repayment = (payload['repaymentHistory'] ?? 'None').toString();
    final income = _toDouble(payload['monthlyIncome']);
    final debt = _toDouble(payload['monthlyDebtPayment'] ?? payload['monthlyDebt']);
    final isFpo = (payload['isFpoMember'] ?? false) == true;

    final repayPoints = _repaymentPoints(repayment);
    final dtiPoints = _dtiPoints(income: income, debt: debt);
    final businessPoints = 9;
    final collateralPoints = 0;
    final diversificationPoints = 5;

    var base = repayPoints + dtiPoints + businessPoints + collateralPoints + diversificationPoints;
    base = base.clamp(0, 100);

    final province = (payload['province'] ?? '').toString();
    final district = (payload['district'] ?? '').toString();

    final aiAdj = _aiAdjustment(
      repaymentHistory: repayment,
      income: income,
      debt: debt,
      province: province,
      district: district,
      isFpo: isFpo,
    );

    final fpoBoost = isFpo ? 10 : 0;
    final finalScore = (base + aiAdj + fpoBoost).clamp(0, 100);

    final cat = _category(finalScore, isVi: isVi);
    final rec = _recommendation(finalScore, isVi: isVi);

    final reason = _buildReasoning(
      isVi: isVi,
      baseScore: base,
      repayPoints: repayPoints,
      dtiPoints: dtiPoints,
      aiAdj: aiAdj,
      fpoBoost: fpoBoost,
      finalScore: finalScore,
      repaymentHistory: repayment,
      income: income,
      debt: debt,
      isFpo: isFpo,
      province: province,
      district: district,
    );

    final without = _termsFromScore(base.clamp(0, 100), isVi: isVi);
    final withFpo = _termsFromScore(finalScore, isVi: isVi);

    return RiskScoreResult(
      baseScore: base,
      aiAdjustment: aiAdj,
      fpoBoost: fpoBoost,
      finalScore: finalScore,
      category: cat,
      recommendation: rec,
      reasoning: reason,
      termsWith: withFpo,
      termsWithout: without,
    );
  }

  static int _repaymentPoints(String v) {
    switch (v) {
      case 'Excellent':
        return 35;
      case 'Good':
        return 28;
      case 'Fair':
        return 20;
      case 'Poor':
        return 10;
      case 'None':
        return 18;
      default:
        return 18;
    }
  }

  static int _dtiPoints({double? income, double? debt}) {
    if (income == null || income <= 0 || debt == null || debt < 0) {
      return 18;
    }
    final dti = (debt / income) * 100;
    if (dti < 30) return 30;
    if (dti < 40) return 26;
    if (dti < 50) return 22;
    if (dti < 60) return 18;
    if (dti < 70) return 14;
    return 8;
  }

  static int _aiAdjustment({
    required String repaymentHistory,
    required double? income,
    required double? debt,
    required String province,
    required String district,
    required bool isFpo,
  }) {
    final seed = (province + district + repaymentHistory).hashCode.abs();
    final rnd = math.Random(seed);

    int adj = 0;

    if (repaymentHistory == 'Excellent') adj += 4;
    if (repaymentHistory == 'Good') adj += 2;

    if (income == null || debt == null) adj += 1;

    if (income != null && income > 0 && debt != null && debt >= 0) {
      final dti = (debt / income);
      if (dti < 0.35) adj += 3;
      else if (dti < 0.50) adj += 2;
      else if (dti > 0.70) adj -= 2;
    }

    if (isFpo) adj += 2;

    adj += (rnd.nextInt(3) - 1); // -1..+1

    return adj.clamp(-5, 15);
  }

  static String _category(int score, {required bool isVi}) {
    if (score >= 75) return isVi ? 'Rủi ro thấp' : 'Low Risk';
    if (score >= 50) return isVi ? 'Rủi ro trung bình' : 'Medium Risk';
    return isVi ? 'Rủi ro cao' : 'High Risk';
  }

  static String _recommendation(int score, {required bool isVi}) {
    if (score >= 75) {
      return isVi
          ? 'Khuyến nghị duyệt theo điều kiện tiêu chuẩn. Theo dõi dòng tiền theo mùa vụ.'
          : 'Recommend approval with standard terms. Monitor seasonal cash flow.';
    }
    if (score >= 50) {
      return isVi
          ? 'Khuyến nghị duyệt có điều kiện: hạn mức nhỏ hơn và lịch trả nợ chặt chẽ hơn.'
          : 'Recommend conditional approval: smaller limit and stronger repayment schedule.';
    }
    return isVi
        ? 'Khuyến nghị thận trọng: xác minh độ ổn định thu nhập, giảm mức phơi nhiễm, cân nhắc bảo lãnh.'
        : 'Recommend caution: verify income stability, reduce exposure, consider guarantees.';
  }

  static LoanTerms _termsFromScore(int score, {required bool isVi}) {
    final maxAmount = _lerp(300, 2000, score / 100.0);
    final interest = _lerp(28, 14, score / 100.0);
    final tenure = (6 + (score / 100.0 * 12)).round();

    final repay = score >= 75
        ? (isVi ? 'Hàng tháng' : 'Monthly')
        : (score >= 50
            ? (isVi ? 'Mỗi 2 tuần' : 'Bi-weekly')
            : (isVi ? 'Hàng tuần' : 'Weekly'));

    return LoanTerms(
      maxAmount: double.parse(maxAmount.toStringAsFixed(0)),
      interestRate: double.parse(interest.toStringAsFixed(1)),
      tenureMonths: tenure,
      repayment: repay,
    );
  }

  static String _buildReasoning({
    required bool isVi,
    required int baseScore,
    required int repayPoints,
    required int dtiPoints,
    required int aiAdj,
    required int fpoBoost,
    required int finalScore,
    required String repaymentHistory,
    required double? income,
    required double? debt,
    required bool isFpo,
    required String province,
    required String district,
  }) {
    final dtiStr = (income != null && income > 0 && debt != null)
        ? '${((debt / income) * 100).toStringAsFixed(0)}%'
        : (isVi ? 'Không có' : 'N/A');

    final loc = _loc(province, district, isVi: isVi);

    final parts = <String>[
      isVi
          ? 'Điểm cơ sở = $baseScore (Trả nợ $repayPoints/35, Tỷ lệ nợ/thu nhập $dtiPoints/30, các yếu tố khác trung tính).'
          : 'Base score = $baseScore (Repayment $repayPoints/35, Debt-to-income $dtiPoints/30, other factors neutral).',
      isVi
          ? 'Điều chỉnh AI = ${aiAdj >= 0 ? '+' : ''}$aiAdj dựa trên mẫu từ hồ sơ tương tự tại $loc và dữ liệu bạn nhập (Trả nợ: $repaymentHistory, DTI: $dtiStr).'
          : 'AI adjustment = ${aiAdj >= 0 ? '+' : ''}$aiAdj based on patterns from similar farmer profiles in $loc and your inputs (Repayment: $repaymentHistory, DTI: $dtiStr).',
    ];

    if (isFpo) {
      parts.add(
        isVi
            ? 'Cộng điểm FPO = +$fpoBoost do hiệu ứng hồ sơ tập thể trong mô hình.'
            : 'FPO boost = +$fpoBoost due to collective track record effect in the model.',
      );
    } else {
      parts.add(
        isVi ? 'Không cộng điểm FPO (không phải thành viên).' : 'No FPO boost applied (non-member).',
      );
    }

    parts.add(
      isVi ? 'Điểm cuối = $finalScore (tối đa 100).' : 'Final score = $finalScore (capped at 100).',
    );

    return parts.join(' ');
  }

  static String _loc(String province, String district, {required bool isVi}) {
    final p = province.trim();
    final d = district.trim();
    if (p.isEmpty && d.isEmpty) return isVi ? 'khu vực của bạn' : 'your region';
    if (p.isNotEmpty && d.isNotEmpty) return '$district, $province';
    return p.isNotEmpty ? p : d;
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}
