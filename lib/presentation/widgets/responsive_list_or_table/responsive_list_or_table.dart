import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item, int index);
typedef TableColumnsBuilder = List<DataColumn> Function(BuildContext context);
typedef TableRowBuilder<T> = DataRow Function(BuildContext context, T item, int index);

class ResponsiveListOrTable<T> extends StatelessWidget {
  final List<T> items;
  final ItemWidgetBuilder<T> portraitItemBuilder;
  final EdgeInsetsGeometry listPadding;
  final double listItemSpacing;
  final TableColumnsBuilder tableColumnsBuilder;
  final TableRowBuilder<T> tableRowBuilder;
  final EdgeInsetsGeometry tablePadding;
  final double tableMinWidth;
  final Future<void> Function()? onRefresh;
  final ScrollController? controller;
  final ScrollController? horizontalController;

  final ScrollPhysics? physics;
  final bool primary;
  final WidgetBuilder? emptyBuilder;
  final bool showScrollbars;
  final bool thumbVisibility;     
  final bool trackVisibility;
  final double? scrollbarThickness;

  bool get _vPrimaryResolved => controller == null ? true : false;

  const ResponsiveListOrTable({
    super.key,
    required this.items,
    required this.portraitItemBuilder,
    required this.tableColumnsBuilder,
    required this.tableRowBuilder,
    this.listPadding = const EdgeInsets.all(12),
    this.listItemSpacing = 18,
    this.tablePadding = const EdgeInsets.all(12),
    this.tableMinWidth = 1200,
    this.onRefresh,
    this.controller,
    this.horizontalController,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.primary = false,
    this.emptyBuilder,
    this.showScrollbars = true,
    this.thumbVisibility = true,
    this.trackVisibility = false,
    this.scrollbarThickness,
  });

  Widget _wrapVScrollbar(Widget child) {
    if (!showScrollbars) return child;
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      trackVisibility: false,
      thickness: scrollbarThickness,
      child: child,
    );
  }

  Widget _wrapHScrollbar({required Widget child}) {
    if (!showScrollbars) return child;
    return Scrollbar(
      controller: horizontalController,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
      thickness: scrollbarThickness,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        if (items.isEmpty) {
          final empty = emptyBuilder?.call(context) ?? const Center(child: Text('No data'));
          return _wrapVScrollbar(
            ListView(
              controller: controller,
              physics: physics,
              primary: _vPrimaryResolved,
              padding: listPadding,
              children: [SizedBox(height: 240, child: empty)],
            ),
          );
        }

        if (isPortrait) {
          return _wrapVScrollbar(
            ListView.separated(
              controller: controller,
              physics: physics,
              primary: _vPrimaryResolved,
              padding: listPadding,
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: listItemSpacing),
              itemBuilder: (ctx, i) => portraitItemBuilder(ctx, items[i], i),
            ),
          );
        } else {
          final columns = tableColumnsBuilder(context);
          final rows = <DataRow>[
            for (var i = 0; i < items.length; i++) tableRowBuilder(context, items[i], i),
          ];

          return _wrapVScrollbar(
            ListView(
              controller: controller,
              physics: physics,
              primary: _vPrimaryResolved,
              padding: tablePadding,
              children: [
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final minW = constraints.maxWidth < tableMinWidth
                        ? tableMinWidth
                        : constraints.maxWidth;

                    final table = ConstrainedBox(
                      constraints: BoxConstraints(minWidth: minW),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => Theme.of(ctx).colorScheme.surface,
                        ),
                        showBottomBorder: true,
                        columns: columns,
                        rows: rows,
                      ),
                    );

                    final hScroll = SingleChildScrollView(
                      controller: horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: table,
                    );

                    return _wrapHScrollbar(child: hScroll);
                  },
                ),
              ],
            ),
          );
        }
      },
    );

    return onRefresh != null
        ? RefreshIndicator(onRefresh: onRefresh!, child: child)
        : child;
  }
}