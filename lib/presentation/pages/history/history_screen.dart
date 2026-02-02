import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart' as l;
import '../../controller/history_controller.dart';
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

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lang = l.S.of(context);

    return Consumer<HistoryController>(
      builder: (context, c, _) {
        Widget body;

        if (c.loading) {
          body = ListView(
            controller: _scrollCtrl,
            children: const [
              SizedBox(height: 220),
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (c.items.isEmpty) {
          body = ListView(
            controller: _scrollCtrl,
            children: const [
              SizedBox(height: 180),
              HistoryEmptyState(),
            ],
          );
        } else {
          body = ListView.separated(
            controller: _scrollCtrl,
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
                      SnackBar(content: Text(lang.deleted)),
                    );
                  }
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: c.items.length,
          );
        }

        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: Text(lang.history),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          body: Scrollbar(
            controller: _scrollCtrl,
            thumbVisibility: true, // luôn hiện thanh cuộn
            interactive: true,     // kéo thumb được (desktop/web)
            child: RefreshIndicator(
              onRefresh: c.load,
              child: body,
            ),
          ),
        );
      },
    );
  }
}
