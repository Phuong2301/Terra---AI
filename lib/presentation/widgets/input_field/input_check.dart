import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputCheck extends StatefulWidget {
  InputCheck(
      {super.key,
      required this.title,
      required this.initValue,
      required this.onChanged});

  bool initValue;
  final Function(bool) onChanged;
  final String title;

  @override
  State<InputCheck> createState() => _InputCheckState();
}

class _InputCheckState extends State<InputCheck> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox.square(
              dimension: 16,
              child: Checkbox(
                value: widget.initValue,
                onChanged: (value) {
                  setState(
                    () => widget.initValue = value!,
                  );
                  widget.onChanged(widget.initValue);
                },
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -2,
                ),
              ),
            ),
          ),
          const WidgetSpan(
            child: SizedBox(width: 10),
          ),
          TextSpan(
              text: widget.title,
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(
                    () => widget.initValue = !widget.initValue,
                  );
                  widget.onChanged(widget.initValue);
                }),
        ],
      ),
      style: theme.textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }
}
