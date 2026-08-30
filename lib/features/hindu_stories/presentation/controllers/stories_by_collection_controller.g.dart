// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_by_collection_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storiesByCollectionHash() =>
    r'408f3d8bd6e99b671e5926323cbf4e1868a22a0f';

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

/// All stories inside a specific collection (by slug). Cached so back-nav
/// is instant.
///
/// Copied from [storiesByCollection].
@ProviderFor(storiesByCollection)
const storiesByCollectionProvider = StoriesByCollectionFamily();

/// All stories inside a specific collection (by slug). Cached so back-nav
/// is instant.
///
/// Copied from [storiesByCollection].
class StoriesByCollectionFamily extends Family<AsyncValue<List<HinduStory>>> {
  /// All stories inside a specific collection (by slug). Cached so back-nav
  /// is instant.
  ///
  /// Copied from [storiesByCollection].
  const StoriesByCollectionFamily();

  /// All stories inside a specific collection (by slug). Cached so back-nav
  /// is instant.
  ///
  /// Copied from [storiesByCollection].
  StoriesByCollectionProvider call(String collectionSlug) {
    return StoriesByCollectionProvider(collectionSlug);
  }

  @override
  StoriesByCollectionProvider getProviderOverride(
    covariant StoriesByCollectionProvider provider,
  ) {
    return call(provider.collectionSlug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storiesByCollectionProvider';
}

/// All stories inside a specific collection (by slug). Cached so back-nav
/// is instant.
///
/// Copied from [storiesByCollection].
class StoriesByCollectionProvider extends FutureProvider<List<HinduStory>> {
  /// All stories inside a specific collection (by slug). Cached so back-nav
  /// is instant.
  ///
  /// Copied from [storiesByCollection].
  StoriesByCollectionProvider(String collectionSlug)
    : this._internal(
        (ref) =>
            storiesByCollection(ref as StoriesByCollectionRef, collectionSlug),
        from: storiesByCollectionProvider,
        name: r'storiesByCollectionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$storiesByCollectionHash,
        dependencies: StoriesByCollectionFamily._dependencies,
        allTransitiveDependencies:
            StoriesByCollectionFamily._allTransitiveDependencies,
        collectionSlug: collectionSlug,
      );

  StoriesByCollectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionSlug,
  }) : super.internal();

  final String collectionSlug;

  @override
  Override overrideWith(
    FutureOr<List<HinduStory>> Function(StoriesByCollectionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoriesByCollectionProvider._internal(
        (ref) => create(ref as StoriesByCollectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionSlug: collectionSlug,
      ),
    );
  }

  @override
  FutureProviderElement<List<HinduStory>> createElement() {
    return _StoriesByCollectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoriesByCollectionProvider &&
        other.collectionSlug == collectionSlug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionSlug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StoriesByCollectionRef on FutureProviderRef<List<HinduStory>> {
  /// The parameter `collectionSlug` of this provider.
  String get collectionSlug;
}

class _StoriesByCollectionProviderElement
    extends FutureProviderElement<List<HinduStory>>
    with StoriesByCollectionRef {
  _StoriesByCollectionProviderElement(super.provider);

  @override
  String get collectionSlug =>
      (origin as StoriesByCollectionProvider).collectionSlug;
}

String _$storiesSearchHash() => r'1005163183b9782f12e1bcfa3057b2058a65b9ee';

/// Server-side search across all stories. Not `keepAlive` — per-query
/// results aren't worth caching indefinitely.
///
/// Copied from [storiesSearch].
@ProviderFor(storiesSearch)
const storiesSearchProvider = StoriesSearchFamily();

/// Server-side search across all stories. Not `keepAlive` — per-query
/// results aren't worth caching indefinitely.
///
/// Copied from [storiesSearch].
class StoriesSearchFamily extends Family<AsyncValue<List<HinduStory>>> {
  /// Server-side search across all stories. Not `keepAlive` — per-query
  /// results aren't worth caching indefinitely.
  ///
  /// Copied from [storiesSearch].
  const StoriesSearchFamily();

  /// Server-side search across all stories. Not `keepAlive` — per-query
  /// results aren't worth caching indefinitely.
  ///
  /// Copied from [storiesSearch].
  StoriesSearchProvider call(String query) {
    return StoriesSearchProvider(query);
  }

  @override
  StoriesSearchProvider getProviderOverride(
    covariant StoriesSearchProvider provider,
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
  String? get name => r'storiesSearchProvider';
}

/// Server-side search across all stories. Not `keepAlive` — per-query
/// results aren't worth caching indefinitely.
///
/// Copied from [storiesSearch].
class StoriesSearchProvider
    extends AutoDisposeFutureProvider<List<HinduStory>> {
  /// Server-side search across all stories. Not `keepAlive` — per-query
  /// results aren't worth caching indefinitely.
  ///
  /// Copied from [storiesSearch].
  StoriesSearchProvider(String query)
    : this._internal(
        (ref) => storiesSearch(ref as StoriesSearchRef, query),
        from: storiesSearchProvider,
        name: r'storiesSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$storiesSearchHash,
        dependencies: StoriesSearchFamily._dependencies,
        allTransitiveDependencies:
            StoriesSearchFamily._allTransitiveDependencies,
        query: query,
      );

  StoriesSearchProvider._internal(
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
    FutureOr<List<HinduStory>> Function(StoriesSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoriesSearchProvider._internal(
        (ref) => create(ref as StoriesSearchRef),
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
  AutoDisposeFutureProviderElement<List<HinduStory>> createElement() {
    return _StoriesSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoriesSearchProvider && other.query == query;
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
mixin StoriesSearchRef on AutoDisposeFutureProviderRef<List<HinduStory>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _StoriesSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<HinduStory>>
    with StoriesSearchRef {
  _StoriesSearchProviderElement(super.provider);

  @override
  String get query => (origin as StoriesSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
