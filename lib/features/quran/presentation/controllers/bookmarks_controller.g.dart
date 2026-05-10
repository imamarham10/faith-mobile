// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookmarksControllerHash() =>
    r'7895e1ce01869e903912b98ff7e6f294fbe41830';

/// Local-mirror bookmark store.
///
/// Server-side bookmarks are best-effort; the local list is canonical so the
/// UI is always instant and works offline. On launch we hydrate from
/// `shared_preferences` and lazily merge any newer server bookmarks.
///
/// Copied from [BookmarksController].
@ProviderFor(BookmarksController)
final bookmarksControllerProvider =
    AsyncNotifierProvider<BookmarksController, List<Bookmark>>.internal(
      BookmarksController.new,
      name: r'bookmarksControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookmarksControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookmarksController = AsyncNotifier<List<Bookmark>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
