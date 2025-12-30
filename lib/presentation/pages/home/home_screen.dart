import 'package:app_mobile/presentation/pages/home/widgets/ai_model_badge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'controller/home_controller.dart';
import 'widgets/home_header_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/action_tile.dart';

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

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const accent = Color(0xFF2563EB);

    return Consumer<HomeController>(
      builder: (context, c, _) {
        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: const Text('Home'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          body: RefreshIndicator(
            onRefresh: c.loadStats,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                HomeHeaderCard(
                  accent: accent,
                  title: 'Show traction immediately',
                  subtitle: 'Fast, local-first MVP. No login required.',
                  buttonText: 'New Assessment',
                  onPressed: () async {
                    await context.push('/assessment/new');
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
                        title: 'Farmers assessed in Mekong',
                        value: c.loading ? '—' : '🎉 ${c.farmersTotal}',
                        animatedValue: c.loading ? null : c.farmersTotal,
                        animatedPrefix: '🎉 ',
                        subtitle: c.loading ? 'Loading…' : '+${c.thisWeekGrowth} this week',
                        icon: Icons.auto_awesome_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Your assessments',
                        value: c.loading ? '—' : '${c.myAssessments}',
                        subtitle: 'Saved on this device',
                        icon: Icons.folder_copy_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ActionTile(
                  title: 'History',
                  subtitle: 'List past assessments, export data',
                  icon: Icons.history_rounded,
                  onTap: () => context.push('/history'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
