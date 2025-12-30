class MPermission {
  final num id;
  final String name;
  final String code;

  MPermission({
    required this.id,
    required this.name,
    required this.code,
  });

  factory MPermission.fromJson(Map<String, dynamic> json) {
    return MPermission(
      id: num.parse((json['id'] ?? 0).toString()),
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
    );
  }
}