class AdminStats {
  const AdminStats({
    required this.regionName,
    required this.farmersAssessedTotal,
    required this.farmersAssessedThisWeek,
    required this.weekStartIso,
  });

  final String regionName;
  final int farmersAssessedTotal;
  final int farmersAssessedThisWeek;
  final String weekStartIso;

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      regionName: (json['regionName'] ?? 'Mekong').toString(),
      farmersAssessedTotal: _toInt(json['farmersAssessedTotal']),
      farmersAssessedThisWeek: _toInt(json['farmersAssessedThisWeek']),
      weekStartIso: (json['weekStartIso'] ?? '').toString(),
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
