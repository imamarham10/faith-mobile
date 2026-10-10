// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionsHash() => r'efe0324a3516d2d904ad28fa5a8df8944b40a740';

/// Every mood the Islam vertical can actually answer, straight from
/// `GET /api/v1/islam/feelings`.
///
/// There is no client-side fallback list on purpose. A hardcoded slug cannot
/// be known to exist server-side, so a fallback can only ever offer options
/// the detail endpoint will reject — which is precisely how this feature
/// broke: a nine-mood const shipped in the binary overlapped the seeded data
/// in three slugs, and the other six 404'd on tap. An empty chooser with a
/// retry is a better failure than a chooser full of dead ends.
///
/// Copied from [emotions].
@ProviderFor(emotions)
final emotionsProvider = FutureProvider<List<Emotion>>.internal(
  emotions,
  name: r'emotionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmotionsRef = FutureProviderRef<List<Emotion>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
