import 'package:app_mobile/presentation/pages/result/widgets/fpo/fpo_comparison_enhanced_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'risk_scoring.dart';
import 'results_helpers.dart';

import 'widgets/results_header_card.dart';
import 'widgets/score_circle_card.dart';
import 'widgets/breakdown_card.dart';
import 'widgets/loan_terms_card.dart';
import 'widgets/reasoning_card.dart';
import 'widgets/actions_row.dart';
import 'widgets/results_share_button.dart';
import '../../../../generated/l10n.dart' as l;

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, this.payload});

  final Map<String, dynamic>? payload;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final p = payload ?? const <String, dynamic>{};
    final langCode = Localizations.localeOf(context).languageCode;
    final result = RiskScoringEngine.evaluate(p, langCode: langCode);
    final color = scoreColor(result.finalScore);
    final name = (p['fullName'] ?? 'Farmer').toString();
    final isFpo = (p['isFpoMember'] ?? false) == true;
    final lang = l.S.of(context);

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(lang.results),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          ResultsShareButton(payload: p, result: result),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          ResultsHeaderCard(
            name: name,
            category: result.category,
            recommendation: result.recommendation,
            color: color,
            icon: scoreIcon(result.category),
          ),
          const SizedBox(height: 12),

          ScoreCircleCard(
            score: result.finalScore,
            color: color,
            category: result.category,
          ),
          const SizedBox(height: 12),

          BreakdownCard(
            base: result.baseScore,
            aiAdj: result.aiAdjustment,
            fpo: result.fpoBoost,
            finalScore: result.finalScore,
          ),
          const SizedBox(height: 12),

          LoanTermsCard(
            terms: result.termsWith,
            accent: color,
          ),
          const SizedBox(height: 12),

          FpoComparisonEnhancedCard(
            withFpo: result.termsWith,
            withoutFpo: result.termsWithout,
            isMember: isFpo,
            onJoinFpoTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Join FPO feature is not implemented yet.')),
              );
              // context.push('/fpo-info'); // nếu bạn có route
            },
          ),
          const SizedBox(height: 12),

          ReasoningCard(text: result.reasoning),
          const SizedBox(height: 14),

          const ResultsActionsRow(),
        ],
      ),
    );
  }
}
