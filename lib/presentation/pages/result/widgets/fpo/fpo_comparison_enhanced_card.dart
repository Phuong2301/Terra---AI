import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/pages/result/risk_scoring.dart';
import '../../../../../generated/l10n.dart' as l;

class FpoComparisonEnhancedCard extends StatelessWidget {
  const FpoComparisonEnhancedCard({
    super.key,
    required this.withFpo,
    required this.withoutFpo,
    required this.isMember,
    this.onJoinFpoTap,
  });

  final LoanTerms withFpo;
  final LoanTerms withoutFpo;
  final bool isMember;
  final VoidCallback? onJoinFpoTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = l.S.of(context);

    final good = const Color(0xFF16A34A);
    final goodBg = good.withOpacity(0.10);

    // ===== Calculations =====
    final maxAmountDiff = withFpo.maxAmount - withoutFpo.maxAmount;
    final rateDiff = withoutFpo.interestRate - withFpo.interestRate;
    final tenureDiff = withFpo.tenureMonths - withoutFpo.tenureMonths;
    final savings = _estimateSavingsUSD(withFpo: withFpo, withoutFpo: withoutFpo);

    final withBetterAmount = withFpo.maxAmount > withoutFpo.maxAmount;
    final withBetterInterest = withFpo.interestRate < withoutFpo.interestRate;
    final withBetterTenure = withFpo.tenureMonths > withoutFpo.tenureMonths;
    final repaymentSame = withFpo.repayment.trim() == withoutFpo.repayment.trim();

    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final labelW = w < 360 ? 108.0 : 130.0;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.fpoBenefitsTitle,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                isMember ? t.fpoMemberHint : t.fpoNonMemberHint,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12, height: 1.25),
              ),

              const SizedBox(height: 12),

              // ===== Table =====
              Table(
                columnWidths: {
                  0: FixedColumnWidth(labelW),
                  1: const FlexColumnWidth(1),
                  2: const FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      const SizedBox(),
                      _headerCell(
                        context,
                        title: t.withFpo,
                        highlight: true,
                        good: good,
                        goodBg: goodBg,
                      ),
                      _headerCell(
                        context,
                        title: t.withoutFpo,
                        highlight: false,
                        good: good,
                        goodBg: goodBg,
                      ),
                    ],
                  ),

                  _spacerRow(height: 10),

                  _metricRow(
                    context,
                    label: t.maxAmountLabel,
                    withValue: '\$${withFpo.maxAmount.toStringAsFixed(0)}',
                    withoutValue: '\$${withoutFpo.maxAmount.toStringAsFixed(0)}',
                    withBetter: withBetterAmount,
                    withoutBetter: !withBetterAmount && withFpo.maxAmount < withoutFpo.maxAmount,
                    good: good,
                    labelW: labelW,
                  ),

                  _spacerRow(height: 10),

                  _metricRow(
                    context,
                    label: t.interestLabel,
                    withValue: '${withFpo.interestRate.toStringAsFixed(1)}% / ${t.perYearShort}',
                    withoutValue: '${withoutFpo.interestRate.toStringAsFixed(1)}% / ${t.perYearShort}',
                    withBetter: withBetterInterest,
                    withoutBetter:
                        !withBetterInterest && withFpo.interestRate > withoutFpo.interestRate,
                    good: good,
                    labelW: labelW,
                  ),

                  _spacerRow(height: 10),

                  _metricRow(
                    context,
                    label: t.tenureLabel,
                    withValue: '${withFpo.tenureMonths} ${t.monthsShort}',
                    withoutValue: '${withoutFpo.tenureMonths} ${t.monthsShort}',
                    withBetter: withBetterTenure,
                    withoutBetter:
                        !withBetterTenure && withFpo.tenureMonths < withoutFpo.tenureMonths,
                    good: good,
                    labelW: labelW,
                  ),

                  _spacerRow(height: 10),

                  _metricRow(
                    context,
                    label: t.repaymentLabel,
                    withValue: withFpo.repayment,
                    withoutValue: withoutFpo.repayment,
                    withBetter: false,
                    withoutBetter: false,
                    good: good,
                    labelW: labelW,
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Divider(color: cs.outlineVariant.withOpacity(0.35)),
              const SizedBox(height: 10),

              // ===== Savings =====
              if (savings > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: goodBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: good.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.savings_rounded, color: good),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isMember
                              ? t.fpoSavingsMember(savings.toStringAsFixed(0))
                              : t.fpoSavingsNonMember(savings.toStringAsFixed(0)),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  t.noSavingsHint,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                ),

              // ===== Encourage join =====
              if (!isMember) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        t.joinFpoEncourage,
                        style:
                            TextStyle(color: cs.onSurfaceVariant, fontSize: 12, height: 1.2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: onJoinFpoTap ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(t.joinFpoActionFallback)),
                            );
                          },
                      icon: const Icon(Icons.group_add_rounded, size: 18),
                      label: Text(t.joinFpoAction),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 10),

              // ===== Quick diff chips =====
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _diffChip(
                    context,
                    label: t.amountLabel,
                    diffText: _fmtMoneyDiff(maxAmountDiff),
                    goodWhenPositive: true,
                  ),
                  _diffChip(
                    context,
                    label: t.interestLabel,
                    diffText: _fmtRateDiff(rateDiff),
                    goodWhenPositive: true,
                  ),
                  _diffChip(
                    context,
                    label: t.tenureLabel,
                    diffText: _fmtMonthsDiff(tenureDiff),
                    goodWhenPositive: true,
                  ),
                  _diffChip(
                    context,
                    label: t.repaymentLabel,
                    diffText: repaymentSame ? t.sameText : t.differentText,
                    goodWhenPositive: false,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ===== Helpers =====

  static TableRow _spacerRow({required double height}) =>
      TableRow(children: [SizedBox(height: height), SizedBox(height: height), SizedBox(height: height)]);

  static Widget _headerCell(
    BuildContext context, {
    required String title,
    required bool highlight,
    required Color good,
    required Color goodBg,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: highlight ? goodBg : cs.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? good.withOpacity(0.45) : cs.outlineVariant.withOpacity(0.25),
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: highlight ? good : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  static TableRow _metricRow(
    BuildContext context, {
    required String label,
    required String withValue,
    required String withoutValue,
    required bool withBetter,
    required bool withoutBetter,
    required Color good,
    required double labelW,
  }) {
    final cs = Theme.of(context).colorScheme;

    return TableRow(
      children: [
        SizedBox(
          width: labelW,
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.15,
            ),
          ),
        ),
        _valueCell(context, value: withValue, better: withBetter, good: good),
        _valueCell(context, value: withoutValue, better: withoutBetter, good: good),
      ],
    );
  }

  static Widget _valueCell(
    BuildContext context, {
    required String value,
    required bool better,
    required Color good,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: better ? good.withOpacity(0.10) : cs.surfaceContainerHighest.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: better ? good.withOpacity(0.40) : cs.outlineVariant.withOpacity(0.20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (better) ...[
            Icon(Icons.trending_up_rounded, size: 16, color: good),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    height: 1.1,
                    color: better ? good : cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _diffChip(
    BuildContext context, {
    required String label,
    required String diffText,
    required bool goodWhenPositive,
  }) {
    final cs = Theme.of(context).colorScheme;
    final good = const Color(0xFF16A34A);
    final bad = const Color(0xFFDC2626);

    final isPositive = diffText.startsWith('+');
    final isNegative = diffText.startsWith('-');

    final Color tone = (goodWhenPositive && isPositive)
        ? good
        : (goodWhenPositive && isNegative)
            ? bad
            : cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
      ),
      child: Text(
        '$label: $diffText',
        style: TextStyle(fontWeight: FontWeight.w800, color: tone, fontSize: 11, height: 1.1),
      ),
    );
  }

  static double _estimateInterest(double principal, double annualRatePct, int months) {
    final r = annualRatePct / 100.0;
    return principal * r * (months / 12.0);
  }

  static double _estimateSavingsUSD({required LoanTerms withFpo, required LoanTerms withoutFpo}) {
    final iWith = _estimateInterest(withFpo.maxAmount, withFpo.interestRate, withFpo.tenureMonths);
    final iWithout =
        _estimateInterest(withoutFpo.maxAmount, withoutFpo.interestRate, withoutFpo.tenureMonths);
    final s = iWithout - iWith;
    return s.isFinite ? (s > 0 ? s : 0) : 0;
  }

  static String _fmtMoneyDiff(double diff) {
    final d = diff.round();
    if (d == 0) return '0';
    return d > 0 ? '+\$$d' : '-\$${d.abs()}';
  }

  static String _fmtRateDiff(double diff) {
    if (diff.abs() < 0.05) return '0%';
    return diff > 0 ? '-${diff.toStringAsFixed(1)}%' : '+${diff.abs().toStringAsFixed(1)}%';
  }

  static String _fmtMonthsDiff(int diff) {
    if (diff == 0) return '0m';
    return diff > 0 ? '+${diff}m' : '-${diff.abs()}m';
  }
}
