// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temple_favorites_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$templeFavoritesControllerHash() =>
    r'd7bab09d5db533c6b80cb9c39777630161e84c14';

/// Local-mirror temple favorites. Mirrors `StotraFavoritesController`/
/// `StoryFavoritesController` — local list is canonical/instant, lazily
/// merged with the server, and removal syncs to a real `DELETE` endpoint.
///
/// Copied from [TempleFavoritesController].
@ProviderFor(TempleFavoritesController)
final templeFavoritesControllerProvider =
    AsyncNotifierProvider<TempleFavoritesController, List<Temple>>.internal(
      TempleFavoritesController.new,
      name: r'templeFavoritesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$templeFavoritesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TempleFavoritesController = AsyncNotifier<List<Temple>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
