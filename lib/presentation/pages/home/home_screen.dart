import 'package:app_mobile/presentation/pages/home/widgets/ai_model_badge.dart';
import 'package:app_mobile/presentation/pages/home/widgets/user_profile_tile.dart';
import 'package:app_mobile/presentation/widgets/button/language_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controller/home_controller.dart';
import 'widgets/home_header_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/action_tile.dart';
import '../../../../generated/l10n.dart' as l;

import '../demo/demo_mode_store.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController()..init(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  bool _demoEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadDemoFlag();
  }

  Future<void> _loadDemoFlag() async {
    final v = await DemoModeStore.isEnabled();
    if (!mounted) return;
    setState(() => _demoEnabled = v);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const accent = Color(0xFF2563EB);

    final lang = l.S.of(context);

    return Consumer<HomeController>(
      builder: (context, c, _) {
        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () async {
                await DemoModeStore.toggle();
                final enabled = await DemoModeStore.isEnabled();
                if (!mounted) return;

                setState(() => _demoEnabled = enabled);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      enabled ? lang.demoModeOn : lang.demoModeOff,
                    ),
                  ),
                );

                await c.loadStats();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.homeTitle),
                  if (_demoEnabled) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.35),
                        ),
                      ),
                      child: Text(
                        lang.demoChip,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: const [
              LanguageMenuButton()
            ],
          ),
          body: RefreshIndicator(
            onRefresh: c.loadStats,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                const UserProfileTile(),
                const SizedBox(height: 12),
                HomeHeaderCard(
                  accent: accent,
                  title: lang.homeHeaderTitle,
                  subtitle: _demoEnabled ? lang.homeHeaderSubtitleDemo : lang.homeHeaderSubtitleNormal,
                  buttonText: lang.homeNewAssessment,
                  onPressed: () async {
                    final demo = await DemoModeStore.isEnabled();
                    await context.push('/assessment/new', extra: {'demo': demo});
                    await c.loadStats();
                  },
                ),

                if (c.ai != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AiModelBadge(ai: c.ai!),
                  ),
                ],

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: lang.homeStatFarmersTitle,
                        value: c.loading ? '—' : '🎉 ${c.farmersTotal}',
                        animatedValue: c.loading ? null : c.farmersTotal,
                        animatedPrefix: '🎉 ',
                        subtitle: c.loading ? lang.loading : lang.homeStatFarmersSubtitle(c.thisWeekGrowth),
                        icon: Icons.auto_awesome_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: lang.homeStatYourAssessmentsTitle,
                        value: c.loading ? '—' : '${c.myAssessments}',
                        subtitle: lang.homeStatYourAssessmentsSubtitle,
                        icon: Icons.folder_copy_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ActionTile(
                  title: lang.homeHistoryTitle,
                  subtitle: lang.homeHistorySubtitle,
                  icon: Icons.history_rounded,
                  onTap: () => context.push('/history'),
                ),

                if (_demoEnabled) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await DemoModeStore.setEnabled(false);
                      await _loadDemoFlag();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(lang.demoModeReset)),
                      );
                      await c.loadStats();
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(lang.resetDemoMode),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
