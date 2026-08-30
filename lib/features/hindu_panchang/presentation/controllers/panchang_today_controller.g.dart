// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_today_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$panchangTodayControllerHash() =>
    r'a89c49b3730348742075c03cd78cbb167f4a2ac4';

/// Fetches today's panchang for the device's current location. Mirrors
/// `PrayerTimesController`'s pattern exactly: returns `null` if location is
/// unavailable so the UI can render a permission-CTA fallback, rather than
/// throwing (unlike Qibla's sentinel-exception pattern) — panchang, like
/// prayer times, is fundamentally location-gated rather than
/// location-optional.
///
/// Copied from [PanchangTodayController].
@ProviderFor(PanchangTodayController)
final panchangTodayControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PanchangTodayController,
      PanchangDay?
    >.internal(
      PanchangTodayController.new,
      name: r'panchangTodayControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$panchangTodayControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PanchangTodayController = AutoDisposeAsyncNotifier<PanchangDay?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
