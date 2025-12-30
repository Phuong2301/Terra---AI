import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import 'package:app_mobile/presentation/pages/dashboard/models/_overview_item_model.dart';
import 'package:app_mobile/presentation/widgets/overview_tile/_overview_tile.dart';

class CardData<T> extends StatelessWidget {
  const CardData({
    super.key,
    required this.metrics,
    required this.itemsBuilder,
  });

  final T metrics;

  final List<OverviewItem> Function(BuildContext context, T metrics) itemsBuilder;

  @override
  Widget build(BuildContext context) {

    final overviewItems = itemsBuilder(context, metrics);

    return ResponsiveGridRow(
      children: List.generate(
        overviewItems.length,
        (index) {
          final item = overviewItems[index];
          return ResponsiveGridCol(
            lg: 4,
            md: 6,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8, bottom: 16),
              child: OverviewTileWidget(
                imagePath: item.iconPath,
                value: item.value,
                title: item.subtitle,
                iconBackgroundColor: item.iconColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
