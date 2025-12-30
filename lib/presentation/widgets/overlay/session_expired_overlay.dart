import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';
import 'package:app_mobile/presentation/routes/app_routes.dart';
import '../../../generated/l10n.dart' as l ;

class SessionExpiredOverlay {
  SessionExpiredOverlay._();
  static OverlayEntry? _barrier;
  static OverlayEntry? _dialog;
  static bool _isShowing = false;

  static void show({
    String title = 'Phiên đăng nhập đã hết hạn',
    String message = 'Vui lòng đăng nhập lại để tiếp tục.',
    String confirmText = 'Xác nhận',
  }) {
    if (_isShowing) return;
    final ctx = AcnooAppRoutes.navKey.currentContext;
    final overlay = ctx != null ? Navigator.of(ctx, rootNavigator: true).overlay : null;
    if (overlay == null) return;

    _isShowing = true;

    _barrier = OverlayEntry(
      builder: (_) => const ModalBarrier(dismissible: false, color: Colors.black54),
    );

    _dialog = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(l.S.current.sessionExpired, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          content: Text(l.S.current.signinAgainToContinue, textAlign: TextAlign.center),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  _dismiss();
                  await SharedPreferencesProvider.instance.clear();
                  final ctx = AcnooAppRoutes.navKey.currentContext;
                  if (ctx != null) {
                    // ignore: use_build_context_synchronously
                    ctx.go('/authentication/signin');
                  }
                },
                child: Text(l.S.current.confirm),
              ),
            ),
          ],
        );
      },
    );

    overlay.insertAll([_barrier!, _dialog!]);
  }

  static void _dismiss() {
    _dialog?.remove();
    _barrier?.remove();
    _dialog = null;
    _barrier = null;
    _isShowing = false;
  }
}


