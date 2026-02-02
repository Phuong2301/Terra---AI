import 'package:app_mobile/presentation/pages/result/widgets/fpo/fpo_comparison_enhanced_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'risk_scoring.dart'; // LoanTerms, RiskScoreResult
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

  int _toInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? fallback;
  }

  double _toDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? fallback;
  }

  String _toStr(dynamic v, {String fallback = ''}) {
    final s = (v ?? '').toString().trim();
    return s.isEmpty ? fallback : s;
  }

  Map<String, dynamic>? _asMap(dynamic v) {
    if (v is Map) return v.cast<String, dynamic>();
    return null;
  }

  List<dynamic>? _asList(dynamic v) {
    if (v is List) return v;
    return null;
  }

  /// Read score map in a robust way:
  /// - flat: baseScore/finalScore at root
  /// - BE raw: score.{baseScore,finalScore,riskCategory,...}
  Map<String, dynamic>? _readScoreMap(Map<String, dynamic> p) {
    // 1) BE raw
    final s = _asMap(p['score']);
    if (s != null && (s['finalScore'] != null || s['baseScore'] != null)) return s;

    // 2) snapshot _be.score
    final be = _asMap(p['_be']);
    final beScore = _asMap(be?['score']);
    if (beScore != null && (beScore['finalScore'] != null || beScore['baseScore'] != null)) return beScore;

    return null;
  }

  /// LoanTerms BE -> LoanTerms model
  LoanTerms _loanTermsFromMap(Map<String, dynamic> m, {required bool isVi}) {
    // BE schema: recommendedAmount, interestRateAnnual, tenureMonths, estimatedMonthlyPayment/paymentCap (optional)
    final maxAmount = _toDouble(m['recommendedAmount'] ?? m['maxAmount']);
    final interest = _toDouble(m['interestRateAnnual'] ?? m['interestRate']);
    final tenure = _toInt(m['tenureMonths']);

    final repayment = _toStr(m['repayment']);
    if (repayment.isNotEmpty) {
      return LoanTerms(
        maxAmount: maxAmount,
        interestRate: interest,
        tenureMonths: tenure,
        repayment: repayment,
      );
    }

    // If BE provides estimatedMonthlyPayment/paymentCap, render a human string
    final estMonthly = _toDouble(m['estimatedMonthlyPayment']);
    final cap = _toDouble(m['paymentCap']);

    final repayText = (estMonthly > 0)
        ? (isVi
            ? '≈ ${estMonthly.toStringAsFixed(0)}/tháng (trần ${cap.toStringAsFixed(0)})'
            : '≈ ${estMonthly.toStringAsFixed(0)}/mo (cap ${cap.toStringAsFixed(0)})')
        : (isVi ? 'Hàng tháng' : 'Monthly');

    return LoanTerms(
      maxAmount: maxAmount,
      interestRate: interest,
      tenureMonths: tenure,
      repayment: repayText,
    );
  }

  /// Compose “reasoning text” from BE fields:
  /// - decisionReasons: [..]
  /// - explainable: { base, finalFormula }
  /// Fallback to flat reasoning if you stored it.
  String _buildReasoningText(
    Map<String, dynamic> p, {
    required bool isVi,
    required int baseScore,
    required int aiAdj,
    required int fpoBoost,
    required int finalScore,
  }) {
    // Try BE raw first
    final beDecisionReasons = _asList(p['decisionReasons']) ??
        _asList(_asMap(p['_be'])?['decisionReasons']);
    final beExplainable = _asMap(p['explainable']) ??
        _asMap(_asMap(p['_be'])?['explainable']);

    final lines = <String>[];

    if (beDecisionReasons != null && beDecisionReasons.isNotEmpty) {
      final reasons = beDecisionReasons.map((e) => e.toString()).toList();
      // Keep raw codes; you can map to localized labels later if needed.
      lines.add(isVi ? 'Lý do quyết định:' : 'Decision reasons:');
      for (final r in reasons) {
        lines.add('• $r');
      }
    }

    if (beExplainable != null && beExplainable.isNotEmpty) {
      final base = _toStr(beExplainable['base']);
      final formula = _toStr(beExplainable['finalFormula']);
      if (base.isNotEmpty) {
        lines.add('');
        lines.add(isVi ? 'Giải thích (BE):' : 'Explainable (BE):');
        lines.add(base);
      }
      if (formula.isNotEmpty) {
        lines.add(isVi ? 'Công thức: $formula' : 'Formula: $formula');
      }
    }

    // If BE had nothing, fallback to any stored free-text reasoning
    final stored = _toStr(p['reasoning']);
    if (lines.isEmpty && stored.isNotEmpty) return stored;

    // Final fallback
    if (lines.isEmpty) {
      return isVi
          ? 'Tóm tắt: Điểm cơ sở $baseScore, AI ${aiAdj >= 0 ? '+' : ''}$aiAdj, FPO +$fpoBoost, tổng $finalScore.'
          : 'Summary: base $baseScore, AI ${aiAdj >= 0 ? '+' : ''}$aiAdj, FPO +$fpoBoost, final $finalScore.';
    }

    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final langCode = Localizations.localeOf(context).languageCode;
    final isVi = langCode.toLowerCase().startsWith('vi');
    final lang = l.S.of(context);

    final p = payload ?? const <String, dynamic>{};

    // ======= READ ONLY (NO LOCAL EVALUATE) =======
    final name = (p['fullName'] ?? 'Farmer').toString();
    final isFpo = (p['isFpoMember'] ?? false) == true;

    // Prefer BE score map if available, else read flat keys
    final scoreMap = _readScoreMap(p);

    final baseScore = scoreMap != null ? _toInt(scoreMap['baseScore']) : _toInt(p['baseScore']);
    final aiAdj = scoreMap != null ? _toInt(scoreMap['aiAdjustment']) : _toInt(p['aiAdjustment']);
    final fpoBoost = scoreMap != null ? _toInt(scoreMap['fpoBoost']) : _toInt(p['fpoBoost']);
    final finalScore = scoreMap != null ? _toInt(scoreMap['finalScore']) : _toInt(p['finalScore']);

    // Category: prefer BE score.riskCategory, else flat riskCategory/category
    final category = scoreMap != null
        ? _toStr(scoreMap['riskCategory'])
        : _toStr(p['riskCategory'], fallback: _toStr(p['category']));

    // Recommendation: prefer stored field (flat). If missing, keep a minimal fallback.
    final recommendationStored = _toStr(p['recommendation']);
    final recText = recommendationStored.isNotEmpty
        ? recommendationStored
        : (isVi ? 'Khuyến nghị: xem chi tiết điều kiện vay bên dưới.' : 'Recommendation: see suggested terms below.');

    // Loan terms: prefer BE loanTerms if present, else flat loanTerms
    final loanTermsMap = _asMap(p['loanTerms']) ?? _asMap(_asMap(p['_be'])?['loanTerms']);
    final termsWith = (loanTermsMap != null)
        ? _loanTermsFromMap(loanTermsMap, isVi: isVi)
        : LoanTerms(
            maxAmount: 0,
            interestRate: 0,
            tenureMonths: 0,
            repayment: isVi ? 'N/A' : 'N/A',
          );

    // Optional without-FPO terms if controller/back-end provides it
    final loanTermsWithoutMap = _asMap(p['loanTermsWithout']);
    final termsWithout = (loanTermsWithoutMap != null)
        ? _loanTermsFromMap(loanTermsWithoutMap, isVi: isVi)
        : termsWith;

    final color = scoreColor(finalScore);

    // Reasoning: build from BE decisionReasons/explainable if possible
    final reasonText = _buildReasoningText(
      p,
      isVi: isVi,
      baseScore: baseScore,
      aiAdj: aiAdj,
      fpoBoost: fpoBoost,
      finalScore: finalScore,
    );

    // Share expects RiskScoreResult; we construct a “display-only” result.
    final shareResult = RiskScoreResult(
      baseScore: baseScore,
      aiAdjustment: aiAdj,
      fpoBoost: fpoBoost,
      finalScore: finalScore,
      category: category,
      recommendation: recText,
      reasoning: reasonText,
      termsWith: termsWith,
      termsWithout: termsWithout,
    );

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
          ResultsShareButton(payload: p, result: shareResult),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          ResultsHeaderCard(
            name: name,
            category: category,
            recommendation: recText,
            color: color,
            icon: scoreIcon(category),
          ),
          const SizedBox(height: 12),
          ScoreCircleCard(
            score: finalScore,
            color: color,
            category: category,
          ),
          const SizedBox(height: 12),
          BreakdownCard(
            base: baseScore,
            aiAdj: aiAdj,
            fpo: fpoBoost,
            finalScore: finalScore,
          ),
          const SizedBox(height: 12),
          LoanTermsCard(
            terms: termsWith,
            accent: color,
          ),
          const SizedBox(height: 12),
          FpoComparisonEnhancedCard(
            withFpo: termsWith,
            withoutFpo: termsWithout,
            isMember: isFpo,
            onJoinFpoTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Join FPO feature is not implemented yet.')),
              );
            },
          ),
          const SizedBox(height: 12),
          ReasoningCard(text: reasonText),
          const SizedBox(height: 14),
          const ResultsActionsRow(),
        ],
      ),
    );
  }
}
