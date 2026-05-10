// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_favorites_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duaFavoritesControllerHash() =>
    r'5e68d902122d2280f5c717e617440695ede9de76';

/// Local-mirror dua favorites.
///
/// The local list is canonical so the UI is instant and works offline. On
/// launch we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Backend currently only exposes `POST /favorites` (no DELETE), so removal
/// is local-only — adequate for Phase 1.
///
/// Copied from [DuaFavoritesController].
@ProviderFor(DuaFavoritesController)
final duaFavoritesControllerProvider =
    AsyncNotifierProvider<DuaFavoritesController, List<Dua>>.internal(
      DuaFavoritesController.new,
      name: r'duaFavoritesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$duaFavoritesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DuaFavoritesController = AsyncNotifier<List<Dua>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
