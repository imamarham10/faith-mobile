// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$surahListHash() => r'042ca4f3410a39a78f3fe47f568cc53cc6bf0f41';

/// Loads the 114-surah index. Cached for the session via `keepAlive`.
///
/// Copied from [surahList].
@ProviderFor(surahList)
final surahListProvider = FutureProvider<List<Surah>>.internal(
  surahList,
  name: r'surahListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$surahListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SurahListRef = FutureProviderRef<List<Surah>>;
String _$filteredSurahsHash() => r'd53f5e81f2a0ca57549c69a10c9a9c3b1bfe371d';

/// Filters [surahListProvider] by name / transliteration / number.
///
/// Copied from [filteredSurahs].
@ProviderFor(filteredSurahs)
final filteredSurahsProvider = AutoDisposeProvider<List<Surah>>.internal(
  filteredSurahs,
  name: r'filteredSurahsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredSurahsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSurahsRef = AutoDisposeProviderRef<List<Surah>>;
String _$lastReadControllerHash() =>
    r'2b3cde1db26c70a9090b4ccd44709c2e8df5c3da';

/// Persists / reads the last-read pointer. Updated by the reader on
/// scroll-stop; surfaced on the home screen as a "Continue reading" card.
///
/// Copied from [LastReadController].
@ProviderFor(LastReadController)
final lastReadControllerProvider =
    AsyncNotifierProvider<LastReadController, LastRead?>.internal(
      LastReadController.new,
      name: r'lastReadControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lastReadControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LastReadController = AsyncNotifier<LastRead?>;
String _$surahSearchQueryHash() => r'0cf92268d5f4bfa005b3c78583ab5610b4682ab7';

/// Search query state for the home screen list filter.
///
/// Copied from [SurahSearchQuery].
@ProviderFor(SurahSearchQuery)
final surahSearchQueryProvider =
    AutoDisposeNotifierProvider<SurahSearchQuery, String>.internal(
      SurahSearchQuery.new,
      name: r'surahSearchQueryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$surahSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SurahSearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
