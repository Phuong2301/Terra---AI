// 📦 Package imports:
import 'package:app_mobile/presentation/pages/ai/ai_processing_screen.dart';
import 'package:app_mobile/presentation/pages/assessment/assessment_form_screen.dart';
import 'package:app_mobile/presentation/pages/dashboard/pages/base.dart';
import 'package:app_mobile/presentation/pages/history/history_screen.dart';
import 'package:app_mobile/presentation/pages/home/home_screen.dart';
import 'package:app_mobile/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:app_mobile/presentation/pages/result/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_mobile/presentation/pages/profile/profile.dart';

// 🌎 Project imports:
import '../pages/pages.dart';

abstract class AcnooAppRoutes {
  static final _appNavigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navKey => _appNavigatorKey;
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static const _initialPath = '/';
  static const _onboardingPath = '/onboarding';
  static GoRouter buildRouter() {
    return GoRouter(
      navigatorKey: _appNavigatorKey,
      initialLocation: _onboardingPath,
      // redirect: (context, state) async {
      //   final done = await OnboardingStorage.isCompleted();
      //   final goingToOnboarding = state.matchedLocation == _onboardingPath;

      //   if (!done && !goingToOnboarding) {
      //     return _onboardingPath;
      //   }

      //   if (done && goingToOnboarding) {
      //     return '/dashboard'; 
      //   }

      //   return null;
      // },
      routes: [
        GoRoute(
          path: _onboardingPath,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OnboardingScreen(
              nextRoutePath: '/home',
            ),
          ),
        ),
        // Landing Route Handler
        GoRoute(
          path: _initialPath,
          redirect: (context, state) {
            // if (SharedPreferencesProvider.instance.accessToken.isEmpty) {
            //   return '/authentication/signin';
            // }
            // final _appLangProvider =
            //     Provider.of<AppProvider>(context, listen: false);
            // if (state.uri.queryParameters['rtl'] == 'true') {
            //   _appLangProvider.isRTL = true;
            // }
            return _onboardingPath;
          },
        ),

        // Global Shell Route
        ShellRoute(
          navigatorKey: rootNavigatorKey,
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
              child: ShellRouteWrapper(child: child),
            );
          },
          routes: [
            // Dashboard Routes
            GoRoute(
              path: '/dashboard',
              redirect: (context, state) async {
                if (state.fullPath == '/dashboard') {
                  return '/dashboard/base';
                }
                return null;
              },
              routes: [
                GoRoute(
                  path: 'base',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: DashboardBaseView(),
                  ),
                ),
              ],
            ),

            //--------------Application Section--------------//
            GoRoute(
              path: '/calendar',
              pageBuilder: (context, state) => const NoTransitionPage<void>(
                child: CalendarView(),
              ),
            ),
            GoRoute(
              path: '/users/user-profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Profile(),
              ),
            ),
          ],
        ),

        // Full Screen Pages

        GoRoute(
          path: '/authentication',
          redirect: (context, state) async {
            if (state.fullPath == '/authentication') {
              return '/authentication/signin';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'signup',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SignupView(),
              ),
            ),
            GoRoute(
              path: 'signin',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SigninView(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/assessment/new',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AssessmentFormScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Profile(),
          ),
        ),
        GoRoute(
          path: '/ai-processing',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return NoTransitionPage(
              child: AiProcessingScreen(
                farmersCount: (extra?['farmersCount'] as int?) ?? 127,
                duration: extra?['duration'] as Duration? ?? const Duration(seconds: 7),
                nextRoutePath: (extra?['nextRoutePath'] as String?) ?? '/results',
                payload: extra?['payload'] as Map<String, dynamic>?,
              ),
            );
          },
        ),
        GoRoute(
          path: '/results',
          pageBuilder: (context, state) {
            final payload = state.extra as Map<String, dynamic>?;
            return NoTransitionPage(
              child: ResultsScreen(payload: payload),
            );
          },
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
        ),
      ],
      errorPageBuilder: (context, state) => const NoTransitionPage(
        child: NotFoundView(),
      ),
    );
  }
}
