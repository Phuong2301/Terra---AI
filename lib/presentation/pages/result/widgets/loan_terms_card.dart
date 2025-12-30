import 'package:flutter/material.dart';
import '../risk_scoring.dart';

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
              Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
      );
    }

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
          const Text('Recommended Loan Terms',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              metric('Max amount', '\$${terms.maxAmount.toStringAsFixed(0)}',
                  Icons.account_balance_wallet_outlined),
              const SizedBox(width: 10),
              metric('Interest', '${terms.interestRate.toStringAsFixed(1)}% / yr',
                  Icons.percent_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              metric('Tenure', '${terms.tenureMonths} months', Icons.date_range_outlined),
              const SizedBox(width: 10),
              metric('Repayment', terms.repayment, Icons.schedule_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
