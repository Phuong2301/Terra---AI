import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart' as l;

class DataTablePaginator extends StatelessWidget {
  const DataTablePaginator({
    super.key,
    this.currentPage = 0,
    this.totalPages = 0,
    this.onPreviousTap,
    this.onNextTap,
  });
  final int currentPage;
  final int totalPages;
  final void Function()? onPreviousTap;
  final void Function()? onNextTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);

    final _buttonStyle = OutlinedButton.styleFrom(
      side: BorderSide(color: _theme.colorScheme.outline),
      minimumSize: const Size(88, 32),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.horizontal(
          start: Radius.circular(4),
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: onPreviousTap,
          style: _buttonStyle,
          child: Text(_lang.previous, style: _theme.textTheme.bodySmall),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          height: 32,
          decoration: BoxDecoration(color: _theme.colorScheme.primary),
          child: Center(
            child: Text(
              currentPage.toString(),
              style: _theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          constraints: const BoxConstraints.tightFor(height: 32),
          decoration: BoxDecoration(
            color: _theme.colorScheme.primaryContainer,
            border: Border.all(color: _theme.colorScheme.outline),
          ),
          alignment: Alignment.center,
          child: Text(
            totalPages.toString(),
            style: _theme.textTheme.bodySmall,
          ),
        ),
        OutlinedButton(
          onPressed: onNextTap,
          style: _buttonStyle.copyWith(
            shape: WidgetStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.horizontal(
                  end: Radius.circular(4),
                ),
              ),
            ),
          ),
          child: Text(_lang.next, style: _theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}
