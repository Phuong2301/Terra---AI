class MProvince {
  final num id;
  final String code;
  final String name;
  final num countryId;

  MProvince({
    required this.id,
    required this.code,
    required this.name,
    required this.countryId,
  });

  factory MProvince.fromJson(Map<String, dynamic> json) {
    return MProvince(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      countryId: json['country_id'] ?? 0,
    );
  }
}
