// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calcMethodPrefHash() => r'25668544deb5d851c95f08fa65a3469072e97f13';

/// Persisted calculation-method code (defaults to MWL on first run).
///
/// Copied from [CalcMethodPref].
@ProviderFor(CalcMethodPref)
final calcMethodPrefProvider =
    AsyncNotifierProvider<CalcMethodPref, String>.internal(
      CalcMethodPref.new,
      name: r'calcMethodPrefProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calcMethodPrefHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CalcMethodPref = AsyncNotifier<String>;
String _$prayerTimesControllerHash() =>
    r'5daaf876ccf3ef401a9d6288e51d7f1866067f4f';

/// Fetches today's prayer times for the device's current location and the
/// user's saved calculation method, then derives [NextPrayer] from them.
///
/// Returns `null` for [PrayerTimesData] if location is unavailable so the UI
/// can render a permission-CTA fallback. Repository errors propagate as
/// [AsyncError].
///
/// Copied from [PrayerTimesController].
@ProviderFor(PrayerTimesController)
final prayerTimesControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PrayerTimesController,
      PrayerTimesData?
    >.internal(
      PrayerTimesController.new,
      name: r'prayerTimesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$prayerTimesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PrayerTimesController = AutoDisposeAsyncNotifier<PrayerTimesData?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
