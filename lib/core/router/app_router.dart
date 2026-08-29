import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/hadiths/hadiths_routes.dart';
import '../../features/onboarding/data/onboarding_pref.dart';
import '../../features/onboarding/onboarding_routes.dart';
import '../../features/onboarding/presentation/screens/faith_selection_screen.dart';
import '../../features/practice/practice_routes.dart';
import '../../features/quran/quran_routes.dart';
import '../../features/reflect/reflect_routes.dart';
import '../../features/settings/settings_routes.dart';
import '../../features/share/share_routes.dart';
import '../../features/shell/app_shell.dart';
import '../../features/today/today_routes.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Holds the splash for a minimum window so the brand reveal animation can
/// breathe even on warm starts where auth + onboarding resolve instantly.
@Riverpod(keepAlive: true)
Future<bool> splashGate(Ref ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 1700));
  return true;
}

/// Top-level GoRouter, wired to [AuthController] + [OnboardingDone] so route
/// guards re-evaluate when either resolves.
///
/// Redirect logic, in priority order:
///   1. Auth still bootstrapping → stay on /splash.
///   2. Onboarding pref still resolving → stay on /splash.
///   3. Onboarding not done → /onboarding (or its faith sub-route).
///   4. Onboarding done + unauthenticated → /login (allow /register too).
///   5. Authenticated + on auth/splash/onboarding route → /today.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final notifier = _RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);

  bool isOnboardingPath(String loc) =>
      loc == Routes.onboarding || loc == Routes.faithSelection;

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final onboardingAsync = ref.read(onboardingDoneProvider);
      final splashAsync = ref.read(splashGateProvider);
      final loc = state.matchedLocation;

      // 1. Boot-time gate: pin the splash until everything resolves AND
      // the splash min-delay timer has elapsed.
      final stillBooting = auth.isLoading ||
          !auth.hasValue ||
          onboardingAsync.isLoading ||
          !onboardingAsync.hasValue ||
          splashAsync.isLoading ||
          !splashAsync.hasValue;
      if (stillBooting) {
        return loc == Routes.splash ? null : Routes.splash;
      }

      final authState = auth.value!;
      final onboardingDone = onboardingAsync.value!;
      final isAuthRoute = loc == Routes.login ||
          loc == Routes.register ||
          loc == Routes.splash;

      // 2. First-launch path: drop into onboarding.
      if (!onboardingDone) {
        if (isOnboardingPath(loc)) return null;
        return Routes.onboarding;
      }

      // 3. Onboarding done but no token → login flow.
      if (authState is AuthUnauthenticated) {
        if (isAuthRoute && loc != Routes.splash) return null;
        if (isOnboardingPath(loc)) return null;
        return Routes.login;
      }

      // 4. Authenticated + still on splash/auth/onboarding → home.
      if (authState is AuthAuthenticated &&
          (isAuthRoute || isOnboardingPath(loc))) {
        return Routes.today;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: Routes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      ...onboardingRoutes,
      ...settingsRoutes,
      GoRoute(
        path: Routes.switchFaith,
        builder: (_, __) => const FaithSelectionScreen(standalone: true),
      ),
      ...shareRoutes,
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: todayRoutes),
          StatefulShellBranch(routes: quranRoutes),
          StatefulShellBranch(routes: hadithsRoutes),
          StatefulShellBranch(routes: practiceRoutes),
          StatefulShellBranch(routes: reflectRoutes),
        ],
      ),
    ],
  );
}

/// Bridges auth + onboarding state into go_router's [Listenable]-based
/// refresh so the redirect re-runs when either changes.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _authSub = _ref.listen<AsyncValue<AuthState>>(
      authControllerProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
    _onboardingSub = _ref.listen<AsyncValue<bool>>(
      onboardingDoneProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
    _splashSub = _ref.listen<AsyncValue<bool>>(
      splashGateProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<AuthState>> _authSub;
  late final ProviderSubscription<AsyncValue<bool>> _onboardingSub;
  late final ProviderSubscription<AsyncValue<bool>> _splashSub;

  @override
  void dispose() {
    _authSub.close();
    _onboardingSub.close();
    _splashSub.close();
    super.dispose();
  }
}
