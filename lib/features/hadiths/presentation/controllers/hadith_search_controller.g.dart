// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hadithSearchHash() => r'46291edd92a7df9fc2d59304474d2aab0e4d91b5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Server-side search across the free-tier hadith corpus.
///
/// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
/// that here so we don't fire a request per keystroke during typing.
///
/// Copied from [hadithSearch].
@ProviderFor(hadithSearch)
const hadithSearchProvider = HadithSearchFamily();

/// Server-side search across the free-tier hadith corpus.
///
/// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
/// that here so we don't fire a request per keystroke during typing.
///
/// Copied from [hadithSearch].
class HadithSearchFamily extends Family<AsyncValue<List<Hadith>>> {
  /// Server-side search across the free-tier hadith corpus.
  ///
  /// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
  /// that here so we don't fire a request per keystroke during typing.
  ///
  /// Copied from [hadithSearch].
  const HadithSearchFamily();

  /// Server-side search across the free-tier hadith corpus.
  ///
  /// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
  /// that here so we don't fire a request per keystroke during typing.
  ///
  /// Copied from [hadithSearch].
  HadithSearchProvider call(String query) {
    return HadithSearchProvider(query);
  }

  @override
  HadithSearchProvider getProviderOverride(
    covariant HadithSearchProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hadithSearchProvider';
}

/// Server-side search across the free-tier hadith corpus.
///
/// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
/// that here so we don't fire a request per keystroke during typing.
///
/// Copied from [hadithSearch].
class HadithSearchProvider extends AutoDisposeFutureProvider<List<Hadith>> {
  /// Server-side search across the free-tier hadith corpus.
  ///
  /// The backend ignores queries shorter than 3 chars (returns `[]`); we mirror
  /// that here so we don't fire a request per keystroke during typing.
  ///
  /// Copied from [hadithSearch].
  HadithSearchProvider(String query)
    : this._internal(
        (ref) => hadithSearch(ref as HadithSearchRef, query),
        from: hadithSearchProvider,
        name: r'hadithSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hadithSearchHash,
        dependencies: HadithSearchFamily._dependencies,
        allTransitiveDependencies:
            HadithSearchFamily._allTransitiveDependencies,
        query: query,
      );

  HadithSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Hadith>> Function(HadithSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HadithSearchProvider._internal(
        (ref) => create(ref as HadithSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Hadith>> createElement() {
    return _HadithSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HadithSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HadithSearchRef on AutoDisposeFutureProviderRef<List<Hadith>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _HadithSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Hadith>>
    with HadithSearchRef {
  _HadithSearchProviderElement(super.provider);

  @override
  String get query => (origin as HadithSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
