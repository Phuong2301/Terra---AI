class MCurrency {
  final num id;
  final String code;
  final String name;
  final String symbol;

  MCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory MCurrency.fromJson(Map<String, dynamic> json) {
    return MCurrency(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
    );
  }
}
