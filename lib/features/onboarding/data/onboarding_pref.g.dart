// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_pref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingDoneHash() => r'0db086c3829727e94b28dcff1200fab7fd03d1e3';

/// Persists whether the user has completed the onboarding flow.
/// Resolved once at boot; flipped to `true` when the user hits "Get started"
/// at the end of the faith-selection screen. Subsequent launches skip
/// onboarding and go straight to login (or home if already authed).
///
/// Copied from [OnboardingDone].
@ProviderFor(OnboardingDone)
final onboardingDoneProvider =
    AsyncNotifierProvider<OnboardingDone, bool>.internal(
      OnboardingDone.new,
      name: r'onboardingDoneProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingDoneHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingDone = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
