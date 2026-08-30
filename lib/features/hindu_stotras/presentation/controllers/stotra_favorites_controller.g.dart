// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stotra_favorites_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stotraFavoritesControllerHash() =>
    r'76393b0e5d554209afb5f56e5a1db9c1b85acceb';

/// Local-mirror stotra favorites.
///
/// The local list is canonical so the UI is instant and works offline. On
/// launch we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Unlike Dhikr/Duas (whose favorites are add-only, no DELETE endpoint),
/// this backend exposes `DELETE /favorites/:stotraId`, so [toggle] syncs
/// removal to the server too, not just locally.
///
/// Copied from [StotraFavoritesController].
@ProviderFor(StotraFavoritesController)
final stotraFavoritesControllerProvider =
    AsyncNotifierProvider<StotraFavoritesController, List<Stotra>>.internal(
      StotraFavoritesController.new,
      name: r'stotraFavoritesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stotraFavoritesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StotraFavoritesController = AsyncNotifier<List<Stotra>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
