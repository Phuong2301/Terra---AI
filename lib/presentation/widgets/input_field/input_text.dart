import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:app_mobile/domain/core/theme/_app_colors.dart';
import 'package:app_mobile/presentation/widgets/validators/validators.dart';

class InputText extends StatelessWidget {
  const InputText({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.required = false,                     
    this.rules,                                
    this.validator,                            
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType = TextInputType.text,
    this.maxlines = 1,
    this.isReadOnly = false,
    this.enabled = true,                       
    this.inputFormatters,                      
    this.textInputAction,
    this.onChanged,
    this.onTapOutside,
  });

  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool required;                                
  final List<Rule<String?>>? rules;                   
  final String? Function(String?)? validator;          
  final AutovalidateMode autovalidateMode;
  final TextInputType keyboardType;
  final int maxlines;
  final bool isReadOnly;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;    
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTapOutside;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<Rule<String?>> effectiveRules = [
      if (required) V.required(),
      ...?rules,
    ];

    final String? Function(String?)? effectiveValidator =
        validator ??
        (effectiveRules.isEmpty
            ? null
            : (v) => V.firstError<String?>(v, effectiveRules));
    final base = textTheme.bodySmall;
    final labelWidget = !required
      ? Text(label, style: base)
      : Text.rich(TextSpan(
          text: label, style: base,
          children: [TextSpan(text: ' *', style: base?.copyWith(color: Theme.of(context).colorScheme.error))],
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        const SizedBox(height: 8),
        TextFormField(
          enabled: enabled,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          controller: controller,
          style: TextStyle(color: isReadOnly ? AcnooAppColors.kNeutral500 : null),
          maxLines: maxlines,
          autovalidateMode: autovalidateMode,
          decoration: InputDecoration(
            hintText: hintText ?? label,
            hintStyle: textTheme.bodySmall,
          ),
          validator: effectiveValidator,                 
          onChanged: onChanged,
          onTapOutside: (_) => onTapOutside?.call(),     
        ),
      ],
    );
  }
}
