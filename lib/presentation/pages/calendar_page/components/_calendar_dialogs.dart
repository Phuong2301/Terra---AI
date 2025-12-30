part of '_components.dart';

class AddTaskDialog<T extends CalendarTaskModel> extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  // Form Field Props
  final _formKey = GlobalKey<FormState>();
  late final startDateController = TextEditingController();
  late final startTimeController = TextEditingController();
  late final endDateController = TextEditingController();
  late final endTimeController = TextEditingController();

  Future<void> getDatePicker(TextEditingController controller) async {
    final _result = await showDatePicker(
      context: context,
      firstDate: AppDateConfig.appFirstDate,
      initialDate: DateTime.now(),
      lastDate: AppDateConfig.appLastDate,
    );

    if (_result != null) {
      controller.text = DateFormat(AppDateConfig.appMonthNameDateFormat).format(
        _result,
      );
    }
  }

  Future<void> getTimePicker(TextEditingController controller) async {
    final _result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_result != null) {
      if (mounted) controller.text = _result.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    // final _theme = Theme.of(context);
    final _isMobile = rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 675, value: true),
      ],
      defaultValue: false,
    ).value;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 610),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              //const DialogHeader(headerTitle: 'Add New Task'),
               DialogHeader(headerTitle: lang.addNewTask),

              // Form
              Flexible(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(_isMobile ? 10 : 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        TextFieldLabelWrapper(
                          //labelText: 'Title',
                          labelText: lang.title,
                          inputField: TextFormField(
                            decoration:  InputDecoration(
                              //hintText: 'Enter title',
                              hintText: lang.enterTitle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Start Date Time
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldLabelWrapper(
                                //labelText: 'Start Date',
                                labelText: lang.startDate,
                                inputField: TextFormField(
                                  readOnly: true,
                                  controller: startDateController,
                                  onTap: () async => getDatePicker(
                                    startDateController,
                                  ),
                                  decoration:  InputDecoration(
                                    //hintText: 'Select start Date',
                                    hintText: lang.selectStartDate,
                                    suffixIcon: const Icon(IconlyLight.calendar),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFieldLabelWrapper(
                                //labelText: 'Time',
                                labelText: lang.time,
                                inputField: TextFormField(
                                  readOnly: true,
                                  controller: startTimeController,
                                  onTap: () async => await getTimePicker(
                                    startTimeController,
                                  ),
                                  decoration:  InputDecoration(
                                   // hintText: 'Select start Time',
                                    hintText: lang.selectStartTime,
                                    suffixIcon: const Icon(IconlyLight.time_circle),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // End Date Time
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldLabelWrapper(
                                //labelText: 'End Date',
                                labelText: lang.endDate,
                                inputField: TextFormField(
                                  readOnly: true,
                                  controller: endDateController,
                                  onTap: () async => await getDatePicker(
                                    endDateController,
                                  ),
                                  decoration:  InputDecoration(
                                    //hintText: 'Select end date',
                                    hintText: lang.selectEndDate,
                                    suffixIcon: const Icon(IconlyLight.calendar),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFieldLabelWrapper(
                                //labelText: 'Time',
                                labelText: lang.time,
                                inputField: TextFormField(
                                  readOnly: true,
                                  controller: endTimeController,
                                  onTap: () async => await getTimePicker(
                                    endTimeController,
                                  ),
                                  decoration:  InputDecoration(
                                    //hintText: 'Select end time',
                                    hintText: lang.selectEndTime,
                                    suffixIcon: const Icon(IconlyLight.time_circle),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Description
                        TextFieldLabelWrapper(
                         // labelText: 'Description',
                          labelText: lang.description,
                          inputField: TextFormField(
                            decoration:  InputDecoration(
                              //hintText: 'Enter here...',
                              hintText: '${lang.enterHere}...',
                            ),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: _isMobile ? 8 : 24),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: _isMobile
                    ? const EdgeInsets.fromLTRB(10, 0, 10, 10)
                    : const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context),
                        //child: const Text('Cancel'),
                        child:  Text(lang.cancel),
                      ),
                    ),
                    SizedBox(width: _isMobile ? 16 : 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                       // child: const Text('Save'),
                        child:  Text(lang.save),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ViewCalendarTaskDialog extends StatelessWidget {
  const ViewCalendarTaskDialog({
    super.key,
    required this.appointment,
  });
  final sfc.Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _fontSize = responsiveValue<double>(
      context,
      xs: 12,
      sm: 12,
      md: 14,
      lg: 16,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 610),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
             // const DialogHeader(headerTitle: 'View Details'),
               DialogHeader(headerTitle: lang.viewDetails),

              // Task Details
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final _size = constraints.biggest;

                    return Column(
                      children: [
                        ...{
                          //"Title": appointment.subject,
                          lang.title: appointment.subject,
                          //"Start Time": DateFormat('dd MMM yyyy, hh:mm a').format(appointment.startTime),
                          lang.startTime: DateFormat('dd MMM yyyy, hh:mm a').format(appointment.startTime),
                         // "End Time": DateFormat('dd MMM yyyy, hh:mm a').format(appointment.endTime),
                          lang.endTime: DateFormat('dd MMM yyyy, hh:mm a').format(appointment.endTime),
                          //"Details": appointment.notes ?? 'N/A',
                          lang.details: appointment.notes ?? 'N/A',
                        }.entries.map(
                              (info) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: _size.width *
                                          responsiveValue<double>(
                                            context,
                                            xs: 0.375,
                                            sm: 0.375,
                                            md: 0.25,
                                            lg: 0.225,
                                          ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            info.key,
                                            style: _theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontSize: _fontSize,
                                              color: _theme
                                                  .checkboxTheme.side?.color,
                                            ),
                                          ),
                                          Text(
                                            ':',
                                            style: _theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontSize: _fontSize,
                                              color: _theme
                                                  .checkboxTheme.side?.color,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        info.value,
                                        style: _theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          fontSize: _fontSize,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
