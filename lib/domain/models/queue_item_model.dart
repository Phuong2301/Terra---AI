class PendingSubmission {
  final String id;
  final String createdAt; // ISO string
  final Map<String, dynamic> payload;
  final int retryCount;

  const PendingSubmission({
    required this.id,
    required this.createdAt,
    required this.payload,
    required this.retryCount,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt,
    'payload': payload,
    'retryCount': retryCount,
  };

  static PendingSubmission fromJson(Map<String, dynamic> j) => PendingSubmission(
    id: (j['id'] ?? '').toString(),
    createdAt: (j['createdAt'] ?? '').toString(),
    payload: (j['payload'] as Map?)?.map((k, v) => MapEntry(k.toString(), v)) ?? {},
    retryCount: (j['retryCount'] is num) ? (j['retryCount'] as num).toInt() : int.tryParse('${j['retryCount']}') ?? 0,
  );

  PendingSubmission copyWith({int? retryCount}) => PendingSubmission(
    id: id,
    createdAt: createdAt,
    payload: payload,
    retryCount: retryCount ?? this.retryCount,
  );
}
