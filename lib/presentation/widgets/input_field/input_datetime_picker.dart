import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:app_mobile/domain/core/static/_static_values.dart';
import 'package:app_mobile/domain/helpers/extensions/extention_helper.dart';
import 'package:app_mobile/domain/helpers/field_styles/_input_field_styles.dart';
import 'package:app_mobile/presentation/widgets/textfield_wrapper/_textfield_wrapper.dart';



class InputDateTimePicker extends StatelessWidget {
  const InputDateTimePicker(
      {super.key,
      required this.label,
      required this.controller,
      this.dateFormat = AppDateConfig.appNumberOnlyDateTimeFormat});
  final String label;
  final TextEditingController controller;
  final String dateFormat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return TextFieldLabelWrapper(
      labelText: label,
      labelStyle: textTheme.bodySmall,
      inputField: TextFormField(
        controller: controller,
        readOnly: true,
        selectionControls: EmptyTextSelectionControls(),
        decoration: InputDecoration(
          hintText: dateFormat,
          hintStyle: textTheme.bodySmall,
          suffixIcon: const Icon(IconlyLight.calendar, size: 20),
          suffixIconConstraints: AcnooInputFieldStyles(context).iconConstraints,
        ),
        onTap: () async {
          final _result = await showOmniDateTimePicker(
            firstDate: AppDateConfig.appFirstDate,
            lastDate: AppDateConfig.appLastDate,
            initialDate: controller.text.isEmpty
                ? DateTime.now()
                : controller.text.convertToDateTime,
            context: context,
          );

          if (_result != null) {
            controller.text = DateFormat(dateFormat).format(_result);
          }
        },
      ),
    );
  }
}
