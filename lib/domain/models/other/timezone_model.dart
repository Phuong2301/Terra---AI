class MTimeZone {
  final num id;
  final String offset;
  final String name;
  final num isActive;

  MTimeZone({
    required this.id,
    required this.offset,
    required this.name,
    required this.isActive,
  });

  factory MTimeZone.fromJson(Map<String, dynamic> json) {
    return MTimeZone(
      id: num.parse((json['id'] ?? 0).toString()),
      offset: (json['offset'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      isActive: num.parse((json['is_active'] ?? 0).toString()),
    );
  }

  factory MTimeZone.copy(MTimeZone data) {
    return MTimeZone(
      id: data.id,
      offset: data.offset,
      name: data.name,
      isActive: data.isActive,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      'offset': offset,
      'name': name,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      ...toMapCreate(),
    };
  }
}
