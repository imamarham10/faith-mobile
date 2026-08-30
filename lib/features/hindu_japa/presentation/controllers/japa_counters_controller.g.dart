// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_counters_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$suggestedJapaPhrasesHash() =>
    r'd1ca08b6abc0ba5432ca4d97f8ced96d0c1b370c';

/// Suggested phrases — dictionary entries the user hasn't started yet.
///
/// Copied from [suggestedJapaPhrases].
@ProviderFor(suggestedJapaPhrases)
final suggestedJapaPhrasesProvider =
    AutoDisposeProvider<List<JapaPhrase>>.internal(
      suggestedJapaPhrases,
      name: r'suggestedJapaPhrasesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suggestedJapaPhrasesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuggestedJapaPhrasesRef = AutoDisposeProviderRef<List<JapaPhrase>>;
String _$japaDictionaryHash() => r'f852f64a116b5997949a9ee27f9f436b80c3e18b';

/// Dictionary loader — predefined mantras.
///
/// Copied from [japaDictionary].
@ProviderFor(japaDictionary)
final japaDictionaryProvider = FutureProvider<List<JapaPhrase>>.internal(
  japaDictionary,
  name: r'japaDictionaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$japaDictionaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JapaDictionaryRef = FutureProviderRef<List<JapaPhrase>>;
String _$japaCountersControllerHash() =>
    r'4561e0b107f18626c5f564c387366fd30655b6cc';

/// Loads the user's japa counters and exposes mutating actions. Mirrors
/// `DhikrCountersController` — per-counter increments are owned by
/// [JapaCounterController] (a family) so the count number can update at
/// 60fps without rebuilding the whole list.
///
/// Copied from [JapaCountersController].
@ProviderFor(JapaCountersController)
final japaCountersControllerProvider =
    AsyncNotifierProvider<JapaCountersController, List<JapaCounter>>.internal(
      JapaCountersController.new,
      name: r'japaCountersControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$japaCountersControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JapaCountersController = AsyncNotifier<List<JapaCounter>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
