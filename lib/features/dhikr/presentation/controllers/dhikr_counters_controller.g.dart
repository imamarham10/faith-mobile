// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_counters_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$suggestedPhrasesHash() => r'ab1166431e37ea0d253b6099c3c8ff43d39fe014';

/// Suggested phrases — dictionary entries the user hasn't started yet.
///
/// Copied from [suggestedPhrases].
@ProviderFor(suggestedPhrases)
final suggestedPhrasesProvider =
    AutoDisposeProvider<List<DhikrPhrase>>.internal(
      suggestedPhrases,
      name: r'suggestedPhrasesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suggestedPhrasesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuggestedPhrasesRef = AutoDisposeProviderRef<List<DhikrPhrase>>;
String _$dhikrDictionaryHash() => r'c385ca2dfa8694d434397d203e70a6c5ec89e855';

/// Dictionary loader — predefined phrases.
///
/// Copied from [dhikrDictionary].
@ProviderFor(dhikrDictionary)
final dhikrDictionaryProvider = FutureProvider<List<DhikrPhrase>>.internal(
  dhikrDictionary,
  name: r'dhikrDictionaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dhikrDictionaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DhikrDictionaryRef = FutureProviderRef<List<DhikrPhrase>>;
String _$dhikrCountersControllerHash() =>
    r'6a3c574005f85056c615fb4ea1470e87a7503426';

/// Loads the user's dhikr counters and exposes mutating actions.
///
/// Counter writes (create / delete / rename) refresh the list from the
/// server. Per-counter increments are owned by [DhikrCounterController]
/// (a family) so the count number can update at 60fps without rebuilding
/// the whole list.
///
/// Copied from [DhikrCountersController].
@ProviderFor(DhikrCountersController)
final dhikrCountersControllerProvider =
    AsyncNotifierProvider<DhikrCountersController, List<DhikrCounter>>.internal(
      DhikrCountersController.new,
      name: r'dhikrCountersControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dhikrCountersControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DhikrCountersController = AsyncNotifier<List<DhikrCounter>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
