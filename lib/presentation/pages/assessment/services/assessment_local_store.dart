import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentLocalStore {
  static const draftKey = 'assessment_draft_v1';
  static const submittedCountKey = 'assessments_submitted_count_v1';
  static const farmersTotalKey = 'farmers_assessed_total_v1';
  static const listKey = 'assessments_list_v1';

  static const queueKey = 'assessments_queue_v1';

  static Future<void> saveDraft(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(draftKey, jsonEncode(json));
  }

  static Future<Map<String, dynamic>?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(draftKey);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;

    return decoded.map((k, v) => MapEntry(k.toString(), v));
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(draftKey);
  }

  static Future<int> getFarmersTotal({int fallback = 127}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(farmersTotalKey) ?? fallback;
  }

  static Future<int> getSubmittedCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(submittedCountKey) ?? 0;
  }

  static Future<void> incCountersAfterSubmit() async {
    final prefs = await SharedPreferences.getInstance();
    final total = (prefs.getInt(farmersTotalKey) ?? 127) + 1;
    final mine = (prefs.getInt(submittedCountKey) ?? 0) + 1;
    await prefs.setInt(farmersTotalKey, total);
    await prefs.setInt(submittedCountKey, mine);
  }

  static Future<void> appendAssessment(Map<String, dynamic> assessment) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadAssessments();
    list.insert(0, assessment);
    await prefs.setString(listKey, jsonEncode(list));
  }

  static Future<List<Map<String, dynamic>>> loadAssessments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(listKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map>()
        .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getAssessments() => loadAssessments();

  static Future<void> saveAssessments(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(listKey, jsonEncode(list));
  }

  static Future<void> updateAssessment(String id, Map<String, dynamic> patch) async {
    final list = await loadAssessments();
    final idx = list.indexWhere((e) => (e['id']?.toString() ?? '') == id);
    if (idx < 0) return;

    list[idx] = {...list[idx], ...patch};
    await saveAssessments(list);
  }

  static Future<void> deleteAssessment(String id) async {
    final list = await loadAssessments();
    list.removeWhere((e) => (e['id']?.toString() ?? '') == id);
    await saveAssessments(list);
  }

  static Future<List<Map<String, dynamic>>> loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(queueKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map>()
        .map((m) => m.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  static Future<void> saveQueue(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(queueKey, jsonEncode(list));
  }

  static Future<int> getQueueCount() async {
    final q = await loadQueue();
    return q.length;
  }

  static Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(queueKey);
  }

  static Future<void> enqueueSubmission(Map<String, dynamic> assessment) async {
    final q = await loadQueue();

    final id = (assessment['id']?.toString() ?? '');
    if (id.isEmpty) return;

    q.removeWhere((e) => (e['id']?.toString() ?? '') == id);

    q.insert(0, {
      ...assessment,
      'status': assessment['status'] ?? 'queued_offline',
      'queuedAt': DateTime.now().toIso8601String(),
      'retry': (assessment['retry'] is int) ? assessment['retry'] : 0,
    });

    await saveQueue(q);
  }

  static Future<void> removeFromQueue(String id) async {
    final q = await loadQueue();
    q.removeWhere((e) => (e['id']?.toString() ?? '') == id);
    await saveQueue(q);
  }

  static Future<void> bumpQueueRetry(String id) async {
    final q = await loadQueue();
    final idx = q.indexWhere((e) => (e['id']?.toString() ?? '') == id);
    if (idx < 0) return;

    final cur = q[idx];
    final retry = (cur['retry'] is int) ? (cur['retry'] as int) : 0;
    q[idx] = {
      ...cur,
      'retry': retry + 1,
      'lastRetryAt': DateTime.now().toIso8601String(),
    };
    await saveQueue(q);
  }
}
