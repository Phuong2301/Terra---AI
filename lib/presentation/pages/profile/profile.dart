import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile/application/providers/_app_provider.dart';
import 'package:app_mobile/generated/l10n.dart' as l;
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';
import 'package:app_mobile/presentation/widgets/avatars/_avatar_widget.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang  = l.S.of(context);
    final _user = SharedPreferencesProvider.instance.profile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: _user != null ?
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            const AvatarWidget(
              imagePath:
                  'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_01.png',
              size: Size.square(200),
            ),

            const SizedBox(height: 12),
            Text(
              '${_user.firstName} ${_user.lastName}',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              _user.email,
              style: theme.textTheme.bodyMedium,
            )
          ],
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lang.noInfor),
            ElevatedButton.icon(
              onPressed: (){
                context.read<AppProvider>().notifications = null;
                context.go('/authentication/signin');
              }, 
              label: Text(lang.signIn)
            )
          ],
        )
      ),
    );
  }
}
