// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scripture_bookmarks_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scriptureBookmarksControllerHash() =>
    r'b234f0dc2a51f6511953e77121c33770cb7ef140';

/// Local-mirror bookmark store, keyed by `verseId` (simpler than Quran's
/// `surahId:verseNumber` composite key since the backend keys bookmarks
/// purely off verse id). Server-side bookmarks are best-effort; the local
/// list is canonical so the UI is instant and works offline.
///
/// Copied from [ScriptureBookmarksController].
@ProviderFor(ScriptureBookmarksController)
final scriptureBookmarksControllerProvider =
    AsyncNotifierProvider<
      ScriptureBookmarksController,
      List<ScriptureBookmark>
    >.internal(
      ScriptureBookmarksController.new,
      name: r'scriptureBookmarksControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scriptureBookmarksControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScriptureBookmarksController = AsyncNotifier<List<ScriptureBookmark>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
