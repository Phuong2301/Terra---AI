import 'package:flutter/material.dart';

class AppExpandableField extends StatefulWidget {
  final String title;
  final String content;
  final Widget expandedChild;
  final bool initiallyExpanded;
  final Duration duration;
  final Curve curve;
  final IconData chevronIcon;
  final double chevronSize;
  final Color? chevronColor;
  final BorderRadiusGeometry borderRadius;
  final double? padding;

  const AppExpandableField({
    super.key,
    required this.title,
    required this.content,
    required this.expandedChild,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeInOut,
    this.chevronIcon = Icons.chevron_right,
    this.chevronSize = 18,
    this.chevronColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = 0,
  });

  @override
  State<AppExpandableField> createState() => _AppExpandableFieldState();
}

class _AppExpandableFieldState extends State<AppExpandableField>
    with TickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        customBorder:
            RoundedRectangleBorder(borderRadius: widget.borderRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.padding?? 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "${widget.title}: ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedRotation(
                          duration: widget.duration,
                          turns: _expanded ? 0.25 : 0.0,
                          curve: widget.curve,
                          child: Icon(
                            widget.chevronIcon,
                            size: widget.chevronSize,
                            color: widget.chevronColor ?? theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: widget.duration,
                  curve: widget.curve,
                  alignment: Alignment.topCenter,
                  child: _expanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: widget.expandedChild,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
