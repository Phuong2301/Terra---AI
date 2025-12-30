part of '_sidebar.dart';

class SidebarItemModel {
  final String name;
  final String iconPath;
  final SidebarItemType sidebarItemType;
  final List<SidebarSubmenuModel>? submenus;
  final String? navigationPath;
  final bool isPage;

  SidebarItemModel({
    required this.name,
    required this.iconPath,
    this.sidebarItemType = SidebarItemType.tile,
    this.submenus,
    this.navigationPath,
    this.isPage = false,
  }) : assert(
          sidebarItemType != SidebarItemType.submenu ||
              (submenus != null && submenus.isNotEmpty),
          'Sub menus cannot be null or empty if the item type is submenu',
        );
}

class SidebarSubmenuModel {
  final String name;
  final String? navigationPath;
  final bool isPage;
  final String code;

  SidebarSubmenuModel({
    required this.name,
    this.navigationPath,
    this.isPage = false,
    this.code = '',
  });
}

class GroupedMenuModel {
  final String name;
  final List<SidebarItemModel> menus;

  GroupedMenuModel({
    required this.name,
    required this.menus,
  });
}

enum SidebarItemType { tile, submenu }

List<GroupedMenuModel> get _groupedMenus {
  return <GroupedMenuModel>[
    GroupedMenuModel(
      name: l.S.current.application,
      menus: [
        SidebarItemModel(
          name: l.S.current.dashboard,
          iconPath: 'assets/images/sidebar_icons/home-dash-star.svg',
          navigationPath: '/dashboard',
        ),
          SidebarItemModel(
            name: l.S.current.business,
            iconPath: 'assets/images/sidebar_icons/kanban.svg',
            sidebarItemType: SidebarItemType.submenu,
            navigationPath: '/admin',
            submenus: [
              SidebarSubmenuModel(
                name: l.S.current.business_setting,
                navigationPath: 'business_setting',
              ),
              SidebarSubmenuModel(
                name: l.S.current.business_location,
                navigationPath: 'business_location',
              ),
            ],
          ),

        // SidebarItemModel(
        //   name: l.S.current.Logout,
        //   iconPath: 'assets/images/sidebar_icons/note-list.svg',
        //   navigationPath: '/authentication/signin',
        // ),
      ],
    ),
  ];
}
