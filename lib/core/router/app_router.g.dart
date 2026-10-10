// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$splashGateHash() => r'bf0360f8d27af7a9376cd64b227ad24ea6790403';

/// Holds the splash for a minimum window so the brand reveal animation can
/// play through even on warm starts where auth + onboarding resolve
/// instantly.
///
/// The window is [kSplashDwell], which the splash screen derives from its
/// own choreography rather than naming here — this gate and the animation
/// are one decision, and a number duplicated in two files is a number that
/// drifts. Nothing is on the wire while this runs, so every millisecond of
/// it is paid in full on every cold start.
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
String _$appRouterHash() => r'36c1287b5b98829f7a98dad51aa3696fe8219bfe';

/// Top-level GoRouter, wired to [AuthController] + [OnboardingDone] so route
/// guards re-evaluate when either resolves.
///
/// The redirect decision itself lives in [resolveBootRedirect] — a pure
/// function, so the boot gate is testable without a widget tree.
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
