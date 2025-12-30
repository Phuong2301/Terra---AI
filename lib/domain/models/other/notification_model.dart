class MNotification {
  final num id;
  final String title;
  final String body;
  final String payload;
  final int createdAt;
  final num userId;
  final String type;
  final String route;
  final num createdBy;

  MNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.createdAt,
    required this.userId,
    required this.type,
    required this.route,
    required this.createdBy,
  });

  factory MNotification.fromJson(Map<String, dynamic> json) {
    return MNotification(
      id: num.parse((json['id'] ?? 0).toString()),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      payload: (json['payload'] ?? '').toString(),
      createdAt: int.parse(
          (json['created_at'] ?? DateTime.now().millisecondsSinceEpoch)
              .toString()),
      userId: num.parse((json['user_id'] ?? 0).toString()),
      type: (json['type'] ?? '').toString(),
      route: (json['route'] ?? '').toString(),
      createdBy: num.parse((json['created_by'] ?? 0).toString()),
    );
  }
}
