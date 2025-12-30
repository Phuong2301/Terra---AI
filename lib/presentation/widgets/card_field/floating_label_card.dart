import 'package:flutter/material.dart';
import 'package:app_mobile/generated/l10n.dart' as l;

class FloatingLabelCard extends StatelessWidget {
  final String? status;                      
  final String? lotId;                   
  final List<Widget>? trailing;            
  final List<Widget> children;             
  final EdgeInsets contentPadding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double labelRight;
  final double labelTop; 
  final VoidCallback? onPressed;

  const FloatingLabelCard({
    super.key,
    this.status = '',
    this.lotId = '',
    this.trailing,
    required this.children,
    this.contentPadding = const EdgeInsets.all(10),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.backgroundColor,
    this.borderColor,
    this.labelRight = 16,
    this.labelTop = -10,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            border: Border.all(color: borderColor ?? theme.colorScheme.outline),
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                children: [
                  if (lotId?.isNotEmpty == true)
                    Expanded(                           
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.code, size: 25, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Expanded(                      
                            child: Text(
                              lotId!,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,      
                    children: trailing ?? const <Widget>[],
                  ),
                ],
              ),
                ...children,
                if(status == '-1')
                RejectedBuild(onPressed: onPressed,)
              ],
            ),
          ),
        ),
        if(status != '') ...[
          Positioned(
            right: labelRight,
            top: labelTop,
            child: _FloatingBorderLabel(
              status: status ?? '',
            ),
          ),
        ]
      ],
    );
  }
}

class _FloatingBorderLabel extends StatelessWidget {
  const _FloatingBorderLabel({required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            getStatusLabel(status),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  getStatusColor(String status) {
    switch (status) {
      case '0':
        return Colors.orange;
      case '1':
        return Colors.green;
      case '-1':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  getStatusLabel(String status) {
    switch (status) {
      case '0':
        return "statusPending";
      case '1':
        return "statusApproved";
      case '-1':
        return "statusRejected";
      default:
        return "unknown";
    }
  }
}
class RejectedBuild extends StatelessWidget {
  final VoidCallback? onPressed;
  const RejectedBuild({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.current;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onPressed!();
          },
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red,),
              const SizedBox(width: 8,),
              Text(
                lang.seeDetail,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.red,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}