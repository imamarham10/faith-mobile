// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stotras_by_category_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stotrasByCategoryHash() => r'c9079246020fc5444d384b3657f26f0dd466e561';

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

/// All stotras inside a specific category (by slug). Cached so back-nav is
/// instant.
///
/// Copied from [stotrasByCategory].
@ProviderFor(stotrasByCategory)
const stotrasByCategoryProvider = StotrasByCategoryFamily();

/// All stotras inside a specific category (by slug). Cached so back-nav is
/// instant.
///
/// Copied from [stotrasByCategory].
class StotrasByCategoryFamily extends Family<AsyncValue<List<Stotra>>> {
  /// All stotras inside a specific category (by slug). Cached so back-nav is
  /// instant.
  ///
  /// Copied from [stotrasByCategory].
  const StotrasByCategoryFamily();

  /// All stotras inside a specific category (by slug). Cached so back-nav is
  /// instant.
  ///
  /// Copied from [stotrasByCategory].
  StotrasByCategoryProvider call(String categorySlug) {
    return StotrasByCategoryProvider(categorySlug);
  }

  @override
  StotrasByCategoryProvider getProviderOverride(
    covariant StotrasByCategoryProvider provider,
  ) {
    return call(provider.categorySlug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stotrasByCategoryProvider';
}

/// All stotras inside a specific category (by slug). Cached so back-nav is
/// instant.
///
/// Copied from [stotrasByCategory].
class StotrasByCategoryProvider extends FutureProvider<List<Stotra>> {
  /// All stotras inside a specific category (by slug). Cached so back-nav is
  /// instant.
  ///
  /// Copied from [stotrasByCategory].
  StotrasByCategoryProvider(String categorySlug)
    : this._internal(
        (ref) => stotrasByCategory(ref as StotrasByCategoryRef, categorySlug),
        from: stotrasByCategoryProvider,
        name: r'stotrasByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stotrasByCategoryHash,
        dependencies: StotrasByCategoryFamily._dependencies,
        allTransitiveDependencies:
            StotrasByCategoryFamily._allTransitiveDependencies,
        categorySlug: categorySlug,
      );

  StotrasByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categorySlug,
  }) : super.internal();

  final String categorySlug;

  @override
  Override overrideWith(
    FutureOr<List<Stotra>> Function(StotrasByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StotrasByCategoryProvider._internal(
        (ref) => create(ref as StotrasByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categorySlug: categorySlug,
      ),
    );
  }

  @override
  FutureProviderElement<List<Stotra>> createElement() {
    return _StotrasByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StotrasByCategoryProvider &&
        other.categorySlug == categorySlug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categorySlug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StotrasByCategoryRef on FutureProviderRef<List<Stotra>> {
  /// The parameter `categorySlug` of this provider.
  String get categorySlug;
}

class _StotrasByCategoryProviderElement
    extends FutureProviderElement<List<Stotra>>
    with StotrasByCategoryRef {
  _StotrasByCategoryProviderElement(super.provider);

  @override
  String get categorySlug => (origin as StotrasByCategoryProvider).categorySlug;
}

String _$stotrasSearchHash() => r'dfeed3bd01339b7863ddbf1d96525610e6486fb4';

/// Server-side search across all stotras. Used by the global search field
/// on the Stotras home screen. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
///
/// Copied from [stotrasSearch].
@ProviderFor(stotrasSearch)
const stotrasSearchProvider = StotrasSearchFamily();

/// Server-side search across all stotras. Used by the global search field
/// on the Stotras home screen. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
///
/// Copied from [stotrasSearch].
class StotrasSearchFamily extends Family<AsyncValue<List<Stotra>>> {
  /// Server-side search across all stotras. Used by the global search field
  /// on the Stotras home screen. Not `keepAlive` — per-query results aren't
  /// worth caching indefinitely.
  ///
  /// Copied from [stotrasSearch].
  const StotrasSearchFamily();

  /// Server-side search across all stotras. Used by the global search field
  /// on the Stotras home screen. Not `keepAlive` — per-query results aren't
  /// worth caching indefinitely.
  ///
  /// Copied from [stotrasSearch].
  StotrasSearchProvider call(String query) {
    return StotrasSearchProvider(query);
  }

  @override
  StotrasSearchProvider getProviderOverride(
    covariant StotrasSearchProvider provider,
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
  String? get name => r'stotrasSearchProvider';
}

/// Server-side search across all stotras. Used by the global search field
/// on the Stotras home screen. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
///
/// Copied from [stotrasSearch].
class StotrasSearchProvider extends AutoDisposeFutureProvider<List<Stotra>> {
  /// Server-side search across all stotras. Used by the global search field
  /// on the Stotras home screen. Not `keepAlive` — per-query results aren't
  /// worth caching indefinitely.
  ///
  /// Copied from [stotrasSearch].
  StotrasSearchProvider(String query)
    : this._internal(
        (ref) => stotrasSearch(ref as StotrasSearchRef, query),
        from: stotrasSearchProvider,
        name: r'stotrasSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stotrasSearchHash,
        dependencies: StotrasSearchFamily._dependencies,
        allTransitiveDependencies:
            StotrasSearchFamily._allTransitiveDependencies,
        query: query,
      );

  StotrasSearchProvider._internal(
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
    FutureOr<List<Stotra>> Function(StotrasSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StotrasSearchProvider._internal(
        (ref) => create(ref as StotrasSearchRef),
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
  AutoDisposeFutureProviderElement<List<Stotra>> createElement() {
    return _StotrasSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StotrasSearchProvider && other.query == query;
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
mixin StotrasSearchRef on AutoDisposeFutureProviderRef<List<Stotra>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _StotrasSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Stotra>>
    with StotrasSearchRef {
  _StotrasSearchProviderElement(super.provider);

  @override
  String get query => (origin as StotrasSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
