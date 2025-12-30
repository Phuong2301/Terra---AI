class AiModelStats {
  final String version;        // "v1.3"
  final int trainedOnFarmers;   // 89
  final double accuracy;        // 0..1 (vd 0.82)

  const AiModelStats({
    required this.version,
    required this.trainedOnFarmers,
    required this.accuracy,
  });

  factory AiModelStats.fromJson(Map<String, dynamic> json) {
    return AiModelStats(
      version: (json['version'] ?? 'v1.0').toString(),
      trainedOnFarmers: _toInt(json['trainedOnFarmers']),
      accuracy: _toDouble(json['accuracy']).clamp(0.0, 1.0),
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0.0;
  }
}
