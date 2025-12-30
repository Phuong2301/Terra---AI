// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

// 🌎 Project imports:
import '../../../dev_utils/dev_utils.dart';
import '../../../generated/l10n.dart' as l;
import '../../../domain/core/static/static.dart';
import '../../../domain/core/theme/theme.dart';
import 'components/_components.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final calendarController = sfc.CalendarController();

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    // final lang = l.S.of(context);
    final _isMobile = rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 675, value: true),
      ],
      defaultValue: false,
    ).value;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(
          rf.ResponsiveValue<double>(
            context,
            conditionalValues: [
              const rf.Condition.between(
                start: 0,
                end: 340,
                value: 10,
              ),
              const rf.Condition.between(
                start: 341,
                end: 992,
                value: 16,
              ),
            ],
            defaultValue: 24,
          ).value,
        ),
        constraints: BoxConstraints.tight(
          Size(
            double.maxFinite,
            MediaQuery.of(context).size.height * 0.80,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          border: rf.ResponsiveBreakpoints.of(context)
                  .largerThan(BreakpointName.MD.name)
              ? Border.all(
                  color: _theme.colorScheme.outline,
                  strokeAlign: BorderSide.strokeAlignInside,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          children: [
            // Calender Header
            CalenderHeaderWidget(
              calendarController: calendarController,
            ),

            Expanded(
              child: sfc.SfCalendar(
                headerHeight: 0,
                view: sfc.CalendarView.week,
                allowedViews: const [
                  sfc.CalendarView.day,
                  sfc.CalendarView.week,
                  sfc.CalendarView.month,
                ],
                initialDisplayDate: DateTime.now(),
                backgroundColor: _theme.colorScheme.primaryContainer,
                controller: calendarController,
                // monthCellBuilder: !_isMobile
                //     ? null
                //     : (ctx, _) => MobileMonthlyCellBuilder(
                //           cellDetails: _,
                //           displayDate: calendarController.displayDate,
                //         ),
                selectionDecoration:
                    !_isMobile ? null : getSelectionDecoration(context),
                dataSource: MockAppointments(_getAppointments(context)),
                onTap: (calendarTapDetails) async {
                  if (calendarTapDetails.appointments?.isNotEmpty == true) {
                    final _result = await showDialog(
                      context: context,
                      builder: (context) => ViewCalendarTaskDialog(
                        appointment:
                            calendarTapDetails.appointments?.firstOrNull,
                      ),
                    );
                    devLogger(_result.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<sfc.Appointment> _getAppointments(BuildContext context) {
  List<sfc.Appointment> _meetings = [];
  final lang = l.S.of(context);
  final _today = DateTime.now();
  final _startDate = DateTime(
    _today.year,
    _today.month,
    _today.day,
    9,
    0,
    0,
    0,
  );
  final _endDate = _startDate.add(const Duration(hours: 1));

  _meetings.add(
    sfc.Appointment(
      //subject: 'UI UX Design Review',
      subject: lang.uIUXDesignReview,
      startTime: _startDate,
      endTime: _endDate,
      color: AcnooAppColors.kPrimary600,
    ),
  );
  return _meetings;
}

class MockAppointments extends sfc.CalendarDataSource {
  MockAppointments(List<sfc.Appointment> sourece) {
    appointments = sourece;
  }
}
