// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';
import 'package:app_mobile/generated/l10n.dart' as l;

class AppRefreshButton extends StatelessWidget {
  const AppRefreshButton({
    super.key,
    required this.onAction,
  });
  final Function() onAction;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        backgroundColor: AcnooAppColors.kPrimary.withOpacity(0.6),
      ),
      onPressed: () => onAction(),
      label: Text(
        l.S.current.refresh,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.refresh,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }
}

class RefreshButton extends StatefulWidget {
  const RefreshButton({
    super.key,
    required this.onAction,
    this.minSpinner = const Duration(seconds: 1),
  });

  final FutureOr<void> Function() onAction;
  final Duration minSpinner;

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  bool _loading = false;

  Future<void> _handlePress() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final action = Future.sync(() => widget.onAction());
      await Future.wait([
        action,
        Future.delayed(widget.minSpinner),
      ]);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: const Color.fromARGB(255, 184, 184, 184),    
          disabledBackgroundColor: const Color.fromARGB(255, 239, 238, 238), 
          elevation: 0,
        ),
        onPressed: _loading ? null : _handlePress,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _loading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(
                  Icons.refresh,
                  key: ValueKey('icon'),
                  size: 20,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}

class AppAddButton extends StatelessWidget {
  const AppAddButton({
    super.key,
    required this.onAction,
    this.lable,
  });
  final String? lable;
  final Function() onAction;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () => onAction(),
      label: Text(
        lable ?? l.S.current.add,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }
}

class AppApplyButton extends StatelessWidget {
  const AppApplyButton({
    super.key,
    required this.onAction,
  });
  final Function() onAction;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        backgroundColor: AcnooAppColors.kPrimary.withOpacity(0.6),
      ),
      onPressed: () => onAction(),
      label: Text(
        l.S.current.apply,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.refresh,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }
}
