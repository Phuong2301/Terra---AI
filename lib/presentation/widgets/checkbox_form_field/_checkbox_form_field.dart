// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AcnooCheckBoxFormField extends FormField<bool> {
  AcnooCheckBoxFormField({
    super.key,
    Widget? title,
    super.onSaved,
    super.validator,
    bool super.initialValue = false,
    super.autovalidateMode,
  }) : super(
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              title: title,
              value: state.value,
              onChanged: state.didChange,
              subtitle: state.hasError
                  ? Builder(
                      builder: (BuildContext context) => Text(
                        state.errorText ?? "",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  : null,
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            );
          },
        );
}
