class MGalleryItem {
  final int id;
  final String externalLink;

  MGalleryItem({
    required this.id,
    required this.externalLink,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'external_link': externalLink,
    };
  }

  factory MGalleryItem.fromJson(Map<String, dynamic> map) {
    return MGalleryItem(
      id: int.tryParse((map['id'] ?? '0').toString()) ?? 0,
      externalLink: (map['external_link'] ?? '').toString(),
    );
  }
}
