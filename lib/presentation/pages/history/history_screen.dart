import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/history_controller.dart';
import 'widgets/history_item_card.dart';
import 'widgets/history_empty_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryController()..load(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Consumer<HistoryController>(
      builder: (context, c, _) {
        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: const Text('History'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          body: RefreshIndicator(
            onRefresh: c.load,
            child: c.loading
                ? ListView(
                    children: const [
                      SizedBox(height: 220),
                      Center(child: CircularProgressIndicator()),
                    ],
                  )
                : (c.items.isEmpty
                    ? ListView(children: const [SizedBox(height: 180), HistoryEmptyState()])
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        itemBuilder: (_, i) {
                          final it = c.items[i];
                          final id = (it['id'] ?? '').toString();
                          return HistoryItemCard(
                            item: it,
                            onDelete: () async {
                              if (id.isEmpty) return;
                              await c.deleteById(id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Deleted')),
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: c.items.length,
                      )),
          ),
        );
      },
    );
  }
}
