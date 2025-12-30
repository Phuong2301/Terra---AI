// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:table_calendar/table_calendar.dart';

class WidgetCalender extends StatefulWidget {
  const WidgetCalender({super.key});

  @override
  State<WidgetCalender> createState() => _WidgetCalenderState();
}

class _WidgetCalenderState extends State<WidgetCalender> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    const _fallbackTextStyle = TextStyle();

    return TableCalendar(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: const Icon(Icons.chevron_left),
        rightChevronIcon: const Icon(Icons.chevron_right),
        titleTextStyle:
            (_theme.textTheme.titleLarge ?? _fallbackTextStyle).copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle:
            (_theme.textTheme.bodyMedium ?? _fallbackTextStyle).copyWith(
          color: _theme.colorScheme.primary,
        ),
        weekendStyle:
            (_theme.textTheme.bodyMedium ?? _fallbackTextStyle).copyWith(
          color: _theme.colorScheme.primary,
        ),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: _theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        todayTextStyle:
            (_theme.textTheme.bodyMedium ?? _fallbackTextStyle).copyWith(
          color: _selectedDay != null
              ? _theme.colorScheme.onPrimaryContainer
              : Colors.white,
        ),
        todayDecoration: BoxDecoration(
          color: _selectedDay == null ? _theme.colorScheme.primary : null,
          shape: BoxShape.circle,
          border: Border.all(color: _theme.colorScheme.primary),
        ),
        weekendTextStyle:
            (_theme.textTheme.bodyMedium ?? _fallbackTextStyle).copyWith(
          color: _theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
