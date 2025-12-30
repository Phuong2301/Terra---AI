import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CounterField extends StatefulWidget {
  const CounterField({super.key, this.validator, this.controller});
  final String? Function(String? value)? validator;
  final TextEditingController? controller;

  @override
  State<CounterField> createState() => _CounterFieldState();
}

class _CounterFieldState extends State<CounterField> {
  int count = 0;
  late final _newController = widget.controller ?? TextEditingController();

  final _iconConstraint = BoxConstraints.tight(const Size.square(44));
  @override
  void initState() {
    super.initState();
    widget.controller?.text = count.toString();
  }

  @override
  void dispose() {
    _newController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _border = _theme.inputDecorationTheme.enabledBorder?.copyWith(
      borderSide: BorderSide(color: _theme.colorScheme.outline),
    );

    return TextFormField(
      controller: _newController,
      clipBehavior: Clip.antiAlias,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 13.53),
        enabledBorder: _border,
        focusedBorder: _border,
        prefixIcon: _ActionButton(
          borderRadius: const BorderRadiusDirectional.horizontal(
            start: Radius.circular(4),
          ),
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (count > 0) {
              setState(() => count -= 1);
            }
            _newController.text = count.toString();
          },
        ),
        prefixIconConstraints: _iconConstraint,
        suffixIcon: _ActionButton(
          borderRadius: const BorderRadiusDirectional.horizontal(
            end: Radius.circular(4),
          ),
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() => count += 1);
            _newController.text = count.toString();
          },
        ),
        suffixIconConstraints: _iconConstraint,
      ),
      onChanged: (value) {
        final _v = int.tryParse(value) ?? 0;
        setState(() => count = _v);
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: widget.validator,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    this.borderRadius = BorderRadius.zero,
    this.onPressed,
    required this.icon,
  });
  final BorderRadiusGeometry borderRadius;
  final void Function()? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return IconButton.outlined(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        side: BorderSide(
          width: 1.25,
          color: _theme.colorScheme.outline,
        ),
      ),
      icon: icon,
    );
  }
}
