class CalendarTaskModel {
  final String title;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? description;

  const CalendarTaskModel({
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
    this.description,
  });
}
