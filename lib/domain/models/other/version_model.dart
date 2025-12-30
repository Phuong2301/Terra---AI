class VersionModel {
  final String id;
  final String versionName;
  final String platforms;
  final int forceUpdate;
  final String storeId;   
  final int? updatedAt;  

  const VersionModel({
    required this.id,
    required this.versionName,
    required this.platforms,
    required this.forceUpdate,
    required this.storeId,
    this.updatedAt,
  });

  factory VersionModel.fromJson(Map<String, dynamic> src) {
    return VersionModel(
      id: (src['id'] ?? '').toString(),
      versionName: (src['version_name'] ?? '').toString(),
      platforms: (src['platforms'] ?? '').toString(),
      forceUpdate: (src['force_update'] ?? 0),
      storeId: (src['store_id'] ?? '').toString(),
      updatedAt: int.parse((src['updated_at'] ?? 0).toString())
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'version_name': versionName,
        'platforms': platforms,
        'force_update': forceUpdate,
        'store_id': storeId,
        'updated_at': updatedAt, 
      };
}
