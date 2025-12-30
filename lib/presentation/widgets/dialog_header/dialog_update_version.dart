import 'dart:io' show Platform, exit;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_mobile/application/app_version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_mobile/generated/l10n.dart' as l;

Future<void> showDialogUpdateVersion(BuildContext context) async {
  final vp = AppVersion.instance;
  final force = vp.mustUpdate;
  final remote = vp.remote;

  await showDialog(
    context: context,
    barrierDismissible: !force,
    barrierLabel: 'update',
    //barrierColor: Colors.transparent,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          title: Text(l.S.current.updateVersion),
          content: Text(
            remote == null
                ? l.S.current.updateVersionToContinue
                : '${l.S.current.versionAvailable} ${remote.versionName}. ${l.S.current.pleaseUpdate}',
          ),
          actions: [
            if (!force)
              TextButton(
                onPressed: () {
                  vp.markPrompted();
                  Navigator.of(ctx).pop();
                },
                child: Text(l.S.current.cancel),
              ),
            TextButton(
              onPressed: () async {
                await _openStore(remote?.storeId ?? '');
                await Future.delayed(const Duration(milliseconds: 300));
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              child: Text(l.S.current.update),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _openStore(String storeIdOrUrl) async {
  if (Platform.isAndroid) {
    final pkg = storeIdOrUrl.replaceFirst('id=', '');
    final market = Uri.parse('market://details?id=$pkg');
    final web = Uri.parse('https://play.google.com/store/apps/details?id=$pkg');
    if (await canLaunchUrl(market)) {
      await launchUrl(market);
    } else {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  } else if (Platform.isIOS) {
    final url = Uri.parse('https://apps.apple.com/app/$storeIdOrUrl');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
