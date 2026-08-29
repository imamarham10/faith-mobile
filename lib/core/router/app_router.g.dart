// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$splashGateHash() => r'833a970a4aee4461d27c06691b79503901adec4d';

/// Holds the splash for a minimum window so the brand reveal animation can
/// breathe even on warm starts where auth + onboarding resolve instantly.
///
/// Copied from [splashGate].
@ProviderFor(splashGate)
final splashGateProvider = FutureProvider<bool>.internal(
  splashGate,
  name: r'splashGateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$splashGateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SplashGateRef = FutureProviderRef<bool>;
String _$appRouterHash() => r'e16b4b18ccc78d6c2de7d1f8fb3f6874afa1d4f0';

/// Top-level GoRouter, wired to [AuthController] + [OnboardingDone] so route
/// guards re-evaluate when either resolves.
///
/// Redirect logic, in priority order:
///   1. Auth still bootstrapping → stay on /splash.
///   2. Onboarding pref still resolving → stay on /splash.
///   3. Onboarding not done → /onboarding (or its faith sub-route).
///   4. Onboarding done + unauthenticated → /login (allow /register too).
///   5. Authenticated + on auth/splash/onboarding route → /today.
///
/// Copied from [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = Provider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = ProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
