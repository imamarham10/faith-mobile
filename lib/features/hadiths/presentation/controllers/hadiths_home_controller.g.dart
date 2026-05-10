// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadiths_home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hadithBooksHash() => r'3e93e87a62114e2ac95e57c942c97864fe85f1e4';

/// All hadith collections. Cached for the session — books are static data.
///
/// Copied from [hadithBooks].
@ProviderFor(hadithBooks)
final hadithBooksProvider = FutureProvider<List<HadithBook>>.internal(
  hadithBooks,
  name: r'hadithBooksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hadithBooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HadithBooksRef = FutureProviderRef<List<HadithBook>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
