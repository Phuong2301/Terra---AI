// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../../domain/configs/app_config.dart';
import '../../../../../domain/core/static/static.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _textStyle = _theme.textTheme.bodyMedium?.copyWith(
      fontSize: rf.ResponsiveValue<double?>(
        context,
        conditionalValues: const [
          rf.Condition.between(start: 0, end: 290, value: 11),
          rf.Condition.between(start: 291, end: 340, value: 12),
        ],
      ).value,
    );

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: rf.ResponsiveValue<EdgeInsetsGeometry?>(
          context,
          conditionalValues: [
            rf.Condition.smallerThan(
              name: BreakpointName.LG.name,
              value: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ],
          defaultValue: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 18,
          ),
        ).value,
        color: _theme.colorScheme.primaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${lang.COPYRIGHT} © ${lang.year} ${AppConfig.organizationName}${constraints.maxWidth <= BreakpointName.SM.start ? '' : ', ${lang.allRightsReserved}'}',
                style: _textStyle,
              ),
            ),
            Builder(
              builder: (context) {
                final _translatedLang =
                    lang.madeWithFooter(AppConfig.organizationName);

                //const _heart = '❤';
                final List<String> parts =
                    _translatedLang.split(RegExp(r'(?=\s)|(?<=\s)'));

                return Text.rich(
                  TextSpan(
                    children: parts.map((e) {
                      //final _trimmedText = e.trim();

                      return TextSpan(
                        text: e,
                        // style: TextStyle(
                        //   color: switch (_trimmedText) {
                        //     _heart => Colors.red,
                        //     AppConfig.organizationName =>
                        //       _theme.colorScheme.primary,
                        //     _ => null,
                        //   },
                        //   fontWeight: switch (_trimmedText) {
                        //     AppConfig.organizationName => FontWeight.w500,
                        //     _ => null,
                        //   },
                        // ),
                      );
                    }).toList(),
                  ),
                  style: _textStyle,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
