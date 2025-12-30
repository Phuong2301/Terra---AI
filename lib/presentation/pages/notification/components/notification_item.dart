import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String date;

  const NotificationItem({
    super.key,
    required this.title,
    required this.body,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(body),
      trailing: Text(date),
    );
  }
}
