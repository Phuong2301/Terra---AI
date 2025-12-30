import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'package:app_mobile/domain/core/static/_static_values.dart';
import 'package:app_mobile/domain/helpers/field_styles/_input_field_styles.dart';
import 'package:app_mobile/presentation/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:iconly/iconly.dart';

class InputMonthPicker extends StatelessWidget {
  const InputMonthPicker({
    super.key,
    required this.label,
    required this.controller,
    this.format = 'yyyy-MM',
    this.firstDate,
    this.lastDate,
    this.required = false,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String format;

  final DateTime? firstDate;
  final DateTime? lastDate;

  final bool required;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    String? effectiveValidator(String? v) {
      if (validator != null) return validator!(v);
      if (!required) return null;
      return (v == null || v.trim().isEmpty) ? 'Required' : null;
    }

    return TextFieldLabelWrapper(
      labelText: label,
      labelStyle: textTheme.bodySmall,
      inputField: TextFormField(
        controller: controller,
        readOnly: true,
        selectionControls: EmptyTextSelectionControls(),
        decoration: InputDecoration(
          hintText: format,
          hintStyle: textTheme.bodySmall,
          suffixIcon: const Icon(IconlyLight.calendar, size: 20),
          suffixIconConstraints: AcnooInputFieldStyles(context).iconConstraints,
        ),
        validator: effectiveValidator,
        onTap: () async {
          final now = DateTime.now();
          DateTime initial = now;

          if (controller.text.trim().isNotEmpty) {
            try {
              initial = DateFormat(format).parse(controller.text.trim());
            } catch (_) {}
          }

          final picked = await showMonthYearPicker(
            context: context,
            initialDate: initial,
            firstDate: firstDate ?? AppDateConfig.appFirstDate,
            lastDate: lastDate ?? AppDateConfig.appLastDate,
          );

          if (picked != null) {
            controller.text = DateFormat(format).format(picked);
          }
        },
      ),
    );
  }
}
