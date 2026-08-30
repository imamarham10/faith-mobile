// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_favorites_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyFavoritesControllerHash() =>
    r'cd92c7a96ee4ddc35b81799cd514c423d175b36f';

/// Local-mirror story favorites. Mirrors `StotraFavoritesController` —
/// local list is canonical/instant, lazily merged with the server, and
/// removal syncs to a real `DELETE` endpoint (unlike hadiths, which skips
/// favorites in v1 entirely).
///
/// Copied from [StoryFavoritesController].
@ProviderFor(StoryFavoritesController)
final storyFavoritesControllerProvider =
    AsyncNotifierProvider<StoryFavoritesController, List<HinduStory>>.internal(
      StoryFavoritesController.new,
      name: r'storyFavoritesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$storyFavoritesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StoryFavoritesController = AsyncNotifier<List<HinduStory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
