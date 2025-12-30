import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart' as l;

import '../models/onboard_page_data.dart';
import '../services/onboarding_storage.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/onboard_page.dart';

class OnboardingIntroStep extends StatefulWidget {
  const OnboardingIntroStep({
    super.key,
    required this.onSkip,
    required this.onFinishIntro,
  });

  final VoidCallback onSkip;
  final VoidCallback onFinishIntro;

  @override
  State<OnboardingIntroStep> createState() => _OnboardingIntroStepState();
}

class _OnboardingIntroStepState extends State<OnboardingIntroStep> {
  final _pageCtrl = PageController();
  int _index = 0;

  int _farmersCount = 100;
  bool _loadingCount = true;

  @override
  void initState() {
    super.initState();
    _loadFarmersCountWeekly();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFarmersCountWeekly() async {
    setState(() => _loadingCount = true);

    _farmersCount =
        await OnboardingStorage.getFarmersCountCachedOrDefault(fallback: 100);

    final lastFetchedMs = await OnboardingStorage.getLastFetchedAtMs();
    final now = DateTime.now();
    final shouldRefresh = lastFetchedMs == null
        ? true
        : now
                .difference(DateTime.fromMillisecondsSinceEpoch(lastFetchedMs))
                .inDays >=
            7;

    if (shouldRefresh) {
      final remote = await OnboardingStorage.fetchFarmersCountFromServer();
      if (remote != null && remote > 0) {
        _farmersCount = remote;
        await OnboardingStorage.setFarmersCount(remote);
      }
      await OnboardingStorage.setFetchedNow();
    }

    if (!mounted) return;
    setState(() => _loadingCount = false);
  }

  void _nextPage() {
    if (_index < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _prevPage() {
    if (_index > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _nextOrFinish() {
    if (_index < 2) {
      _nextPage();
    } else {
      widget.onFinishIntro();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);

    final pages = <OnboardPageData>[
      OnboardPageData(
        title: lang.onboarding_title_1,
        subtitle: lang.onboarding_subtitle_1,
        icon: Icons.timer_outlined,
        accent: const Color(0xFF2563EB),
      ),
      OnboardPageData(
        title: lang.onboarding_title_2,
        subtitle: lang.onboarding_subtitle_2,
        icon: Icons.auto_awesome_outlined,
        accent: const Color(0xFF7C3AED),
      ),
      OnboardPageData(
        title: lang.onboarding_title_3(_loadingCount ? 100 : _farmersCount),
        subtitle: lang.onboarding_subtitle_3,
        icon: Icons.groups_outlined,
        accent: const Color(0xFF16A34A),
      ),
    ];

    final accent = pages[_index].accent;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [accent.withOpacity(0.22), Colors.white],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: widget.onSkip,
                      child: Text(lang.onboarding_skip),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => OnboardPage(data: pages[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Row(
                  children: [
                    DotsIndicator(count: 3, index: _index),
                    const SizedBox(width: 50),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _index == 0
                            ? SizedBox(
                                key: const ValueKey('one_button_row'),
                                height: 48,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _nextOrFinish,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accent,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(lang.onboarding_continue),
                                ),
                              )
                            : Row(
                                key: const ValueKey('two_buttons_row'),
                                children: [
                                  SizedBox(
                                    height: 48,
                                    width: 48,
                                    child: OutlinedButton(
                                      onPressed: _prevPage,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: accent,
                                        side: BorderSide(
                                          color: accent.withOpacity(0.35),
                                        ),
                                        shape: const CircleBorder(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_rounded,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: _nextOrFinish,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accent,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: Text(
                                          _index == 2
                                              ? lang.onboarding_get_started
                                              : lang.onboarding_continue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
