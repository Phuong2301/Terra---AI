// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:intl/intl.dart' as intl;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../../domain/core/theme/theme.dart';

class OverviewCardWidget extends StatelessWidget {
  const OverviewCardWidget({
    super.key,
    required this.title,
    required this.value,
    this.showCompactValue = false,
    this.fluctuationAmount = 0,
    this.showCompactFluctuation = false,
    this.fluctuationFrequency,
    this.cardColor,
    this.fluctuationBgDecoration,
    this.fluctuationBgPadding,
    this.hasIncreases = true,
    this.customCurrency,
    this.showCurrency = true,
  });
  final String title;
  final num value;
  final bool showCompactValue;
  final num fluctuationAmount;
  final bool showCompactFluctuation;
  final String? fluctuationFrequency;

  final Color? cardColor;
  final Decoration? fluctuationBgDecoration;
  final EdgeInsetsGeometry? fluctuationBgPadding;
  final bool hasIncreases;
  final String? customCurrency;
  final bool showCurrency;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _locale = Localizations.localeOf(context);
    final _currency = customCurrency ??
        intl.NumberFormat.simpleCurrency(locale: _locale.countryCode)
            .currencySymbol;

    final _fluctuationColor =
        hasIncreases ? AcnooAppColors.kSuccess : AcnooAppColors.kError;

    final _value = showCompactValue
        ? intl.NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol: showCurrency ? _currency : '',
          ).format(value)
        : intl.NumberFormat.currency(
            decimalDigits: 0,
            symbol: showCurrency ? _currency : '',
          ).format(value);

    final _fluctuationAmount = showCompactFluctuation
        ? intl.NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol: showCurrency ? _currency : '',
          ).format(fluctuationAmount)
        : intl.NumberFormat.currency(
            decimalDigits: 0,
            symbol: showCurrency ? _currency : '',
          ).format(fluctuationAmount);

    return Card(
      color: cardColor ?? _theme.colorScheme.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Value
            Text(
              _value,
              style: _theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AcnooAppColors.kNeutral900,
              ),
            ),
            const SizedBox(height: 4),

            // Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AcnooAppColors.kNeutral700,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: fluctuationBgPadding ?? const EdgeInsets.all(8),
              decoration: fluctuationBgDecoration ??
                  BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
              child: Row(
                children: [
                  Icon(
                    hasIncreases
                        ? FeatherIcons.arrowUp
                        : FeatherIcons.arrowDown,
                    size: 14,
                    color: _fluctuationColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _fluctuationAmount,
                      style: _theme.textTheme.bodyMedium?.copyWith(
                        color: _fluctuationColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        fluctuationFrequency ?? l.S.current.thisMonth,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _theme.textTheme.bodyMedium?.copyWith(
                          color: AcnooAppColors.kNeutral700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
