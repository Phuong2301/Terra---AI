class MCountry {
  final num id;
  final String code;
  final String name;
  final String phoneCode;

  MCountry({
    required this.id,
    required this.code,
    required this.name,
    required this.phoneCode,
  });

  factory MCountry.fromJson(Map<String, dynamic> json) {
    return MCountry(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      phoneCode: json['phone_code'] ?? '',
    );
  }
}
