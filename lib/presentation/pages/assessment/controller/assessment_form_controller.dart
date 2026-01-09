import 'dart:async';
import 'package:app_mobile/domain/services/network_service.dart';
import 'package:app_mobile/presentation/pages/assessment/models/assessment_draft.dart';
import 'package:app_mobile/presentation/pages/assessment/services/api_assessment.dart';
import 'package:app_mobile/presentation/pages/assessment/services/assessment_local_store.dart';
import 'package:app_mobile/presentation/pages/demo/demo_mode_store.dart';
import 'package:app_mobile/presentation/pages/demo/demo_samples.dart';
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

  bool _demoMode = false;

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
    _notify();
  }

  void _applyDemoSample() {
    final s = DemoSamples.bestCaseAssessment();

    nameCtrl.text = (s['fullName'] ?? '').toString();
    phoneCtrl.text = (s['phone'] ?? '').toString();
    addressCtrl.text = (s['address'] ?? '').toString();

    provinceCtrl.text = (s['province'] ?? '').toString();
    districtCtrl.text = (s['district'] ?? '').toString();
    farmSizeCtrl.text = (s['farmSizeHa'] ?? '').toString();
    cropCtrl.text = (s['mainCrop'] ?? '').toString();

    incomeCtrl.text = (s['monthlyIncome'] ?? '').toString();
    debtCtrl.text = (s['monthlyDebt'] ?? '').toString();

    final repay = (s['repaymentHistory'] ?? '').toString().trim();
    final idx = repaymentItems.indexOf(repay);
    _repaymentIndex = (idx >= 0) ? idx.toString() : '4';

    _isFpoMember = (s['isFpoMember'] ?? false) == true;
    fpoNameCtrl.text = (s['fpoName'] ?? '').toString();
    fpoRoleCtrl.text = (s['fpoRole'] ?? '').toString();
  }

  Future<void> submit(BuildContext context) async {
  FocusScope.of(context).unfocus();
  if (!(formKey.currentState?.validate() ?? false)) return;

  final draft = collectDraft();
  final now = DateTime.now();

  // payload cơ bản từ form
  final assessment = <String, dynamic>{
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
  };

  final isDemo = await DemoModeStore.isEnabled();
  if (isDemo) {
    final demo = DemoSamples.bestCaseAssessment();
    final finalObj = {
      ...demo,          
      ...assessment,   
      'status': 'submitted_demo',
    };

    await AssessmentLocalStore.appendAssessment(finalObj);
    await AssessmentLocalStore.incCountersAfterSubmit();
    await AssessmentLocalStore.clearDraft();

    final farmersCount = await AssessmentLocalStore.getFarmersTotal(fallback: 127);
    if (!context.mounted) return;

    context.go('/ai-processing', extra: {
      'farmersCount': farmersCount,
      'duration': const Duration(seconds: 2),
      'nextRoutePath': '/results',
      'payload': finalObj,
    });
    return;
  }

  final online = await NetworkService.isOnline();

  if (!online) {
    final queued = {...assessment, 'status': 'queued_offline'};

    await AssessmentLocalStore.enqueueSubmission(queued);
    await AssessmentLocalStore.appendAssessment(queued);
    await AssessmentLocalStore.incCountersAfterSubmit();
    await AssessmentLocalStore.clearDraft();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Offline: saved locally. Will submit when online.')),
    );

    final farmersCount = await AssessmentLocalStore.getFarmersTotal(fallback: 127);
    if (!context.mounted) return;
    context.go('/ai-processing', extra: {
      'farmersCount': farmersCount,
      'duration': const Duration(seconds: 3),
      'nextRoutePath': '/results',
      'payload': queued,
    });
    return;
  }

  final remotePayload = await ApiAssessment.submit(assessment);


  final ok = remotePayload != null;

  final finalObj = {
    ...(ok ? remotePayload : assessment),

    'id': (ok ? (remotePayload['id'] ?? assessment['id']) : assessment['id']),
    'createdAt': (ok ? (remotePayload['createdAt'] ?? assessment['createdAt']) : assessment['createdAt']),
    'status': ok ? 'submitted_remote' : 'queued_offline',
  };

  if (!ok) {
    await AssessmentLocalStore.enqueueSubmission(finalObj);
  }

  await AssessmentLocalStore.appendAssessment(finalObj);
  await AssessmentLocalStore.incCountersAfterSubmit();
  await AssessmentLocalStore.clearDraft();

  if (!context.mounted) return;

  context.go('/ai-processing', extra: {
    'farmersCount': await AssessmentLocalStore.getFarmersTotal(fallback: 127),
    'duration': const Duration(seconds: 5),
    'nextRoutePath': '/results',
    'payload': finalObj,
  });
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
