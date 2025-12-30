part of '_components.dart';

class CalenderHeaderWidget extends StatefulWidget {
  const CalenderHeaderWidget({
    super.key,
    this.headerBorderRadius = 12,
    required this.calendarController,
    this.onViewChange,
  });
  final double headerBorderRadius;
  final sfc.CalendarController calendarController;
  final void Function(sfc.CalendarView currentView)? onViewChange;

  @override
  State<CalenderHeaderWidget> createState() => _CalenderHeaderWidgetState();
}

class _CalenderHeaderWidgetState extends State<CalenderHeaderWidget> {
  Set<sfc.CalendarView> _selected = {sfc.CalendarView.week};

  void handleCalendarListener(String updateType) {
    if (!mounted) return;

    if (updateType == 'displayDate') {}
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.calendarController.addPropertyChangedListener(
        handleCalendarListener,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _spacingInfo = rf.ResponsiveValue<_SpacingInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 350,
          value: _SpacingInfo(
            localPadding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            headerHeight: 40,
          ),
        ),
        const rf.Condition.between(
          start: 351,
          end: 375,
          value: _SpacingInfo(
            localPadding: EdgeInsetsDirectional.fromSTEB(14, 10, 14, 10),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            headerHeight: 55,
          ),
        ),
        const rf.Condition.between(
          start: 376,
          end: 992,
          value: _SpacingInfo(
            localPadding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            headerHeight: 55,
          ),
        ),
      ],
      defaultValue: const _SpacingInfo(
        localPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
    ).value;

    final _isMobile = rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 675, value: true),
      ],
      defaultValue: false,
    ).value;

    return Container(
      width: double.maxFinite,
      padding: _spacingInfo.localPadding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _theme.colorScheme.primaryContainer,
        borderRadius: _spacingInfo.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: _spacingInfo.headerHeight,
                width: double.maxFinite,
              ),
              child: Row(
                mainAxisAlignment: _isMobile
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: _isMobile
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  if (!_isMobile) _buildDateSelector(),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: _isMobile
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        // Calender View Selector
                        Flexible(
                          child: CustomSegmentButton<sfc.CalendarView>(
                            segments:  [
                              ButtonSegment(
                               // label: Text('Daily'),
                                label: Text(lang.daily),
                                value: sfc.CalendarView.day,
                              ),
                              ButtonSegment(
                                //label: Text('Weekly'),
                                label: Text(lang.weekly),
                                value: sfc.CalendarView.week,
                              ),
                              ButtonSegment(
                               // label: Text('Month'),
                                label: Text(lang.month),
                                value: sfc.CalendarView.month,
                              ),
                            ],
                            selected: _selected,
                            onSelectionChanged: (value) {
                              if (mounted) setState(() => _selected = value);
                              widget.calendarController.view = value.first;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Add New Task Button
                        _buildAddNewTaskButton(context, _spacingInfo),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isMobile) _buildDateSelector(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return _DateSelectorButton(
      selectedDate: widget.calendarController.displayDate,
      selectedFilter: _selected.first.name,
      onPreviousTap: () {
        widget.calendarController.backward?.call();
        setState(() {});
      },
      onNextTap: () {
        widget.calendarController.forward?.call();
        setState(() {});
      },
    );
  }

  Widget _buildAddNewTaskButton(
    BuildContext context,
    _SpacingInfo spacingInfo,
  ) {
    final lang = l.S.of(context);
    final _mq = MediaQuery.of(context);
    final _buttonStyle = rf.ResponsiveValue<ButtonStyle?>(
      context,
      conditionalValues: [
        rf.Condition.between(
          start: 0,
          end: 360,
          value: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            visualDensity: const VisualDensity(vertical: -2),
          ),
        ),
        rf.Condition.between(
          start: 361,
          end: 410,
          value: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: const VisualDensity(vertical: -1),
          ),
        ),
        rf.Condition.between(
          start: 411,
          end: 675,
          value: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: const VisualDensity(vertical: -1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    ).value;

    return ElevatedButton.icon(
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        size: 20,
      ),
     // label: Text('${_mq.size.width <= 480 ? '' : 'Add'} New Task'),
      label: Text('${_mq.size.width <= 480 ? '' : lang.add} ${lang.newTask}'),
      style: _buttonStyle?.copyWith(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      onPressed: () async {
        final _result = await showDialog<CalendarTaskModel>(
          context: context,
          builder: (popupContext) => const AddTaskDialog(),
        );
        devLogger(_result.toString());
      },
    );
  }
}

class _SpacingInfo {
  final EdgeInsetsGeometry? localPadding;
  final BorderRadiusGeometry? borderRadius;
  final double headerHeight;
  const _SpacingInfo({
    this.localPadding,
    this.borderRadius,
    this.headerHeight = 64,
  });
}

class _DateSelectorButton extends StatelessWidget {
  const _DateSelectorButton({
    this.onPreviousTap,
    this.onNextTap,
    this.selectedDate,
    this.selectedFilter = 'Day',
  });
  final void Function()? onPreviousTap;
  final void Function()? onNextTap;
  final DateTime? selectedDate;
  final String selectedFilter;

  @override
  Widget build(BuildContext context) {
    final _isMobile = rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 675, value: true),
      ],
      defaultValue: false,
    ).value;

    final _theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: _isMobile ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Previous Button
        Flexible(
          child: IconButton.outlined(
            onPressed: onPreviousTap,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: _isMobile ? BorderSide.none : null,
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.chevron_left_outlined),
          ),
        ),

        // Selected Date
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            DateFormat(
              switch (selectedFilter.trim().toLowerCase()) {
                "day" => 'dd MMM, yyyy',
                _ => 'MMM, yyyy',
              },
            ).format(selectedDate ?? DateTime.now()),
            style: _theme.textTheme.bodyLarge?.copyWith(
              fontSize: _isMobile ? 18 : null,
              fontWeight: _isMobile ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),

        // Next Button
        Flexible(
          child: IconButton.outlined(
            onPressed: onNextTap,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: _isMobile ? BorderSide.none : null,
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.chevron_right_outlined),
          ),
        ),
      ],
    );
  }
}
