import 'package:flutter/material.dart';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';
import 'package:app_mobile/presentation/widgets/validators/validators.dart';

typedef OnSelect = void Function(String? value);

class InputSelect extends StatefulWidget {
  const InputSelect({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    this.index,
    this.isDisable = false,
    this.required = false,
    this.rules,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    required this.onChange,
  });

  final String label;
  final String hintText;
  final List<String> items;
  final String? index;
  final bool isDisable;
  final bool required;
  final List<Rule<String?>>? rules;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final OnSelect onChange;

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  String? _value;

  bool get _locked => widget.isDisable;
  bool get _effectiveRequired => widget.required && !_locked;
  AutovalidateMode get _autoMode =>
      _locked ? AutovalidateMode.disabled : widget.autovalidateMode;

  @override
  void initState() {
    super.initState();
    _value = widget.index;
  }

  @override
  void didUpdateWidget(covariant InputSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _value = widget.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodySmall;

    final label = !_effectiveRequired
        ? Text(widget.label, style: base)
        : Text.rich(
            TextSpan(
              text: widget.label,
              style: base,
              children: [
                TextSpan(
                  text: ' *',
                  style: base?.copyWith(color: theme.colorScheme.error),
                ),
              ],
            ),
          );

    final List<Rule<String?>> effectiveRules = [
      if (_effectiveRequired) V.selectRequired(),
      if (!_locked) V.indexInRange(widget.items.length),
      ...?widget.rules,
    ];

    String? effectiveValidator(String? v) {
      if (_locked) return null;

      if (widget.validator != null) {
        return widget.validator!(v);
      }
      return effectiveRules.isEmpty ? null : V.firstError<String?>(v, effectiveRules);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _value,
          hint: Text(widget.hintText, style: base),
          autovalidateMode: _autoMode,             
          decoration: const InputDecoration(),
          items: widget.items.asMap().entries.map((e) {
            final idxStr = e.key.toString();
            return DropdownMenuItem<String>(
              value: idxStr,
              child: Text(
                e.value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _locked ? AcnooAppColors.kNeutral500 : null,
                ),
              ),
            );
          }).toList(),
          onChanged: _locked
              ? null                                  
              : (val) {
                  setState(() => _value = val);
                  widget.onChange(val);
                },
          validator: effectiveValidator,             
        ),
      ],
    );
  }
}
