import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:app_mobile/presentation/widgets/custom_button/custom_app_button.dart';
import 'package:app_mobile/generated/l10n.dart' as l;

import 'models/timezone.dart';

class TimeZoneView extends StatelessWidget {
  const TimeZoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DataListView();
  }
}

class _DataListView extends StatefulWidget {
  const _DataListView();

  @override
  State<_DataListView> createState() => _DataListViewState();
}

class _DataListViewState extends State<_DataListView> {
  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StoreTimeZone.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreTimeZone.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreTimeZone.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreTimeZone.instance.data.fetchNextPage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      headerWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          AppRefreshButton(onAction: () => refresh()),
        ],
      ),
      bodyWidget: StoreTimeZone.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreTimeZone.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(child: Text('No data')),
                )
              : _buildDataTable(context),
      mobileWidget: StoreTimeZone.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreTimeZone.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(child: Text('No data')),
                )
              : _buildDataTable(context),
    );
  }

  Theme _buildDataTable(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Theme(
      data: ThemeData(dividerColor: theme.colorScheme.outline),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleSmall,
        dataTextStyle: textTheme.bodyMedium,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: [
          DataColumn(label: Text(lang.offset)),
          DataColumn(label: Text(lang.timezone_name)),
          DataColumn(label: Text(lang.is_active)),
          DataColumn(label: Text(lang.actions)),
        ],
        rows: StoreTimeZone.instance.data.datas!.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data.offset)),
              DataCell(Text(data.name)),
              DataCell(Text(data.isActive == 1 ? 'Active' : 'Inactive')),
              DataCell(
                PopupMenuButton<String>(
                  iconColor: theme.colorScheme.onTertiary,
                  color: theme.colorScheme.primaryContainer,
                  onSelected: (action) {
                    switch (action) {
                      case 'Edit':
                        // Placeholder for Edit functionality
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text(
                          lang.edit,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
