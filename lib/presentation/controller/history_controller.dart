import 'package:flutter/material.dart';

// TODO: sửa đúng path của bạn
import '../api_service/assessment_local_store.dart';
import '../api_service/api_admin_stats.dart';

class HistoryController extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  bool _disposed = false;

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  Map<String, dynamic>? _asMap(dynamic v) {
    if (v is Map) return v.cast<String, dynamic>();
    return null;
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.round();
    return int.tryParse(v.toString());
  }

  // ---------------------------
  //  EXPORT -> HISTORY NORMALIZE
  // ---------------------------
  Map<String, dynamic>? _normalizeExportItem(Map<String, dynamic> m) {
    // Ưu tiên dùng "id" (export id) làm key chính để merge/so sánh
    final id = (m['id'] ?? '').toString().trim();
    if (id.isEmpty) return null;

    final assessmentId = (m['assessmentId'] ?? '').toString().trim();

    final summary = (m['summary'] is Map)
        ? (m['summary'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};

    final score = (m['score'] is Map)
        ? (m['score'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};

    final fullName = (summary['fullName'] ?? 'Farmer').toString();
    final isFpoMember = summary['isFpoMember'] == true;
    final riskCategory = (score['riskCategory'] ?? '').toString();

    return <String, dynamic>{
      // ===== KEY CHÍNH =====
      'id': id,

      // ===== giữ assessmentId để debug / hoặc dùng khi cần =====
      'assessmentId': assessmentId,

      'createdAt': (m['createdAt'] ?? '').toString(),

      // ===== RAW objects (ResultsScreen đọc được) =====
      'summary': summary,
      'score': score,
      'breakdown': m['breakdown'],
      'loanTerms': m['loanTerms'],
      'loanTermsWithout': m['loanTermsWithout'],

      // ===== Flatten fields for UI =====
      'fullName': fullName,
      'phone': summary['phone'],
      'location': (summary['location'] ?? '').toString(),
      'province': (summary['province'] ?? '').toString(),
      'district': (summary['district'] ?? '').toString(),
      'isFpoMember': isFpoMember,
      'fpoName': summary['fpoName'],
      'fpoRole': summary['fpoRole'],
      'fpoTrackRecord': summary['fpoTrackRecord'],

      // score flattened
      'baseScore': score['baseScore'],
      'aiAdjustment': score['aiAdjustment'],
      'fpoBoost': score['fpoBoost'],
      'finalScore': score['finalScore'],
      'riskCategory': riskCategory,
      'category': riskCategory, // backward compat
    };
  }

  // ---------------------------
  //  LOCAL EXTRACTORS (giữ nguyên logic bạn đang có)
  // ---------------------------
  /// Extract BE score if record still stores raw BE response
  Map<String, dynamic>? _extractBeScore(Map<String, dynamic> it) {
    // Case 1: raw BE response persisted
    final score = _asMap(it['score']);
    if (score != null && score['finalScore'] != null) return score;

    // Case 2: snapshot in _be
    final be = _asMap(it['_be']);
    final beScore = _asMap(be?['score']);
    if (beScore != null && beScore['finalScore'] != null) return beScore;

    return null;
  }

  Map<String, dynamic>? _extractBeLoanTerms(Map<String, dynamic> it) {
    final loan = _asMap(it['loanTerms']);
    if (loan != null && loan.isNotEmpty) return loan;

    final be = _asMap(it['_be']);
    final beLoan = _asMap(be?['loanTerms']);
    if (beLoan != null && beLoan.isNotEmpty) return beLoan;

    return null;
  }

  Map<String, dynamic>? _extractBeLoanTermsWithout(Map<String, dynamic> it) {
    final loan = _asMap(it['loanTermsWithout']);
    if (loan != null && loan.isNotEmpty) return loan;

    final be = _asMap(it['_be']);
    final beLoan = _asMap(be?['loanTermsWithout']);
    if (beLoan != null && beLoan.isNotEmpty) return beLoan;

    return null;
  }

  List<dynamic>? _extractBeReasons(Map<String, dynamic> it) {
    final reasons = it['decisionReasons'];
    if (reasons is List && reasons.isNotEmpty) return List<dynamic>.from(reasons);

    final be = _asMap(it['_be']);
    final beReasons = be?['decisionReasons'];
    if (beReasons is List && beReasons.isNotEmpty) return List<dynamic>.from(beReasons);

    return null;
  }

  Map<String, dynamic>? _extractBeExplainable(Map<String, dynamic> it) {
    final ex = _asMap(it['explainable']);
    if (ex != null && ex.isNotEmpty) return ex;

    final be = _asMap(it['_be']);
    final beEx = _asMap(be?['explainable']);
    if (beEx != null && beEx.isNotEmpty) return beEx;

    return null;
  }

  // ---------------------------
  //  MIGRATION (giữ nguyên bạn đang có)
  // ---------------------------
  Future<void> _migrateLocalIfNeeded(List<Map<String, dynamic>> list) async {
    for (final it in list) {
      final id = (it['id'] ?? '').toString();
      if (id.isEmpty) continue;

      final patch = <String, dynamic>{};

      final hasFinalScore = it['finalScore'] != null;
      final hasRiskCategory = (it['riskCategory'] ?? it['category']) != null;

      // 1) If missing finalScore, try extract from BE score map
      if (!hasFinalScore) {
        final beScore = _extractBeScore(it);
        final beFinal = _asInt(beScore?['finalScore']);
        if (beFinal != null) {
          patch['finalScore'] = beFinal;
          patch['baseScore'] = _asInt(beScore?['baseScore']) ?? it['baseScore'];
          patch['aiAdjustment'] = _asInt(beScore?['aiAdjustment']) ?? it['aiAdjustment'];
          patch['fpoBoost'] = _asInt(beScore?['fpoBoost']) ?? it['fpoBoost'];

          final beCat = (beScore?['riskCategory'] ?? '').toString();
          if (beCat.isNotEmpty) {
            patch['riskCategory'] = beCat;
            patch['category'] = beCat; // backward compat
          }
        }
      }

      // 2) Legacy migration: record từng lưu "score" (int) => map sang finalScore
      // (KHÔNG chấm lại)
      if (patch['finalScore'] == null && !hasFinalScore) {
        final legacyScore = _asInt(it['score']);
        if (legacyScore != null) {
          patch['finalScore'] = legacyScore;
        }
      }

      // 3) Ensure riskCategory exists (prefer BE/flat, fallback category)
      if (!hasRiskCategory) {
        final cat = (it['category'] ?? '').toString();
        if (cat.isNotEmpty) patch['riskCategory'] = cat;
      } else if (it['riskCategory'] == null && it['category'] != null) {
        patch['riskCategory'] = it['category'];
      }

      // 4) Ensure loanTerms present for Results screen
      final loan = _extractBeLoanTerms(it);
      if (it['loanTerms'] == null && loan != null) patch['loanTerms'] = loan;

      final loanWithout = _extractBeLoanTermsWithout(it);
      if (it['loanTermsWithout'] == null && loanWithout != null) {
        patch['loanTermsWithout'] = loanWithout;
      }

      // 5) Keep decisionReasons/explainable if present in _be
      final reasons = _extractBeReasons(it);
      if (it['decisionReasons'] == null && reasons != null) patch['decisionReasons'] = reasons;

      final explainable = _extractBeExplainable(it);
      if (it['explainable'] == null && explainable != null) patch['explainable'] = explainable;

      if (patch.isNotEmpty) {
        await AssessmentLocalStore.updateAssessment(id, patch);
        it.addAll(patch);
      }
    }
  }

  // ---------------------------
  //  MERGE: remote overrides score/category,
  //         local keeps rich fields if remote thiếu
  // ---------------------------
  Map<String, dynamic> _mergeRemoteLocal({
    required Map<String, dynamic> remote,
    required Map<String, dynamic>? local,
  }) {
    if (local == null) return remote;

    final merged = <String, dynamic>{...local, ...remote};

    // Giữ các field "rich" từ local nếu remote không có
    void keepIfRemoteMissing(String key) {
      final rv = remote[key];
      if (rv == null ||
          (rv is String && rv.trim().isEmpty) ||
          (rv is Map && rv.isEmpty) ||
          (rv is List && rv.isEmpty)) {
        if (local.containsKey(key)) merged[key] = local[key];
      }
    }

    keepIfRemoteMissing('_be');
    keepIfRemoteMissing('loanTerms');
    keepIfRemoteMissing('loanTermsWithout');
    keepIfRemoteMissing('decisionReasons');
    keepIfRemoteMissing('explainable');
    keepIfRemoteMissing('rawContent');
    keepIfRemoteMissing('images');

    return merged;
  }

  // ---------------------------
  //  LOAD
  // ---------------------------
  Future<void> load() async {
    _loading = true;
    _notify();

    // 1) Load local first (offline baseline)
    final localList = await AssessmentLocalStore.loadAssessments();
    if (_disposed) return;

    // migrate local schema (như bạn đang làm)
    await _migrateLocalIfNeeded(localList);
    if (_disposed) return;

    // index local by id
    final localById = <String, Map<String, dynamic>>{};
    for (final it in localList) {
      final id = (it['id'] ?? '').toString();
      if (id.isNotEmpty) localById[id] = it;
    }

    // 2) Try fetch remote export
    List<Map<String, dynamic>> remoteNormalized = const [];
    try {
      final remoteRaw = await ApiAdminStats.fetchExportList();
      remoteNormalized = remoteRaw
          .map(_normalizeExportItem)
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (_) {
      remoteNormalized = const [];
    }

    // 3) Merge remote into local (remote ưu tiên score/category)
    final mergedById = <String, Map<String, dynamic>>{};

    // start from local
    for (final e in localById.entries) {
      mergedById[e.key] = e.value;
    }

    // apply remote
    for (final r in remoteNormalized) {
      final id = (r['id'] ?? '').toString();
      if (id.isEmpty) continue;

      final local = localById[id];
      final merged = _mergeRemoteLocal(remote: r, local: local);
      mergedById[id] = merged;

      // 4) Optional: persist merged to local for offline
      // Nếu updateAssessment KHÔNG upsert, vẫn ok vì UI dùng mergedById.
      // Khuyến nghị bạn thêm upsert ở store để đồng bộ thật sự.
      await AssessmentLocalStore.updateAssessment(id, merged);
      // Nếu có hàm upsert thì thay:
      // await AssessmentLocalStore.upsertAssessment(id, merged);
    }

    // 5) Build list + sort
    final mergedList = mergedById.values.toList();
    mergedList.sort((a, b) {
      final da = DateTime.tryParse((a['createdAt'] ?? '').toString());
      final db = DateTime.tryParse((b['createdAt'] ?? '').toString());
      return (db ?? DateTime(0)).compareTo(da ?? DateTime(0));
    });

    _items = mergedList;
    _loading = false;
    _notify();
  }

  Future<void> deleteById(String id) async {
    await AssessmentLocalStore.deleteAssessment(id);
    _items.removeWhere((e) => (e['id']?.toString() ?? '') == id);
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
