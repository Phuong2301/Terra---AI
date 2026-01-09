import 'package:flutter/material.dart';
import '../risk_scoring.dart';
import '../../../../generated/l10n.dart' as l;

class LoanTermsCard extends StatelessWidget {
  const LoanTermsCard({
    super.key,
    required this.terms,
    required this.accent,
  });

  final LoanTerms terms;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = l.S.of(context);

    Widget metric(String label, String value, IconData icon) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    final maxAmountText = '\$${terms.maxAmount.toStringAsFixed(0)}';
    final interestText = '${terms.interestRate.toStringAsFixed(1)}% / ${t.perYearShort}';
    final tenureText = '${terms.tenureMonths} ${t.monthsShort}';
    final repaymentText = terms.repayment; // đã dịch trong engine

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.recommendedLoanTermsTitle,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              metric(
                t.maxAmountLabel,
                maxAmountText,
                Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(width: 10),
              metric(
                t.interestLabel,
                interestText,
                Icons.percent_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              metric(
                t.tenureLabel,
                tenureText,
                Icons.date_range_outlined,
              ),
              const SizedBox(width: 10),
              metric(
                t.repaymentLabel,
                repaymentText,
                Icons.schedule_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
