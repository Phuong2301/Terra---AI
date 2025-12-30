// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 🌎 Project imports:
import '../../../domain/core/theme/theme.dart';
import '_shape.dart';

class OverviewCardWidget2 extends StatelessWidget {
  const OverviewCardWidget2({
    super.key,
    required this.containerColor,
    required this.containerIcon,
    required this.title,
    required this.subTitle,
    required this.text,
    this.bottomIcon,
    required this.progressColor,
    required this.progressBackgroundColor,
    required this.percentValue,
  });
  final Color containerColor;
  final Widget containerIcon;
  final String title;
  final String subTitle;
  final String text;
  final Widget? bottomIcon;
  final Color progressColor;
  final Color progressBackgroundColor;
  final double percentValue;

  @override
  Widget build(BuildContext context) {
    final titleSize = responsiveValue<double>(
      context,
      xs: 18,
      md: 20,
      lg: 20,
    );
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    final theme = Theme.of(context);
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final bottomTextSize = rf.ResponsiveValue<double?>(context,
        conditionalValues: [
          const rf.Condition.between(start: 280, end: 350, value: 12)
        ]).value;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.primaryContainer,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                      offset: const Offset(0, 4),
                      color: const Color(0xffC3D0E4).withOpacity(0.3),
                      blurRadius: 24)
              ]),
          child: Padding(
            padding: EdgeInsets.all(_padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: titleSize,
                    ),
                  ),
                  subtitle: Text(
                    subTitle,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        color: theme.colorScheme.onTertiary),
                  ),
                  trailing: CustomPaint(
                    // size: const Size(80, 80 * 10),
                    painter: HexagonShape(
                      color: containerColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 16, 14, 0),
                      child: containerIcon,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (bottomIcon != null) bottomIcon!,
                      Flexible(
                        child: Text(
                          text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: bottomTextSize,
                              color: isDark
                                  ? AcnooAppColors.kNeutral200
                                  : AcnooAppColors.kNeutral500),
                        ),
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: percentValue,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                        backgroundColor: progressBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
