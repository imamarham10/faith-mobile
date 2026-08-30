// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hindu_emotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hinduEmotionsHash() => r'59d861966b8bb400fda5e030baba58dbcb219311';

/// All available Hindu emotions. Unlike Islam's `emotionsProvider`, no
/// client-side fallback list — the backend is fully seeded (10 emotions).
///
/// Copied from [hinduEmotions].
@ProviderFor(hinduEmotions)
final hinduEmotionsProvider = FutureProvider<List<HinduEmotion>>.internal(
  hinduEmotions,
  name: r'hinduEmotionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hinduEmotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HinduEmotionsRef = FutureProviderRef<List<HinduEmotion>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
