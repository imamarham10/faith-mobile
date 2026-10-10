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
import 'boot_redirect.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// Holds the splash for a minimum window so the brand reveal animation can
/// play through even on warm starts where auth + onboarding resolve
/// instantly.
///
/// The window is [kSplashDwell], which the splash screen derives from its
/// own choreography rather than naming here — this gate and the animation
/// are one decision, and a number duplicated in two files is a number that
/// drifts. Nothing is on the wire while this runs, so every millisecond of
/// it is paid in full on every cold start.
@Riverpod(keepAlive: true)
Future<bool> splashGate(Ref ref) async {
  await Future<void>.delayed(kSplashDwell);
  return true;
}

/// Top-level GoRouter, wired to [AuthController] + [OnboardingDone] so route
/// guards re-evaluate when either resolves.
///
/// The redirect decision itself lives in [resolveBootRedirect] — a pure
/// function, so the boot gate is testable without a widget tree.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final notifier = _RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: (context, state) => resolveBootRedirect(
      auth: ref.read(authControllerProvider),
      onboarding: ref.read(onboardingDoneProvider),
      splash: ref.read(splashGateProvider),
      location: state.matchedLocation,
    ),
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
