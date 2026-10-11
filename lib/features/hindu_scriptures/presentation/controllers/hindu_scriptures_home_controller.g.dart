// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hindu_scriptures_home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scriptureTextListHash() => r'57a661ce7e75c0f1b39c76867ed49290895538f2';

/// Loads all scripture texts. Cached for the session, mirroring
/// `surahListProvider`'s `keepAlive` rationale.
///
/// Copied from [scriptureTextList].
@ProviderFor(scriptureTextList)
final scriptureTextListProvider = FutureProvider<List<ScriptureText>>.internal(
  scriptureTextList,
  name: r'scriptureTextListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scriptureTextListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScriptureTextListRef = FutureProviderRef<List<ScriptureText>>;
String _$filteredScriptureTextsHash() =>
    r'32bff6cae7d9fdb337fe2e937049db98117888d8';

/// Filters [scriptureTextListProvider] by name.
///
/// Copied from [filteredScriptureTexts].
@ProviderFor(filteredScriptureTexts)
final filteredScriptureTextsProvider =
    AutoDisposeProvider<List<ScriptureText>>.internal(
      filteredScriptureTexts,
      name: r'filteredScriptureTextsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredScriptureTextsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredScriptureTextsRef = AutoDisposeProviderRef<List<ScriptureText>>;
String _$scriptureLastReadControllerHash() =>
    r'ca158cfe96226bc062ffad73ee347e992b45508b';

/// See also [ScriptureLastReadController].
@ProviderFor(ScriptureLastReadController)
final scriptureLastReadControllerProvider =
    AsyncNotifierProvider<
      ScriptureLastReadController,
      ScriptureLastRead?
    >.internal(
      ScriptureLastReadController.new,
      name: r'scriptureLastReadControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scriptureLastReadControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScriptureLastReadController = AsyncNotifier<ScriptureLastRead?>;
String _$scriptureSearchQueryHash() =>
    r'bf46caafaa9695a60c9b6e64c2f5a473b1fb739a';

/// Search query state for the home screen list filter.
///
/// Copied from [ScriptureSearchQuery].
@ProviderFor(ScriptureSearchQuery)
final scriptureSearchQueryProvider =
    AutoDisposeNotifierProvider<ScriptureSearchQuery, String>.internal(
      ScriptureSearchQuery.new,
      name: r'scriptureSearchQueryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scriptureSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScriptureSearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
