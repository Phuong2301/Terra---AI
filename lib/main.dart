import 'dart:async';
import 'package:app_mobile/presentation/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:app_mobile/domain/services/firebase_options.dart';
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import 'package:url_strategy/url_strategy.dart';

// 🌎 Project imports:
import 'domain/configs/app_config.dart';
import 'domain/core/static/static.dart';
import 'domain/core/theme/theme.dart';
import 'application/providers/providers.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (!kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  await SharedPreferencesProvider.instance.init();

  // if (kDebugMode) {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  // }
  
  ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
    sm: 576,
    md: 1240,
    lg: double.infinity,
  );

  final _app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider()),
    ],
    child: const AcnooApp(),
  );
  runApp(_app);
}

class AcnooApp extends StatefulWidget {
  const AcnooApp({super.key});

  @override
  State<AcnooApp> createState() => _AcnooAppState();
}

class _AcnooAppState extends State<AcnooApp> {
  late final GoRouter _router;
  @override
  void initState() {
    super.initState();
    _router = AcnooAppRoutes.buildRouter();
    // AppVersion.instance.checkForUpdate().then((value) async {
    //   if (AppVersion.instance.hasUpdate) {
    //     await showDialogUpdateVersion(AcnooAppRoutes.navKey.currentContext!);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appTheme, child) {
        return rf.ResponsiveBreakpoints.builder(
          breakpoints: [
            rf.Breakpoint(
              start: BreakpointName.XS.start,
              end: BreakpointName.XS.end,
              name: BreakpointName.XS.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.SM.start,
              end: BreakpointName.SM.end,
              name: BreakpointName.SM.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.MD.start,
              end: BreakpointName.MD.end,
              name: BreakpointName.MD.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.LG.start,
              end: BreakpointName.LG.end,
              name: BreakpointName.LG.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.XL.start,
              end: BreakpointName.XL.end,
              name: BreakpointName.XL.name,
            ),
          ],
          child: MaterialApp.router(
            title: AppConfig.appName,
            theme: AcnooAppTheme.kLightTheme(),
            darkTheme: AcnooAppTheme.kDarkTheme(),
            themeMode: appTheme.themeMode,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(rf.ResponsiveValue<double>(
                  context,
                  conditionalValues: [],
                  defaultValue: 1.0,
                ).value),
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: child!),
                  if (kDebugMode)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        child: Text("${MediaQuery.sizeOf(context)}"),
                      ),
                    ),
                ],
              ),
            ),

            // Language & Locale
            locale: appTheme.currentLocale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
