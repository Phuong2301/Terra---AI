import 'package:flutter/material.dart';

class PdfLoadingDialog extends StatelessWidget {
  const PdfLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Preparing PDF'),
      content: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Expanded(child: Text('Generating report…')),
        ],
      ),
    );
  }
}
