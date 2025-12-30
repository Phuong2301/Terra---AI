import 'package:app_mobile/domain/core/static/_static_values.dart';
import 'package:app_mobile/domain/helpers/field_styles/_input_field_styles.dart';
import 'package:app_mobile/presentation/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class InputDatePicker extends StatelessWidget {
  const InputDatePicker(
      {super.key, required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return TextFieldLabelWrapper(
      labelText: label,
      labelStyle: textTheme.bodySmall,
      inputField: TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        readOnly: true,
        selectionControls: EmptyTextSelectionControls(),
        decoration: InputDecoration(
          hintText: AppDateConfig.appNumberOnlyDateFormat,
          hintStyle: textTheme.bodySmall,
          suffixIcon: const Icon(IconlyLight.calendar, size: 20),
          suffixIconConstraints: AcnooInputFieldStyles(context).iconConstraints,
        ),
        onTap: () async {
          final _result = await showDatePicker(
            context: context,
            firstDate: AppDateConfig.appFirstDate,
            lastDate: AppDateConfig.appLastDate,
            initialDate: DateTime.now(),
            builder: (context, child) => Theme(
              data: theme.copyWith(
                datePickerTheme: DatePickerThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: child!,
            ),
          );

          if (_result != null) {
            controller.text = DateFormat('yyyy-MM-dd')
                .format(_result);
          }
        },
      ),
    );
  }
}
