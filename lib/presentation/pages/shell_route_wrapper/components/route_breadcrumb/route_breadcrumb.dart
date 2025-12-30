// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../../domain/core/static/static.dart';
import '../../models/models.dart';

class RouteBreadcrumbWidget extends StatelessWidget {
  const RouteBreadcrumbWidget({
    super.key,
    required this.breadcrumbModel,
  });
  final RouteBreadcrumbModel breadcrumbModel;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);

    final _breadcrumbTextStyle = _theme.textTheme.bodyLarge?.copyWith(
      fontSize: rf.ResponsiveValue<double?>(
        context,
        conditionalValues: const [
          rf.Condition.between(
            start: 0,
            end: 340,
            value: 12,
          ),
          rf.Condition.between(
            start: 341,
            end: 480,
            value: 14,
          )
        ],
      ).value,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Text(
          breadcrumbModel.title,
          style: _theme.textTheme.headlineSmall?.copyWith(
            fontSize: rf.ResponsiveValue<double?>(
              context,
              conditionalValues: const [
                rf.Condition.between(
                  start: 0,
                  end: 340,
                  value: 14,
                ),
                rf.Condition.between(
                  start: 341,
                  end: 480,
                  value: 18,
                )
              ],
            ).value,
            fontWeight: FontWeight.w600,
          ),
        ),

        if (_mqSize.width >= 576)
          // Current Route
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                // Home Navigation
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => context.go('/dashboard/ecommerce-admin'),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        IconlyLight.home,
                        size: rf.ResponsiveValue<double?>(
                          context,
                          conditionalValues: [
                            rf.Condition.smallerThan(
                              name: BreakpointName.LG.name,
                              value: 16,
                            ),
                          ],
                          defaultValue: 20,
                        ).value,
                      ),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: '/ ${breadcrumbModel.parentRoute} / ',
                    children: [
                      TextSpan(
                        text: breadcrumbModel.childRoute,
                        style: _breadcrumbTextStyle?.copyWith(
                          color: _theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  textDirection: TextDirection.ltr,
                  style: _breadcrumbTextStyle,
                )
              ],
            ),
          ),
      ],
    );
  }
}
