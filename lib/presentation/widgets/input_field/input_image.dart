import 'package:flutter/material.dart';
import 'package:app_mobile/domain/helpers/main_helpers.dart';
import 'package:app_mobile/presentation/widgets/input_field/input_text.dart';

class InputImage extends StatefulWidget {
  const InputImage({super.key, required this.controller, required this.label, this.onPressed});
  final TextEditingController controller;
  final String label;
  final Function? onPressed;

  @override
  State<InputImage> createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputText(
          label: widget.label,
          controller: widget.controller,
          onChanged: (value) {
            setState(() {
              widget.controller.text = value;
            });
          },
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            if(widget.onPressed == null) return;
            widget.onPressed!();
          },
          child: SizedBox(
            height: 120,
            width: 160,
            child: Image.network(
              checkImagePath(widget.controller.text),
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 60,);
              },
            ),
          ),
        ),
      ],
    );
  }
}
