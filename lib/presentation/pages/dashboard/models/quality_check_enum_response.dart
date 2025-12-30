class QualityCheckEnumResponse {
  final bool success;
  final String message;
  final int status;
  final QualityCheckEnumData data;

  QualityCheckEnumResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory QualityCheckEnumResponse.fromJson(Map<String, dynamic> json) {
    return QualityCheckEnumResponse(
      success: json['success'] ?? false,
      message: (json['message'] ?? '').toString(),
      status: json['status'] ?? 0,
      data: QualityCheckEnumData.fromJson(
          json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.toJson(),
      };
}

class QualityCheckEnumData {
  final List<dynamic> models;
  final List<QualityCheckEnumItem> qualityCheck;

  QualityCheckEnumData({
    required this.models,
    required this.qualityCheck,
  });

  factory QualityCheckEnumData.fromJson(Map<String, dynamic> json) {
    final enums = json['enums'] as Map<String, dynamic>? ?? {};
    final list = (enums['qualityCheck'] as List? ?? [])
        .map((e) => QualityCheckEnumItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return QualityCheckEnumData(
      models: (json['models'] as List?) ?? const [],
      qualityCheck: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'models': models,
        'enums': {
          'qualityCheck': qualityCheck.map((e) => e.toJson()).toList(),
        },
      };
}

class QualityCheckEnumItem {
  final String value; // 'pass', 'hold', 'reject'
  final String label;

  QualityCheckEnumItem({
    required this.value,
    required this.label,
  });

  factory QualityCheckEnumItem.fromJson(Map<String, dynamic> json) {
    return QualityCheckEnumItem(
      value: (json['value'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
}
