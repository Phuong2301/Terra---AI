// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../../domain/core/static/static.dart';
import '../../../domain/core/theme/theme.dart';

class BuyPlanWidget extends StatelessWidget {
  const BuyPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lang =
        l.S.of(context);
    final _theme = Theme.of(context);
    final _innerPadding = responsiveValue<double>(
      context,
      xs: 16,
      md: 18,
      lg: 24,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(AcnooStaticImage.bannerImage01),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: _innerPadding,
          vertical: _innerPadding * 1.15,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xffFF1CF7).withOpacity(0.2),
              const Color(0xff00F0FF).withOpacity(0.2),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.helloShaidulIslam,
             // 'Hello, Shaidul Islam',
              style: _theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AcnooAppColors.kBlackColor,
                fontSize: responsiveValue<double?>(
                  context,
                  xs: 20,
                  md: 22,
                  lg: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
               TextSpan(
                //text: 'Your Account is currently ',
                text:lang.yourAccountIsCurrently,
                children: [
                  TextSpan(
                    //text: 'Free Plan',
                    text:lang.freePlan,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AcnooAppColors.kSuccess,
                    ),
                  ),
                ],
              ),
              style: _theme.textTheme.bodyLarge?.copyWith(
                color: AcnooAppColors.kNeutral700,
                fontSize: responsiveValue<double?>(
                  context,
                  xs: 12,
                  md: 14,
                  lg: 16,
                ),
              ),
            ),
            SizedBox(
              height: responsiveValue<double>(
                context,
                xs: 8,
                md: 12,
                lg: 16,
              ),
            ),
            IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    //child: const Text('Upgrade Plan'),
                    child:  Text(lang.upgradePlan),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                    ),
                   // child: const Text('Buy Credits'),
                    child:  Text(lang.buyCredits),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
