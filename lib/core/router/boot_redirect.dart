import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/auth_state.dart';
import 'routes.dart';

bool _isOnboardingPath(String loc) =>
    loc == Routes.onboarding || loc == Routes.faithSelection;

/// An [AsyncValue] has stopped waiting on the network/disk once it holds
/// either a value or an error. Only `AsyncLoading` with nothing behind it is
/// still booting.
bool _resolved(AsyncValue<Object?> v) => v.hasValue || v.hasError;

/// The whole boot-time route decision, as a pure function.
///
/// Returns the location to redirect to, or `null` to leave the router where
/// it is. Priority order:
///   1. Anything still resolving → stay on /splash.
///   2. Onboarding not done → /onboarding (or its faith sub-route).
///   3. Onboarding done + unauthenticated → /login (allow /register too).
///   4. Authenticated + on an auth/splash/onboarding route → /today.
///
/// Extracted from the router's `redirect` callback so these five interacting
/// conditions can be tested without standing up a GoRouter, a ProviderScope
/// and the whole screen tree.
String? resolveBootRedirect({
  required AsyncValue<AuthState> auth,
  required AsyncValue<bool> onboarding,
  required AsyncValue<bool> splash,
  required String location,
}) {
  // An AsyncError here means we asked and got a definitive "no" — an expired
  // refresh token, a 500, no DNS. That is resolved, not still-booting. The
  // previous `!auth.hasValue` check treated it as booting forever and pinned
  // the splash with no way out but a reinstall.
  final authState = auth.valueOrNull;

  // AuthInitializing is the state we sit in while reading secure storage, so
  // it genuinely is still booting. AuthController never emits it today, but
  // handling it explicitly keeps it from falling through to `return null`,
  // which on /splash would be a second permanent pin.
  final stillBooting = !_resolved(auth) ||
      authState is AuthInitializing ||
      !_resolved(onboarding) ||
      !_resolved(splash);
  if (stillBooting) {
    return location == Routes.splash ? null : Routes.splash;
  }

  // A failed SharedPreferences read tells us nothing about whether onboarding
  // was completed. Assume it was not: the cost is a repeated onboarding pass,
  // against a splash that never ends.
  final onboardingDone = onboarding.valueOrNull ?? false;
  final isAuthRoute = location == Routes.login ||
      location == Routes.register ||
      location == Routes.splash;

  // 2. First-launch path: drop into onboarding.
  if (!onboardingDone) {
    if (_isOnboardingPath(location)) return null;
    return Routes.onboarding;
  }

  // 3. Onboarding done but no usable session → login flow. `authState` is
  // null when auth errored, which is exactly "no usable session".
  if (authState == null || authState is AuthUnauthenticated) {
    if (isAuthRoute && location != Routes.splash) return null;
    if (_isOnboardingPath(location)) return null;
    return Routes.login;
  }

  // 4. Authenticated + still on splash/auth/onboarding → home.
  if (authState is AuthAuthenticated &&
      (isAuthRoute || _isOnboardingPath(location))) {
    return Routes.today;
  }

  return null;
}
