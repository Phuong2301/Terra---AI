class MDistrict {
  final num id;
  final String code;
  final String name;
  final num provinceId;

  MDistrict({
    required this.id,
    required this.code,
    required this.name,
    required this.provinceId,
  });

  factory MDistrict.fromJson(Map<String, dynamic> json) {
    return MDistrict(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      provinceId: json['province_id'] ?? 0,
    );
  }
}
