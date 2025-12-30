// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../domain/core/static/static.dart';
import '../../../domain/core/theme/theme.dart';
import 'components/_components.dart';
import 'models/models.dart';

class ShellRouteWrapper extends StatefulWidget {
  const ShellRouteWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<ShellRouteWrapper> createState() => _ShellRouteWrapperState();
}

class _ShellRouteWrapperState extends State<ShellRouteWrapper> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLargeSidebarExpaned = true;

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _isLaptop = rf.ResponsiveBreakpoints.of(context).largerThan(
      BreakpointName.MD.name,
    );
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor:
          _isDark ? AcnooAppColors.kDark1 : AcnooAppColors.kPrimary50,
      drawer: _mqSize.width > 1240
          ? null
          : buildSidebar(_isLaptop && isLargeSidebarExpaned),
      //bottomNavigationBar: _isLaptop ? null : const FooterWidget(),
      body: rf.ResponsiveRowColumn(
        layout: rf.ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLaptop)
            rf.ResponsiveRowColumnItem(
              columnFit: FlexFit.loose,
              child: buildSidebar(!isLargeSidebarExpaned),
            ),

          // Main Content
          rf.ResponsiveRowColumnItem(
            rowFit: FlexFit.tight,
            child: rf.ResponsiveRowColumn(
              layout: rf.ResponsiveRowColumnType.COLUMN,
              children: [
                // Static Topbar
                rf.ResponsiveRowColumnItem(
                  child: buildTopbar(_isLaptop),
                ),

                // Route Breadcrumb Widget
                rf.ResponsiveRowColumnItem(
                  child: Padding(
                    padding: rf.ResponsiveValue<EdgeInsetsGeometry>(
                      context,
                      conditionalValues: [
                        rf.Condition.smallerThan(
                          name: BreakpointName.LG.name,
                          value: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        )
                      ],
                      defaultValue: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    ).value,
                    child: RouteBreadcrumbWidget(
                      breadcrumbModel: _getCurrentRouterParam(context),
                    ),
                  ),
                ),

                // Route Pages
                rf.ResponsiveRowColumnItem(
                  columnFit: FlexFit.tight,
                  child: widget.child,
                ),

                // Footer
                if (_isLaptop)
                  const rf.ResponsiveRowColumnItem(
                    child: FooterWidget(),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildTopbar(bool isLaptop) {
    if (isLaptop) scaffoldKey.currentState?.closeDrawer();
    return TopBarWidget(
      onMenuTap: () {
        if (isLaptop) {
          setState(() => isLargeSidebarExpaned = !isLargeSidebarExpaned);
        } else {
          return scaffoldKey.currentState?.openDrawer();
        }
      },
    );
  }

  Widget buildSidebar(bool isExpanded) {
    return SideBarWidget(
      rootScaffoldKey: scaffoldKey,
      iconOnly: isExpanded,
    );
  }

  RouteBreadcrumbModel _getCurrentRouterParam(BuildContext context) {
    return routerParam[GoRouterState.of(context).matchedLocation] ??
        const RouteBreadcrumbModel(
          title: 'N/A',
          parentRoute: 'N/A',
          childRoute: 'N/A',
        );
  }
}
