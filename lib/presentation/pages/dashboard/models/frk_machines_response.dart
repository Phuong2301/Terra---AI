import 'package:app_mobile/presentation/pages/dashboard/models/business_location_response.dart';

class FrkMachinesResponse {
  final bool success;
  final String message;
  final int status;
  final List<FrkMachine> data;
  final Paginate? paginate;

  FrkMachinesResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
    required this.paginate,
  });

  factory FrkMachinesResponse.fromJson(Map<String, dynamic> json) {
    return FrkMachinesResponse(
      success: json['success'] ?? false,
      message: (json['message'] ?? '').toString(),
      status: json['status'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => FrkMachine.fromJson(e as Map<String, dynamic>))
          .toList(),
      paginate: json['paginate'] != null
          ? Paginate.fromJson(json['paginate'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.map((e) => e.toJson()).toList(),
        'paginate': paginate?.toJson(),
      };
}

class FrkMachine {
  final int id;
  final String machineName;
  final String type;
  final String volume;
  final String dimension;
  final String weight;
  final String powerSupply;
  final String capacity;
  final String? createdAt;
  final String? updatedAt;

  FrkMachine({
    required this.id,
    required this.machineName,
    required this.type,
    required this.volume,
    required this.dimension,
    required this.weight,
    required this.powerSupply,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FrkMachine.fromJson(Map<String, dynamic> json) {
    return FrkMachine(
      id: json['id'] ?? 0,
      machineName: (json['machine_name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      volume: (json['volume'] ?? '').toString(),
      dimension: (json['dimension'] ?? '').toString(),
      weight: (json['weight'] ?? '').toString(),
      powerSupply: (json['power_supply'] ?? '').toString(),
      capacity: (json['capacity'] ?? '').toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'machine_name': machineName,
        'type': type,
        'volume': volume,
        'dimension': dimension,
        'weight': weight,
        'power_supply': powerSupply,
        'capacity': capacity,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
