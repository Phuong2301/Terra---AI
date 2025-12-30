// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import 'package:app_mobile/application/app_auth.dart';
import 'package:app_mobile/application/providers/_user_provider.dart';
import 'package:app_mobile/domain/helpers/extensions/extention_helper.dart';
import 'package:app_mobile/domain/models/other/notification_model.dart';
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../../domain/core/static/static.dart';
import '../../../../../domain/helpers/helpers.dart';
import '../../../../../application/providers/providers.dart';
import '../../../../widgets/widgets.dart';
import '../language_dropdown/_language_dropdown.dart';
//import '../language_dropdown/_language_dropdown.dart';

part '_notification_icon_button.dart';
part '_toggle_theme.dart';
part '_user_profile_avatar.dart';

class TopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const TopBarWidget({super.key, this.onMenuTap});

  final void Function()? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _formKey = GlobalKey<FormState>();
    return AppBar(
      leading: rf.ResponsiveValue<Widget?>(
        context,
        conditionalValues: [
          rf.Condition.largerThan(
            name: BreakpointName.MD.name,
            value: null,
          ),
        ],
        defaultValue: IconButton(
          onPressed: onMenuTap,
          icon: Tooltip(
            // message: 'Open Navigation menu',
            message: lang.openNavigationMenu,
            waitDuration: const Duration(milliseconds: 350),
            child: const Icon(Icons.menu),
          ),
        ),
      ).value,
      toolbarHeight: rf.ResponsiveValue<double?>(
        context,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.SM.name, value: 70)
        ],
      ).value,
      surfaceTintColor: Colors.transparent,
      actions: [
        // Language Dropdown
        Consumer<AppProvider>(
          builder: (context, lang, child) {
            return LanguageDropdownWidget(
              value: lang.currentLocale,
              supportedLanguage: lang.locales,
              onChanged: (loc) {
                context.read<AppProvider>().changeLocale(loc);
                _formKey.currentState?.validate(); // 👈 ép validator chạy lại để chuỗi lỗi đổi
              },
            );
          },
        ),
        const SizedBox(width: 8),

        // Toggle Theme Button
        Consumer<AppProvider>(
          builder: (context, appTheme, child) => ThemeToggler(
            isDarkMode: appTheme.isDarkTheme,
            onChanged: appTheme.toggleTheme,
          ),
        ),

        //Notification Icon
        const Padding(
          padding: EdgeInsetsDirectional.only(start: 0, end: 12),
          child: NotificationIconButton(),
        ),

        // User Avatar
        const UserProfileAvatar(),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}
