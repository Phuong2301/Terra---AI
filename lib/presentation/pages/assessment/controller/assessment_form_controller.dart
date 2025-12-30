import 'dart:async';
import 'package:app_mobile/presentation/pages/assessment/models/assessment_draft.dart';
import 'package:app_mobile/presentation/pages/assessment/services/assessment_local_store.dart';
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

  bool _loadingDraft = true;
  bool _savingDraft = false;

  bool _isFpoMember = false;

  Timer? _debounce;
  bool _disposed = false;

  bool get loadingDraft => _loadingDraft;
  bool get savingDraft => _savingDraft;

  bool get isFpoMember => _isFpoMember;

  List<TextEditingController> get _allCtrls => [
        nameCtrl, phoneCtrl, addressCtrl,
        provinceCtrl, districtCtrl, farmSizeCtrl, cropCtrl,
        incomeCtrl, debtCtrl,
        fpoNameCtrl, fpoRoleCtrl,
      ];

  static const repaymentItems = <String>[
    'Excellent',
    'Good',
    'Fair',
    'Poor',
    'None (neutral)',
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

  void init() {
    for (final c in _allCtrls) {
      c.addListener(_scheduleAutosave);
    }
    _loadDraft();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
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

      final saved = (d.repaymentHistory).trim();
      final idx = repaymentItems.indexOf(saved);
      _repaymentIndex = (idx >= 0) ? idx.toString() : '4';
      _isFpoMember = d.isFpoMember;

      fpoNameCtrl.text = d.fpoName;
      fpoRoleCtrl.text = d.fpoRole;
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
      farmSizeHa: double.tryParse(farmSizeCtrl.text.trim().replaceAll(',', '.')),
      mainCrop: cropCtrl.text.trim(),
      repaymentHistory: repaymentText,
      monthlyIncome: double.tryParse(incomeCtrl.text.trim().replaceAll(',', '.')),
      monthlyDebt: double.tryParse(debtCtrl.text.trim().replaceAll(',', '.')),
      isFpoMember: _isFpoMember,
      fpoName: fpoNameCtrl.text.trim(),
      fpoRole: fpoRoleCtrl.text.trim(),
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

    for (final c in _allCtrls) {
      c.clear();
    }
    _repaymentIndex = '4';
    _isFpoMember = false;
    _notify();
  }

  Future<void> submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    final draft = collectDraft();
    final now = DateTime.now();

    final assessment = {
      'id': now.millisecondsSinceEpoch.toString(),
      'createdAt': now.toIso8601String(),
      'fullName': draft.fullName,
      'phone': draft.phone,
      'address': draft.address,
      'province': draft.province,
      'district': draft.district,
      'farmSizeHa': draft.farmSizeHa,
      'mainCrop': draft.mainCrop,
      'monthlyIncome': draft.monthlyIncome,
      'monthlyDebt': draft.monthlyDebt,
      'repaymentHistory': draft.repaymentHistory,
      'isFpoMember': draft.isFpoMember,
      'fpoName': draft.fpoName,
      'fpoRole': draft.fpoRole,
      'status': 'submitted_local',
    };

    await AssessmentLocalStore.appendAssessment(assessment);
    await AssessmentLocalStore.incCountersAfterSubmit();
    await AssessmentLocalStore.clearDraft();
    if (_disposed) return;

    final farmersCount = await AssessmentLocalStore.getFarmersTotal(fallback: 127);
    if (_disposed) return;

    context.go(
      '/ai-processing',
      extra: {
        'farmersCount': farmersCount,
        'duration': const Duration(seconds: 7),
        'nextRoutePath': '/results',
        'payload': assessment,
      },
    );
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
