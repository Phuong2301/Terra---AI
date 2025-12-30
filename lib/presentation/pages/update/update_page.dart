// import 'dart:io' show Platform, exit;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:app_mobile/application/providers/version_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class UpdateScreen extends StatefulWidget {
//   const UpdateScreen({super.key, required this.from});
//   final String from;

//   @override
//   State<UpdateScreen> createState() => _UpdateScreenState();
// }

// class _UpdateScreenState extends State<UpdateScreen> {
//   bool _shown = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_shown) {
//       _shown = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog());
//     }
//   }

//   Future<void> _showDialog() async {
//     final vp = VersionProvider.instance;
//     final force = vp.mustUpdate;
//     final remote = vp.remote;

//     await showGeneralDialog(
//       context: context,
//       barrierDismissible: !force,
//       barrierLabel: 'update',
//       barrierColor: Colors.transparent,
//       pageBuilder: (ctx, anim, _) {
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: Container(color: Colors.white.withOpacity(0.90)),
//             ),

//             Positioned.fill(
//               child: IgnorePointer(
//                 child: Align(
//                   alignment: const Alignment(0, -0.35),
//                   child: Opacity(
//                     opacity: 0.5,
//                     child: Image.asset(
//                       'assets/images/logo/logo.png',
//                       width: 260,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             Center(
//               child: Material(
//                 type: MaterialType.transparency,
//                 child: PopScope(
//                   canPop: !force,
//                   child: AlertDialog(
//                     title: const Text('Cập nhật phiên bản'),
//                     content: Text(
//                       remote == null
//                         ? 'Đã có bản cập nhật mới. Vui lòng cập nhật để tiếp tục.'
//                         : 'Đã có bản ${remote.versionName}. Vui lòng cập nhật để tiếp tục.',
//                     ),
//                     actions: [
//                       if (!force)
//                         TextButton(
//                           onPressed: () {
//                             vp.markPrompted();
//                             Navigator.of(ctx).pop();
//                             context.go(widget.from);
//                           },
//                           child: const Text('Để sau'),
//                         ),
//                       TextButton(
//                         onPressed: () async {
//                           await _openStore(remote?.storeId ?? '');
//                           await Future.delayed(const Duration(milliseconds: 300));

//                           if (Platform.isAndroid) {
//                             SystemNavigator.pop();         
//                           } else if (Platform.isIOS) {
//                             exit(0);                 
//                           }
//                         },
//                         child: const Text('Cập nhật'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       transitionBuilder: (ctx, anim, _, child) {
//         final curved = CurvedAnimation(
//           parent: anim,
//           curve: Curves.easeOutCubic,
//           reverseCurve: Curves.easeInCubic,
//         );
//         return FadeTransition(
//           opacity: curved,
//           child: ScaleTransition(
//             scale: Tween(begin: .98, end: 1.0).animate(curved),
//             child: child,
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _openStore(String storeIdOrUrl) async {
//     if (Platform.isAndroid) {
//       final pkg = storeIdOrUrl.replaceFirst('id=', '');
//       final market = Uri.parse('market://details?id=$pkg');
//       final web = Uri.parse('https://play.google.com/store/apps/details?id=$pkg');
//       if (await canLaunchUrl(market)) {
//         await launchUrl(market);
//       } else {
//         await launchUrl(web, mode: LaunchMode.externalApplication);
//       }
//     } else if (Platform.isIOS) {
//       final url = Uri.parse('https://apps.apple.com/app/$storeIdOrUrl');
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(backgroundColor: Colors.transparent);
//   }
// }
