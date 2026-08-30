// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_temples_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nearbyTemplesControllerHash() =>
    r'09433a6143092b7e67ddf5eba31ffd31c9905447';

/// Fetches temples near the device's current location. Mirrors
/// `PanchangTodayController`'s pattern exactly: returns `null` if location
/// is unavailable so the UI can render a permission-CTA fallback, rather
/// than throwing — like prayer times/panchang, "temples near me" is
/// fundamentally location-gated, not location-optional.
///
/// Copied from [NearbyTemplesController].
@ProviderFor(NearbyTemplesController)
final nearbyTemplesControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      NearbyTemplesController,
      List<Temple>?
    >.internal(
      NearbyTemplesController.new,
      name: r'nearbyTemplesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nearbyTemplesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NearbyTemplesController = AutoDisposeAsyncNotifier<List<Temple>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
