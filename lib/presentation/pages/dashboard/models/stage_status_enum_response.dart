class StageStatusEnumResponse {
  final bool success;
  final String message;
  final int status;
  final StageStatusEnumData data;

  StageStatusEnumResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory StageStatusEnumResponse.fromJson(Map<String, dynamic> json) {
    return StageStatusEnumResponse(
      success: json['success'] ?? false,
      message: (json['message'] ?? '').toString(),
      status: json['status'] ?? 0,
      data: StageStatusEnumData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.toJson(),
      };
}

class StageStatusEnumData {
  final List<dynamic> models;
  final List<StageStatusEnumItem> stageStatus;

  StageStatusEnumData({
    required this.models,
    required this.stageStatus,
  });

  factory StageStatusEnumData.fromJson(Map<String, dynamic> json) {
    final enums = json['enums'] as Map<String, dynamic>? ?? {};
    final list = (enums['stageStatus'] as List? ?? [])
        .map((e) => StageStatusEnumItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return StageStatusEnumData(
      models: (json['models'] as List?) ?? const [],
      stageStatus: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'models': models,
        'enums': {
          'stageStatus': stageStatus.map((e) => e.toJson()).toList(),
        },
      };
}

class StageStatusEnumItem {
  final int value; // 0, 1, -1
  final String label;

  StageStatusEnumItem({
    required this.value,
    required this.label,
  });

  factory StageStatusEnumItem.fromJson(Map<String, dynamic> json) {
    return StageStatusEnumItem(
      value: json['value'] is int
          ? json['value']
          : int.tryParse(json['value']?.toString() ?? '0') ?? 0,
      label: (json['label'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
}
