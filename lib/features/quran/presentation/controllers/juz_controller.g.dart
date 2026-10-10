// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$juzIndexHash() => r'd8e2db02a969dcc6adce2f749a6a64f1c87092f0';

/// Loads the 30-juz chooser.
///
/// **Lazy on purpose.** Riverpod only runs this when something first
/// watches it, and the only thing that does is the Juz segment's list. Open
/// the Qur'an tab and stay on Surah and `GET /juz` is never called — this
/// adds no request to tab open and none at all to app start.
///
/// Copied from [juzIndex].
@ProviderFor(juzIndex)
final juzIndexProvider = FutureProvider<List<JuzSummary>>.internal(
  juzIndex,
  name: r'juzIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$juzIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JuzIndexRef = FutureProviderRef<List<JuzSummary>>;
String _$filteredJuzHash() => r'a5e386335a129732cd84823d3b78cdd6aad662a4';

/// Filters [juzIndexProvider] by the shared search box.
///
/// Shares [surahSearchQueryProvider] with the surah list rather than keeping
/// a second query, so switching segments mid-search keeps what you typed and
/// shows you the other index's answer to it.
///
/// Matches, in order of what people actually type:
/// * the juz number itself ("18");
/// * either end's surah name, which the chooser payload already carries;
/// * any surah in the juz's span, which needs the 114-surah index — so this
///   widening only applies when that list happens to be loaded already. It
///   is never fetched for the sake of search.
///
/// Copied from [filteredJuz].
@ProviderFor(filteredJuz)
final filteredJuzProvider = AutoDisposeProvider<List<JuzSummary>>.internal(
  filteredJuz,
  name: r'filteredJuzProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredJuzHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredJuzRef = AutoDisposeProviderRef<List<JuzSummary>>;
String _$quranBrowseModeControllerHash() =>
    r'3343059765359f6611f541be2cd2179c06b95783';

/// The Surah | Juz segmented control's selection.
///
/// Not persisted: the surah index is the right thing to land on when you
/// open the tab cold, and a sticky Juz segment would mean someone who read
/// one juz last week opens the tab to a list of 30 numbers.
///
/// Copied from [QuranBrowseModeController].
@ProviderFor(QuranBrowseModeController)
final quranBrowseModeControllerProvider =
    AutoDisposeNotifierProvider<
      QuranBrowseModeController,
      QuranBrowseMode
    >.internal(
      QuranBrowseModeController.new,
      name: r'quranBrowseModeControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quranBrowseModeControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuranBrowseModeController = AutoDisposeNotifier<QuranBrowseMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
