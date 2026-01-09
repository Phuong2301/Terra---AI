import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../risk_scoring.dart';
import '../../../../generated/l10n.dart' as l;

class ShareResultCard extends StatelessWidget {
  const ShareResultCard({
    super.key,
    required this.payload,
    required this.result,
    required this.appDownloadUrl,
  });

  final Map<String, dynamic> payload;
  final RiskScoreResult result;
  final String appDownloadUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = l.S.of(context);

    // ---- Extract data ----
    final name = (payload['fullName'] ?? t.farmerDefaultName).toString();
    final province = (payload['province'] ?? '').toString().trim();
    final district = (payload['district'] ?? '').toString().trim();
    final location = _join2(province, district);

    final createdAt =
        DateTime.tryParse((payload['createdAt'] ?? '').toString()) ?? DateTime.now();
    final dateText = _fmtDate(createdAt);

    final score = result.finalScore;
    final scoreColor = _scoreColor(score);
    final terms = result.termsWith;

    // AI adjustment text
    final aiAdj = result.aiAdjustment;
    final aiAdjText = t.aiAdjusted(aiAdj);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 1200,
        height: 630,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scoreColor.withOpacity(0.16),
              cs.surface,
              cs.surface,
            ],
          ),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            // ===== LEFT: content =====
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + AI version
                  Row(
                    children: [
                      _brandPill(cs, t.shareBrandName),
                      const SizedBox(width: 10),
                      _brandPill(cs, t.shareAiModelVersion),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Headline
                  Text(
                    t.shareHeadline,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name + date + location
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.shareMetaLine(
                      dateText,
                      location.isEmpty ? t.mekongRegion : location,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Score big block
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: scoreColor.withOpacity(0.35)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              '$score',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: scoreColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.category, // already localized by engine
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: scoreColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.recommendation, // already localized by engine
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                aiAdjText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Loan terms mini cards
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _miniMetric(
                        cs,
                        t.maxAmountLabel,
                        '\$${terms.maxAmount.toStringAsFixed(0)}',
                      ),
                      _miniMetric(
                        cs,
                        t.interestLabel,
                        '${terms.interestRate.toStringAsFixed(1)}% / ${t.perYearShort}',
                      ),
                      _miniMetric(
                        cs,
                        t.tenureLabel,
                        '${terms.tenureMonths} ${t.monthsShort}',
                      ),
                      _miniMetric(
                        cs,
                        t.repaymentLabel,
                        terms.repayment, // already localized by engine
                      ),
                    ],
                  ),

                  const Spacer(),

                  // CTA
                  Text(
                    t.shareCtaTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.shareCtaSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 18),

            // ===== RIGHT: QR + small caption =====
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: cs.outlineVariant.withOpacity(0.30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      t.downloadAppTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: QrImageView(
                            data: appDownloadUrl,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      t.shareBrandName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _brandPill(ColorScheme cs, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: cs.onSurface,
        ),
      ),
    );
  }

  static Widget _miniMetric(ColorScheme cs, String label, String value) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  static Color _scoreColor(int score) {
    if (score >= 75) return const Color(0xFF16A34A);
    if (score >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFDC2626);
  }

  static String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  static String _join2(String a, String b) {
    if (a.isEmpty && b.isEmpty) return '';
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    return '$a • $b';
  }
}
