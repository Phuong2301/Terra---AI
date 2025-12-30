part of '_components.dart';

class MobileMonthlyCellBuilder extends StatelessWidget {
  const MobileMonthlyCellBuilder({
    super.key,
    required this.cellDetails,
    this.displayDate,
  });
  final sfc.MonthCellDetails cellDetails;
  final DateTime? displayDate;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _today = DateTime.now();
    final _isToday = cellDetails.date.toString().substring(0, 10) ==
        _today.toString().substring(0, 10);

    final _isThisMonth = cellDetails.date.month == displayDate?.month;

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: _theme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Flexible(
            child: Text(
              DateFormat('dd').format(cellDetails.date),
              style: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: _isToday
                    ? _theme.primaryColor
                    : _isThisMonth
                        ? null
                        : _theme.colorScheme.outline,
              ),
            ),
          ),
          if (cellDetails.appointments.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color:
                    (cellDetails.appointments.firstOrNull as sfc.Appointment?)
                        ?.color,
              ),
            )
        ],
      ),
    );
  }
}

BoxDecoration getSelectionDecoration(BuildContext context) {
  final _theme = Theme.of(context);
  return BoxDecoration(
    border: Border.all(
      color: _theme.primaryColor,
      width: 1.5,
    ),
    borderRadius: BorderRadius.circular(4),
  );
}
