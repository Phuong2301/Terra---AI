// 🐦 Flutter imports:
import 'package:app_mobile/application/providers/_user_provider.dart';
import 'package:app_mobile/domain/configs/app_config.dart';
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:collection/collection.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../../domain/core/static/static.dart';
import '../../../../widgets/widgets.dart';

part '_sidebar_item_model.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({
    super.key,
    required this.rootScaffoldKey,
    this.iconOnly = false,
  });

  final GlobalKey<ScaffoldState> rootScaffoldKey;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Drawer(
      clipBehavior: Clip.none,
      width: iconOnly
          ? 80
          : rf.ResponsiveValue<double?>(
              context,
              conditionalValues: [
                rf.Condition.largerThan(
                  name: BreakpointName.SM.name,
                  value: 300,
                ),
              ],
            ).value,
      shape: const BeveledRectangleBorder(),
      child: SafeArea(
        child: rf.ResponsiveRowColumn(
          layout: rf.ResponsiveRowColumnType.COLUMN,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            rf.ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 16),
                child: CompanyHeaderWidget(
                  showIconOnly: iconOnly,
                  showBottomBorder: true,
                  onTap: () {
                    rootScaffoldKey.currentState?.closeDrawer();
                    if (SharedPreferencesProvider
                        .instance.accessToken.isEmpty) {
                      context.go('/authentication');
                    } else {
                      context.go('/dashboard');
                    }
                  },
                ),
              ),
            ),

            // Navigation Items
            rf.ResponsiveRowColumnItem(
              columnFit: FlexFit.tight,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                child: SingleChildScrollView(
                  child: rf.ResponsiveRowColumn(
                    layout: rf.ResponsiveRowColumnType.COLUMN,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    columnPadding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Top Menus
                      // ..._topMenus.map(
                      //   (menu) {
                      //     final _selectedInfo = _isSelected(context, menu);
                      //     return rf.ResponsiveRowColumnItem(
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsetsDirectional.only(bottom: 16),
                      //         child: SidebarMenuItem(
                      //           iconOnly: iconOnly,
                      //           menuTile: menu,
                      //           groupName: menu.name,
                      //           isSelected: _selectedInfo.$1,
                      //           selectedSubmenu: _selectedInfo.$2,
                      //           onTap: () => _handleNavigation(context, menu),
                      //           onSubmenuTap: (value) => _handleNavigation(
                      //             context,
                      //             menu,
                      //             submenu: value,
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),

                      // Grouped Menus
                      ..._groupedMenus.map(
                        (groupedMenu) => rf.ResponsiveRowColumnItem(
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Group Name
                                if (!iconOnly)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        bottom: 16),
                                    child: Text(
                                      groupedMenu.name,
                                      style:
                                          _theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                // Grouped Menu
                                ...groupedMenu.menus.map((menu) {
                                  final _selectedInfo = _isSelected(
                                    context,
                                    menu,
                                  );
                                  return rf.ResponsiveRowColumnItem(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 16),
                                      child: SidebarMenuItem(
                                        iconOnly: iconOnly,
                                        menuTile: menu,
                                        groupName: menu.name,
                                        isSelected: _selectedInfo.$1,
                                        selectedSubmenu: _selectedInfo.$2,
                                        onTap: () => _handleNavigation(
                                          context,
                                          menu,
                                        ),
                                        onSubmenuTap: (value) =>
                                            _handleNavigation(
                                          context,
                                          menu,
                                          submenu: value,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            rf.ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: iconOnly
                      ? Tooltip(
                          message: AppConfig.version,
                          child: Icon(
                            MdiIcons.informationOutline, 
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              AcnooSVGIcons.versionIcon,
                              width: 20, 
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "v${AppConfig.version}",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (bool isSelectedMenu, SidebarSubmenuModel? selectedSubMenu) _isSelected(
    BuildContext context,
    SidebarItemModel menu,
  ) {
    final isSubmenu = menu.sidebarItemType == SidebarItemType.submenu;
    final currentRoute =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    final isSelectedMenu = currentRoute.startsWith(
      menu.navigationPath!.toLowerCase().trim(),
    );

    if (isSubmenu) {
      final routeSegments = currentRoute
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .toList();

      if (routeSegments.length > 1) {
        final selectedSubMenu = menu.submenus?.firstWhereOrNull(
          (submenu) =>
              submenu.navigationPath?.split('/').last == routeSegments.last,
        );
        if (selectedSubMenu != null) {
          return (true, selectedSubMenu);
        }
      }
    }

    return (isSelectedMenu, null);
  }

  void _handleNavigation(
    BuildContext context,
    SidebarItemModel menu, {
    SidebarSubmenuModel? submenu,
  }) {
    final lang = l.S.of(context);
    rootScaffoldKey.currentState?.closeDrawer();
    String? _route;

    if (menu.sidebarItemType == SidebarItemType.tile) {
      _route = menu.navigationPath;
    } else if (menu.sidebarItemType == SidebarItemType.submenu) {
      final _mainRoute = menu.navigationPath;
      final _submenuRoute = submenu?.navigationPath;
      if (_mainRoute != null && _submenuRoute != null) {
        _route = '$_mainRoute/$_submenuRoute';
      }
    }

    if (_route == null || _route.isEmpty) {
      ScaffoldMessenger.of(rootScaffoldKey.currentContext!).showSnackBar(
        //SnackBar(content: Text('Unknown Route')),
        SnackBar(content: Text(lang.unknownRoute)),
      );
      return;
    }

    final _currentPath =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if (_currentPath == _route) return;

    context.go(_route);
  }
}

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    super.key,
    this.iconOnly = false,
    required this.menuTile,
    this.isSelected = false,
    this.selectedSubmenu,
    this.onSubmenuTap,
    this.onTap,
    this.groupName,
  });

  final bool iconOnly;
  final SidebarItemModel menuTile;
  final bool isSelected;
  final SidebarSubmenuModel? selectedSubmenu;
  final void Function(SidebarSubmenuModel? value)? onSubmenuTap;
  final void Function()? onTap;
  final String? groupName;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    if (menuTile.sidebarItemType == SidebarItemType.submenu) {
      if (iconOnly) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: PopupMenuButton<SidebarSubmenuModel?>(
            offset: const Offset(80 - 16, 0),
            shape: const BeveledRectangleBorder(),
            clipBehavior: Clip.antiAlias,
            tooltip: menuTile.name,
            color: _theme.colorScheme.primaryContainer,
            itemBuilder: (context) => [
              // Group Name
              if (groupName != null)
                _CustomIconOnlySubmenu(
                  enabled: false,
                  child: Container(
                    margin: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          groupName!,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(MdiIcons.chevronDown),
                      ],
                    ),
                  ),
                ),

              // Submenus
              ...?menuTile.submenus?.map(
                (submenu) {
                  return _CustomIconOnlySubmenu<SidebarSubmenuModel>(
                    value: submenu,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 12),
                      child: _buildSubmenu(
                        context,
                        submenu,
                        onChanged: (value) {
                          Navigator.pop(context, value);
                          onSubmenuTap?.call(value);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
            child: _buildMenu(context, onTap: null),
          ),
        );
      }
      return ExpansionWidget(
        titleBuilder: (aV, eIV, iE, tF) => _buildMenu(
          context,
          onTap: () => tF(animated: true),
          isExpanded: iE,
        ),
        initiallyExpanded: isSelected,
        content: Padding(
          padding: const EdgeInsetsDirectional.only(top: 8, start: 36),
          child: Column(
            children: [
              ...?menuTile.submenus?.map(
                (submenu) {
                  return _buildSubmenu(
                    context,
                    submenu,
                    onChanged: onSubmenuTap,
                  );
                },
              )
            ],
          ),
        ),
      );
    }

    if (iconOnly) {
      return Tooltip(
        message: menuTile.name,
        child: _buildMenu(context, onTap: onTap),
      );
    }
    return _buildMenu(context, onTap: onTap);
  }

  Widget _buildMenu(
    BuildContext context, {
    required void Function()? onTap,
    bool isExpanded = false,
  }) {
    final _theme = Theme.of(context);

    const _selectedPrimaryColor = Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: BoxConstraints.tight(const Size.fromHeight(48)),
        alignment: AlignmentDirectional.center,
        decoration: ShapeDecoration(
          color: isSelected ? _theme.colorScheme.primary : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: EdgeInsetsDirectional.only(start: iconOnly ? 8 : 16, end: 8),
        child: Row(
          mainAxisAlignment:
              iconOnly ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            // Icon
            SvgPicture.asset(
              menuTile.iconPath,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? _selectedPrimaryColor
                    : _theme.textTheme.bodyLarge!.color!,
                BlendMode.srcIn,
              ),
            ),

            if (!iconOnly)
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu title
                      Flexible(
                        child: Text(
                          menuTile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            color: isSelected ? _selectedPrimaryColor : null,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Trailing Icon
                      Icon(
                        isExpanded ? MdiIcons.chevronDown : Icons.chevron_right,
                        color: isSelected ? _selectedPrimaryColor : null,
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu(
    BuildContext context,
    SidebarSubmenuModel submenu, {
    void Function(SidebarSubmenuModel? value)? onChanged,
  }) {
    final _theme = Theme.of(context);
    final _isSelectedSubmenu = selectedSubmenu == submenu;
    final _selectedPrimaryColor = _theme.primaryColor;

    if (UserProvider.instance.permissions!.any((e) => e.code == submenu.code)) {
      return Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () => onChanged?.call(submenu),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: _isSelectedSubmenu
              ? _selectedPrimaryColor.withOpacity(0.20)
              : null,
          title: Text(submenu.name),
          leading: Icon(
            _isSelectedSubmenu
                ? Icons.radio_button_checked_outlined
                : Icons.circle_outlined,
            size: _isSelectedSubmenu ? 16 : 14,
          ),
          minLeadingWidth: 0,
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -2,
          ),
          titleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
            color: _isSelectedSubmenu ? _selectedPrimaryColor : null,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsetsDirectional.only(
            start: iconOnly ? 8 : 16,
            end: 8,
          ),
          trailing: const Icon(Icons.chevron_right),
          iconColor: _isSelectedSubmenu ? _selectedPrimaryColor : null,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _CustomIconOnlySubmenu<T> extends StatefulWidget
    implements PopupMenuEntry<T> {
  const _CustomIconOnlySubmenu({
    super.key,
    this.enabled = true,
    this.value,
    required this.child,
  });
  final bool enabled;
  final T? value;
  final Widget child;

  @override
  State<_CustomIconOnlySubmenu> createState() => _CustomIconOnlySubmenuState();

  @override
  double get height => 0;

  @override
  bool represents(value) => value == this.value;
}

class _CustomIconOnlySubmenuState<T> extends State<_CustomIconOnlySubmenu> {
  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: widget.enabled ? handleTap : null,
      child: widget.child,
    );
  }
}
