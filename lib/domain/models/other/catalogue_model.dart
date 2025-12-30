class MCatalogue {
  final int id;
  final String key;
  final List<String> values;

  MCatalogue({
    required this.id,
    required this.key,
    required this.values,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'key': key,
      'values': values,
    };
  }

  factory MCatalogue.fromMap(Map<String, dynamic> map) {
    return MCatalogue(
      id: int.parse((map['id'] ?? '0').toString()),
      key: (map['key'] ?? '').toString(),
      values: ((map['values'] ?? []) as List).map((e) => e.toString()).toList(),
    );
  }
}

class MDropdown {
  final String label;
  final String value;
  final String locationId;
  final String outputQty;
  final String supplier;
  final String premixCurrentStockQty;

  MDropdown({
    required this.label,
    required this.value,
    this.locationId = '0',
    this.outputQty = '0',
    this.supplier = '',
    this.premixCurrentStockQty = '0',
  });

  factory MDropdown.fromMap(Map<String, dynamic> map) {
    return MDropdown(
      label: (map['label'] ?? '').toString(),
      value: (map['value'] ?? '').toString(),
      locationId: (map['location_id'] ?? '0').toString(),
      outputQty: (map['output_qty'] ?? '0').toString(),
      supplier: (map['supplier'] ?? '').toString(),
      premixCurrentStockQty: (map['premix_current_stock_qty'] ?? '0').toString(),
    );
  }
}
