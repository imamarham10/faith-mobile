// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puja_times_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pujaTimesControllerHash() =>
    r'681cec9b058ed584d2d64240f7a3543f2efd00b5';

/// Fetches today's puja times for the device's current location and real
/// IANA timezone. Mirrors `PrayerTimesController`'s null-on-location-denied
/// pattern exactly. `tz.local.name` is safe to read here without any extra
/// initialization — `NotificationService.init()` already calls
/// `tz.setLocalLocation(...)` once at app start (falling back to UTC if the
/// device's zone abbreviation isn't recognized).
///
/// Copied from [PujaTimesController].
@ProviderFor(PujaTimesController)
final pujaTimesControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PujaTimesController,
      PujaTimesData?
    >.internal(
      PujaTimesController.new,
      name: r'pujaTimesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pujaTimesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PujaTimesController = AutoDisposeAsyncNotifier<PujaTimesData?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
