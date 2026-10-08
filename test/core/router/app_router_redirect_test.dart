import 'package:faith_mobile/core/router/boot_redirect.dart';
import 'package:faith_mobile/core/router/routes.dart';
import 'package:faith_mobile/features/auth/domain/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _authed = AsyncData<AuthState>(
  AuthAuthenticated(accessToken: 'token'),
);
const _anon = AsyncData<AuthState>(AuthUnauthenticated());
const _onboarded = AsyncData(true);
const _splashElapsed = AsyncData(true);

void main() {
  group('resolveBootRedirect — boot gate', () {
    test('auth error routes to login, not an infinite splash', () {
      final target = resolveBootRedirect(
        auth: const AsyncError('token expired', StackTrace.empty),
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.splash,
      );
      expect(target, Routes.login);
    });

    test('auth still loading holds the splash', () {
      final target = resolveBootRedirect(
        auth: const AsyncLoading(),
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.splash,
      );
      expect(target, isNull); // already on splash, stay
    });

    test('auth still loading pulls a deep link back to the splash', () {
      final target = resolveBootRedirect(
        auth: const AsyncLoading(),
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.quran,
      );
      expect(target, Routes.splash);
    });

    test('the splash min-delay timer alone holds the splash', () {
      final target = resolveBootRedirect(
        auth: _authed,
        onboarding: _onboarded,
        splash: const AsyncLoading(),
        location: Routes.today,
      );
      expect(target, Routes.splash);
    });

    test('an onboarding-pref read error falls through to onboarding', () {
      // A failed SharedPreferences read is resolved-and-unknown, not booting.
      // Treating it as unknown means a first-launch user still gets onboarding
      // rather than a splash that never ends.
      final target = resolveBootRedirect(
        auth: _anon,
        onboarding: const AsyncError('prefs unavailable', StackTrace.empty),
        splash: _splashElapsed,
        location: Routes.splash,
      );
      expect(target, Routes.onboarding);
    });

    test('both auth and onboarding failing still lands somewhere usable', () {
      final target = resolveBootRedirect(
        auth: const AsyncError('500', StackTrace.empty),
        onboarding: const AsyncError('prefs unavailable', StackTrace.empty),
        splash: _splashElapsed,
        location: Routes.splash,
      );
      expect(target, Routes.onboarding);
    });

    test('AuthInitializing is treated as still booting', () {
      // The controller never emits this today — build() resolves to
      // authenticated or unauthenticated. It is handled explicitly so the
      // behaviour is a decision rather than a fall-through `return null`,
      // which on /splash would be another permanent pin.
      final target = resolveBootRedirect(
        auth: const AsyncData<AuthState>(AuthInitializing()),
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.today,
      );
      expect(target, Routes.splash);
    });
  });

  group('resolveBootRedirect — first launch', () {
    test('onboarding not done sends a splash user to onboarding', () {
      final target = resolveBootRedirect(
        auth: _anon,
        onboarding: const AsyncData(false),
        splash: _splashElapsed,
        location: Routes.splash,
      );
      expect(target, Routes.onboarding);
    });

    test('onboarding not done leaves the onboarding route alone', () {
      for (final loc in [Routes.onboarding, Routes.faithSelection]) {
        expect(
          resolveBootRedirect(
            auth: _anon,
            onboarding: const AsyncData(false),
            splash: _splashElapsed,
            location: loc,
          ),
          isNull,
          reason: loc,
        );
      }
    });

    test('onboarding not done outranks an existing session', () {
      final target = resolveBootRedirect(
        auth: _authed,
        onboarding: const AsyncData(false),
        splash: _splashElapsed,
        location: Routes.today,
      );
      expect(target, Routes.onboarding);
    });
  });

  group('resolveBootRedirect — unauthenticated', () {
    test('a protected route redirects to login', () {
      final target = resolveBootRedirect(
        auth: _anon,
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.today,
      );
      expect(target, Routes.login);
    });

    test('the splash hands off to login once everything resolves', () {
      final target = resolveBootRedirect(
        auth: _anon,
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.splash,
      );
      expect(target, Routes.login);
    });

    test('login and register are reachable', () {
      for (final loc in [Routes.login, Routes.register]) {
        expect(
          resolveBootRedirect(
            auth: _anon,
            onboarding: _onboarded,
            splash: _splashElapsed,
            location: loc,
          ),
          isNull,
          reason: loc,
        );
      }
    });

    test('onboarding stays revisitable while signed out', () {
      final target = resolveBootRedirect(
        auth: _anon,
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.faithSelection,
      );
      expect(target, isNull);
    });
  });

  group('resolveBootRedirect — authenticated', () {
    test('splash, login and register all hand off to today', () {
      for (final loc in [Routes.splash, Routes.login, Routes.register]) {
        expect(
          resolveBootRedirect(
            auth: _authed,
            onboarding: _onboarded,
            splash: _splashElapsed,
            location: loc,
          ),
          Routes.today,
          reason: loc,
        );
      }
    });

    test('a re-entered onboarding route hands off to today', () {
      final target = resolveBootRedirect(
        auth: _authed,
        onboarding: _onboarded,
        splash: _splashElapsed,
        location: Routes.onboarding,
      );
      expect(target, Routes.today);
    });

    test('ordinary app routes are left alone', () {
      for (final loc in [
        Routes.today,
        Routes.quran,
        Routes.hadiths,
        Routes.practice,
        Routes.reflect,
        Routes.switchFaith,
      ]) {
        expect(
          resolveBootRedirect(
            auth: _authed,
            onboarding: _onboarded,
            splash: _splashElapsed,
            location: loc,
          ),
          isNull,
          reason: loc,
        );
      }
    });
  });
}
