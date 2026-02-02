import 'dart:async';
import 'package:app_mobile/domain/services/network_service.dart';
import 'package:app_mobile/presentation/model/assessment_draft.dart';
import 'package:app_mobile/presentation/api_service/api_assessment.dart';
import 'package:app_mobile/presentation/api_service/assessment_local_store.dart';
import 'package:app_mobile/presentation/pages/demo/demo_mode_store.dart';
import 'package:app_mobile/presentation/pages/demo/demo_samples.dart';
import 'package:app_mobile/presentation/pages/result/risk_scoring.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssessmentFormController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final districtCtrl = TextEditingController();
  final farmSizeCtrl = TextEditingController();
  final cropCtrl = TextEditingController();
  final incomeCtrl = TextEditingController();
  final debtCtrl = TextEditingController();
  final fpoNameCtrl = TextEditingController();
  final fpoRoleCtrl = TextEditingController();
  final businessYearsCtrl = TextEditingController();
  final seasonalIncomeCtrl = TextEditingController();

  static const fpoTrackRecordItems = <String>[
    'EXCELLENT',
    'GOOD',
    'FAIR',
    'POOR',
    'NONE',
  ];
  String _fpoTrackRecord = 'GOOD';
  String get fpoTrackRecord => _fpoTrackRecord;

  void setFpoTrackRecord(String? v) {
    if (v == null) return;
    _fpoTrackRecord = _normEnum(v, fallback: 'GOOD');
    _notify();
    _scheduleAutosave();
  }

  bool _loadingDraft = true;
  bool _savingDraft = false;
  bool _isFpoMember = false;
  Timer? _debounce;
  bool _disposed = false;
  bool get loadingDraft => _loadingDraft;
  bool get savingDraft => _savingDraft;
  bool get isFpoMember => _isFpoMember;
  bool _demoMode = false;

  List<TextEditingController> get _allCtrls => [
        nameCtrl,
        phoneCtrl,
        addressCtrl,
        provinceCtrl,
        districtCtrl,
        farmSizeCtrl,
        cropCtrl,
        incomeCtrl,
        debtCtrl,
        fpoNameCtrl,
        fpoRoleCtrl,
        businessYearsCtrl,
        seasonalIncomeCtrl,
      ];

  static const repaymentItems = <String>[
    'EXCELLENT',
    'GOOD',
    'FAIR',
    'POOR',
    'NONE', // neutral
  ];

  String _repaymentIndex = '4';
  String get repaymentIndex => _repaymentIndex;

  String get repaymentText {
    final idx = int.tryParse(_repaymentIndex);
    if (idx == null || idx < 0 || idx >= repaymentItems.length) {
      return repaymentItems.last;
    }
    return repaymentItems[idx];
  }

  void setRepaymentIndex(String? val) {
    if (val == null) return;
    _repaymentIndex = val;
    _notify();
    _scheduleAutosave();
  }

  void init({bool demo = false}) {
    _demoMode = demo;

    for (final c in _allCtrls) {
      c.addListener(_scheduleAutosave);
    }

    if (_demoMode) {
      _applyDemoSample();
      _loadingDraft = false;
      _notify();
      return;
    }

    _loadDraft();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  static String _normEnum(String? v, {required String fallback}) {
    final s = (v ?? '').trim().toUpperCase();
    return s.isEmpty ? fallback : s;
  }

  static double? _parseDouble(String s) {
    final t = s.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  static int? _parseInt(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  Future<void> _loadDraft() async {
    _loadingDraft = true;
    _notify();

    final raw = await AssessmentLocalStore.loadDraft();
    if (_disposed) return;

    if (raw != null) {
      final d = AssessmentDraft.fromJson(raw);

      nameCtrl.text = d.fullName;
      phoneCtrl.text = d.phone;
      addressCtrl.text = d.address;
      provinceCtrl.text = d.province;
      districtCtrl.text = d.district;
      farmSizeCtrl.text = d.farmSizeHa?.toString() ?? '';
      cropCtrl.text = d.mainCrop;
      incomeCtrl.text = d.monthlyIncome?.toString() ?? '';
      debtCtrl.text = d.monthlyDebt?.toString() ?? '';
      final savedRepay = _normEnum(d.repaymentHistory, fallback: 'NONE');
      final repayIdx = repaymentItems.indexOf(savedRepay);
      _repaymentIndex = (repayIdx >= 0) ? repayIdx.toString() : '4';
      _isFpoMember = d.isFpoMember;
      fpoNameCtrl.text = d.fpoName;
      fpoRoleCtrl.text = d.fpoRole;
      _fpoTrackRecord = _normEnum(d.fpoTrackRecord, fallback: 'GOOD');
      businessYearsCtrl.text = (d.businessYears ?? '').toString();
      seasonalIncomeCtrl.text = (d.seasonalIncome ?? '').toString();
    }

    _loadingDraft = false;
    _notify();
  }

  AssessmentDraft collectDraft() {
    return AssessmentDraft(
      fullName: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      province: provinceCtrl.text.trim(),
      district: districtCtrl.text.trim(),
      farmSizeHa: _parseDouble(farmSizeCtrl.text),
      mainCrop: cropCtrl.text.trim(),
      repaymentHistory: _normEnum(repaymentText, fallback: 'NONE'),
      monthlyIncome: _parseDouble(incomeCtrl.text),
      monthlyDebt: _parseDouble(debtCtrl.text),
      isFpoMember: _isFpoMember,
      fpoName: fpoNameCtrl.text.trim(),
      fpoRole: fpoRoleCtrl.text.trim(),
      fpoTrackRecord: _normEnum(_fpoTrackRecord, fallback: 'GOOD'),
      businessYears: _parseInt(businessYearsCtrl.text),
      seasonalIncome: _parseDouble(seasonalIncomeCtrl.text),
    );
  }

  void setIsFpoMember(bool v) {
    _isFpoMember = v;
    if (!v) {
      fpoNameCtrl.clear();
      fpoRoleCtrl.clear();
    }
    _notify();
    _scheduleAutosave();
  }

  void _scheduleAutosave() {
    if (_demoMode) return;
    if (_loadingDraft) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 650), () async {
      _savingDraft = true;
      _notify();

      await AssessmentLocalStore.saveDraft(collectDraft().toJson());
      if (_disposed) return;

      _savingDraft = false;
      _notify();
    });
  }

  Future<void> clearDraft() async {
    await AssessmentLocalStore.clearDraft();
    if (_disposed) return;

    if (_demoMode) {
      _applyDemoSample();
      _notify();
      return;
    }

    for (final c in _allCtrls) {
      c.clear();
    }
    _repaymentIndex = '4';
    _isFpoMember = false;

    // reset new fields
    _fpoTrackRecord = 'GOOD';

    _notify();
  }

  void _applyDemoSample() {
    final s = DemoSamples.bestCaseAssessment();

    nameCtrl.text = (s['fullName'] ?? '').toString();
    phoneCtrl.text = (s['phone'] ?? '').toString();
    addressCtrl.text = (s['address'] ?? s['location'] ?? '').toString();
    provinceCtrl.text = (s['province'] ?? '').toString();
    districtCtrl.text = (s['district'] ?? '').toString();
    farmSizeCtrl.text = (s['farmSizeHa'] ?? s['farmSize'] ?? '').toString();
    cropCtrl.text = (s['mainCrop'] ?? s['crops'] ?? '').toString();
    incomeCtrl.text = (s['monthlyIncome'] ?? '').toString();
    debtCtrl.text = (s['monthlyDebt'] ?? s['monthlyDebtPayment'] ?? '').toString();
    final repay = _normEnum((s['repaymentHistory'] ?? 'NONE').toString(), fallback: 'NONE');
    final idx = repaymentItems.indexOf(repay);
    _repaymentIndex = (idx >= 0) ? idx.toString() : '4';
    _isFpoMember = (s['isFpoMember'] ?? false) == true;
    fpoNameCtrl.text = (s['fpoName'] ?? '').toString();
    fpoRoleCtrl.text = (s['fpoRole'] ?? '').toString();
    _fpoTrackRecord = _normEnum((s['fpoTrackRecord'] ?? 'GOOD').toString(), fallback: 'GOOD');
    businessYearsCtrl.text = (s['businessYears'] ?? '').toString();
    seasonalIncomeCtrl.text = (s['seasonalIncome'] ?? '').toString();
  }

  Future<void> submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    final draft = collectDraft();
    final now = DateTime.now();
    final localId = 'local_${now.millisecondsSinceEpoch}';

    final assessment = <String, dynamic>{
      'id': localId,
      'createdAt': now.toIso8601String(),
      'fullName': draft.fullName,
      'phone': draft.phone,
      'location': draft.address,
      'province': draft.province,
      'district': draft.district,
      'farmSize': draft.farmSizeHa ?? 0.0,
      'crops': draft.mainCrop,
      'monthlyIncome': draft.monthlyIncome ?? 0.0,
      'monthlyDebtPayment': draft.monthlyDebt ?? 0.0,
      'repaymentHistory': _normEnum(draft.repaymentHistory, fallback: 'NONE'),
      'isFpoMember': draft.isFpoMember,
      'fpoName': draft.fpoName,
      'fpoRole': draft.fpoRole,
      'fpoTrackRecord': _normEnum(draft.fpoTrackRecord, fallback: 'GOOD'),
      'businessYears': draft.businessYears ?? 0,
      'seasonalIncome': draft.seasonalIncome ?? 0.0,
    };

    // ✅ chạy submit song song (demo/offline/online) và trả về payload cuối cùng
    final submitFuture = _submitAndPersist(assessment);

    if (!context.mounted) return;

    context.go('/ai-processing', extra: {
      'farmersCount': await AssessmentLocalStore.getFarmersTotal(fallback: 127),
      'duration': const Duration(seconds: 5),
      'nextRoutePath': '/results',
      'payload': assessment,              // fallback nếu submitFuture lỗi
      'submitFuture': submitFuture,       // ✅ quan trọng
    });
  }

  Future<Map<String, dynamic>> _submitAndPersist(Map<String, dynamic> assessment) async {
    final isDemo = await DemoModeStore.isEnabled();

    // DEMO: local-calc => flat có outputs
    if (isDemo) {
      final finalObj = _flatFromLocalCalc(
        assessment,
        status: 'submitted_demo',
        calcMode: 'demo',
        langCode: 'en', // hoặc lấy lang từ app nếu bạn muốn
      );

      await AssessmentLocalStore.appendAssessment(finalObj);
      await AssessmentLocalStore.incCountersAfterSubmit();
      await AssessmentLocalStore.clearDraft();
      return finalObj;
    }

    // OFFLINE: local-calc => flat có outputs + queue
    final online = await NetworkService.isOnline();
    if (!online) {
      final finalObj = _flatFromLocalCalc(
        assessment,
        status: 'queued_offline',
        calcMode: 'offline',
        langCode: 'en',
      );

      await AssessmentLocalStore.enqueueSubmission(finalObj);
      await AssessmentLocalStore.appendAssessment(finalObj);
      await AssessmentLocalStore.incCountersAfterSubmit();
      await AssessmentLocalStore.clearDraft();
      return finalObj;
    }

    // ONLINE: gọi BE
    final remote = await ApiAssessment.submit(assessment);

    // fail => fallback offline local-calc
    if (remote == null) {
      final finalObj = _flatFromLocalCalc(
        assessment,
        status: 'queued_offline',
        calcMode: 'offline',
        langCode: 'en',
      );

      await AssessmentLocalStore.enqueueSubmission(finalObj);
      await AssessmentLocalStore.appendAssessment(finalObj);
      await AssessmentLocalStore.incCountersAfterSubmit();
      await AssessmentLocalStore.clearDraft();
      return finalObj;
    }

    // success => flat từ BE đầy đủ outputs
    final finalObj = _flatFromBe(remote, fallbackAssessment: assessment);

    await AssessmentLocalStore.appendAssessment(finalObj);
    await AssessmentLocalStore.incCountersAfterSubmit();
    await AssessmentLocalStore.clearDraft();
    return finalObj;
  }
  Map<String, dynamic> _flatFromLocalCalc(
    Map<String, dynamic> assessment, {
    required String status,
    required String calcMode,
    String langCode = 'en',
  }) {
    final r = RiskScoringEngine.evaluate(assessment, langCode: langCode);

    return {
      ...assessment,
      'status': status,
      'calcMode': calcMode,

      // outputs (đủ để Results chỉ hiển thị)
      'baseScore': r.baseScore,
      'aiAdjustment': r.aiAdjustment,
      'fpoBoost': r.fpoBoost,
      'finalScore': r.finalScore,

      // thống nhất key
      'riskCategory': r.category,
      'category': r.category, // optional để tương thích code cũ

      'recommendation': r.recommendation,
      'reasoning': r.reasoning,

      // terms (dạng map để UI đọc)
      'loanTerms': {
        'recommendedAmount': r.termsWith.maxAmount,
        'interestRateAnnual': r.termsWith.interestRate,
        'tenureMonths': r.termsWith.tenureMonths,
        'estimatedMonthlyPayment': null,
        'paymentCap': null,
        'repayment': r.termsWith.repayment,
        'decision': (r.finalScore >= 75)
            ? 'approve'
            : (r.finalScore >= 50)
                ? 'conditional'
                : 'caution',
        'notes': const [],
      },

      // nếu offline/demo không có breakdown chuẩn BE thì có thể bỏ trống hoặc map tối thiểu
      'breakdown': null,
      'decisionReasons': const [],
      'explainable': null,
    };
  }

  Map<String, dynamic> _flatFromBe(
    Map<String, dynamic> remote, {
    required Map<String, dynamic> fallbackAssessment,
  }) {
    final summary = (remote['summary'] is Map)
        ? (remote['summary'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};

    final score = (remote['score'] is Map)
        ? (remote['score'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};

    final loan = (remote['loanTerms'] is Map)
        ? (remote['loanTerms'] as Map).cast<String, dynamic>()
        : <String, dynamic>{};

    final loanWithout = (remote['loanTermsWithout'] is Map)
        ? (remote['loanTermsWithout'] as Map).cast<String, dynamic>()
        : <String, dynamic>{};
    Map<String, dynamic> _ensureRepayment(Map<String, dynamic> m) {
      final est = m['estimatedMonthlyPayment'];
      final cap = m['paymentCap'];

      final String fallback = (est is num)
          ? '≈ ${est.toStringAsFixed(0)}/mo${(cap is num) ? ' (cap ${cap.toStringAsFixed(0)})' : ''}'
          : 'Monthly';

      return {
        ...m,
        'repayment': (m['repayment'] ?? fallback).toString(),
      };
    }

    final breakdown = (remote['breakdown'] is Map)
        ? (remote['breakdown'] as Map).cast<String, dynamic>()
        : null;

    final reasons = (remote['decisionReasons'] is List)
        ? List<dynamic>.from(remote['decisionReasons'] as List)
        : const <dynamic>[];

    final explainable = (remote['explainable'] is Map)
        ? (remote['explainable'] as Map).cast<String, dynamic>()
        : null;

    // --- Ensure loanTerms has repayment string for LoanTermsCard ---
    final est = loan['estimatedMonthlyPayment'];
    final cap = loan['paymentCap'];

    final loanNorm = _ensureRepayment(loan);
    final loanWithoutNorm = loanWithout.isNotEmpty ? _ensureRepayment(loanWithout) : null;

    // --- Build recommendation + reasoning from BE (so UI doesn’t depend on engine) ---
    final decision = (loanNorm['decision'] ?? '').toString().toLowerCase();
    final String recommendation = _recommendationFromDecision(decision);

    final String reasoning = _reasoningFromBe(
      explainable: explainable,
      reasons: reasons,
      baseScore: (score['baseScore'] as num?)?.round() ?? 0,
      aiAdj: (score['aiAdjustment'] as num?)?.round() ?? 0,
      fpoBoost: (score['fpoBoost'] as num?)?.round() ?? 0,
      finalScore: (score['finalScore'] as num?)?.round() ?? 0,
    );

    return {
      // inputs (flatten) - ưu tiên summary
      ...fallbackAssessment,
      ...summary,

      'ok': remote['ok'] ?? true,
      'assessmentId': remote['id'],
      'createdAt': remote['createdAt'] ?? fallbackAssessment['createdAt'],
      'status': 'submitted_remote',
      'calcMode': 'remote',

      // outputs
      'baseScore': (score['baseScore'] as num?)?.round() ?? 0,
      'aiAdjustment': (score['aiAdjustment'] as num?)?.round() ?? 0,
      'fpoBoost': (score['fpoBoost'] as num?)?.round() ?? 0,
      'finalScore': (score['finalScore'] as num?)?.round() ?? 0,

      // one canonical key
      'riskCategory': (score['riskCategory'] ?? '').toString(),
      'category': (score['riskCategory'] ?? '').toString(), // giữ để tương thích

      // keep BE detail blocks for history/detail screens
      'breakdown': breakdown,
      'loanTerms': loanNorm,
      'loanTermsWithout': loanWithoutNorm,
      'decisionReasons': reasons,
      'explainable': explainable,

      // strings for UI cards
      'recommendation': recommendation,
      'reasoning': reasoning,

      '_be': remote,
    };
  }

  String _recommendationFromDecision(String decision) {
    // Tối giản: theo BE decision. Nếu cần i18n vi/en thì bạn sẽ build tại UI theo locale.
    switch (decision) {
      case 'approve':
        return 'Recommend approval with standard terms.';
      case 'conditional':
      case 'review':
        return 'Recommend conditional approval and further review.';
      case 'reject':
        return 'Recommend rejection or strong caution.';
      default:
        return 'See recommended terms below.';
    }
  }

  String _reasoningFromBe({
    required Map<String, dynamic>? explainable,
    required List<dynamic> reasons,
    required int baseScore,
    required int aiAdj,
    required int fpoBoost,
    required int finalScore,
  }) {
    final baseText = (explainable?['base'] ?? '').toString().trim();
    final formula = (explainable?['finalFormula'] ?? '').toString().trim();

    final reasonsText = reasons.isNotEmpty ? 'Reasons: ${reasons.join(', ')}.' : '';

    final scoreLine =
        'Scores: base $baseScore, AI ${aiAdj >= 0 ? '+' : ''}$aiAdj, FPO +$fpoBoost, final $finalScore.';

    return [
      if (baseText.isNotEmpty) baseText,
      if (formula.isNotEmpty) formula,
      if (reasonsText.isNotEmpty) reasonsText,
      scoreLine,
    ].join(' ');
  }



  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    for (final c in _allCtrls) {
      c.dispose();
    }
    super.dispose();
  }
}
