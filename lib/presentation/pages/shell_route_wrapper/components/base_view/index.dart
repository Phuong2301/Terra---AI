// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/widgets/shadow_container/_shadow_container.dart';

class BaseView extends StatelessWidget {
  final Widget headerWidget;
  final Widget bodyWidget;
  final Widget mobileWidget;

  late ThemeData theme;
  late TextTheme textTheme;

  BaseView({
    super.key,
    required this.headerWidget,
    required this.bodyWidget,
    required this.mobileWidget,
  });

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    theme = Theme.of(context);
    textTheme = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final isMobile = constraints.maxWidth < 481;
              // final isTablet = constraints.maxWidth < 992 && constraints.maxWidth >= 481;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: _sizeInfo.padding, child: headerWidget),
                  isMobile
                  //  || isTablet
                      ? Expanded(child: mobileWidget)
                      : Expanded(
                          child: PrimaryScrollController.none(
                            child: SingleChildScrollView(
                              primary: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SingleChildScrollView(
                                primary: false,
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                  child: bodyWidget,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}