import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/l10n.dart' as l;

class AiProcessingScreen extends StatefulWidget {
  const AiProcessingScreen({
    super.key,
    required this.farmersCount,
    required this.duration,
    required this.nextRoutePath,
    this.payload,
  });

  final int farmersCount;
  final Duration duration;
  final String nextRoutePath;
  final Map<String, dynamic>? payload;

  @override
  State<AiProcessingScreen> createState() => _AiProcessingScreenState();
}

class _AiProcessingScreenState extends State<AiProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;
  Timer? _t1;
  Timer? _t2;
  Timer? _t3;
  Timer? _done;

  bool _step1 = false;
  bool _step2 = false;
  bool _step3 = false;

  @override
  void initState() {
    super.initState();

    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    final totalMs = widget.duration.inMilliseconds.clamp(5000, 10000);
    final t1 = (totalMs * 0.22).round();
    final t2 = (totalMs * 0.52).round();
    final t3 = (totalMs * 0.78).round();

    _t1 = Timer(Duration(milliseconds: t1), () {
      if (!mounted) return;
      setState(() => _step1 = true);
    });
    _t2 = Timer(Duration(milliseconds: t2), () {
      if (!mounted) return;
      setState(() => _step2 = true);
    });
    _t3 = Timer(Duration(milliseconds: t3), () {
      if (!mounted) return;
      setState(() => _step3 = true);
    });

    _done = Timer(Duration(milliseconds: totalMs), () {
      if (!mounted) return;
      context.go(widget.nextRoutePath, extra: widget.payload);
    });
  }

  @override
  void dispose() {
    _spin.dispose();
    _t1?.cancel();
    _t2?.cancel();
    _t3?.cancel();
    _done?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = l.S.of(context);

    const accentA = Color(0xFF2563EB);
    const accentB = Color(0xFF16A34A);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: cs.background,
        body: SizedBox.expand(
          child: _AnimatedBackground(
            a: accentA,
            b: accentB,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      t.aiAnalyzingTitle,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: cs.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.aiUsingFarmersCount(widget.farmersCount),
                      style: TextStyle(color: cs.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 26),

                    Expanded(
                      child: Center(
                        child: Container(
                          width: 240,
                          height: 240,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: cs.surface.withOpacity(0.88),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: cs.outlineVariant.withOpacity(0.45)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _spin,
                                builder: (_, __) {
                                  final angle = _spin.value * 2 * math.pi;
                                  return Transform.rotate(
                                    angle: angle,
                                    child: Container(
                                      width: 86,
                                      height: 86,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            accentA.withOpacity(0.9),
                                            accentB.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.psychology_alt_rounded,
                                        size: 42,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              Text(
                                t.aiThinking,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Steps
                    _StepRow(
                      done: _step1,
                      text: t.aiStepReadingFinancialData,
                    ),
                    const SizedBox(height: 8),
                    _StepRow(
                      done: _step2,
                      text: t.aiStepAnalyzingRiskFactors,
                    ),
                    const SizedBox(height: 8),
                    _StepRow(
                      done: _step3,
                      text: t.aiStepGeneratingReport,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      t.aiUsuallyTakesSeconds,
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.done, required this.text});
  final bool done;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: done ? cs.surface.withOpacity(0.92) : cs.surface.withOpacity(0.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: done
                ? const Icon(Icons.check_circle_rounded, key: ValueKey('ok'), size: 22)
                : const SizedBox(
                    key: ValueKey('wait'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground({
    required this.child,
    required this.a,
    required this.b,
  });

  final Widget child;
  final Color a;
  final Color b;

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.9 + t * 0.6, -1),
              end: Alignment(0.9 - t * 0.6, 1),
              colors: [
                widget.a.withOpacity(0.16),
                widget.b.withOpacity(0.14),
                cs.background,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
