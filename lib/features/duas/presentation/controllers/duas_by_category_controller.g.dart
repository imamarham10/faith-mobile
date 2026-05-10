// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duas_by_category_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duasByCategoryHash() => r'f82a71116b3b617f6906f2da8677873219425bef';

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

/// All duas inside a specific category. Cached so back-nav is instant.
///
/// Copied from [duasByCategory].
@ProviderFor(duasByCategory)
const duasByCategoryProvider = DuasByCategoryFamily();

/// All duas inside a specific category. Cached so back-nav is instant.
///
/// Copied from [duasByCategory].
class DuasByCategoryFamily extends Family<AsyncValue<List<Dua>>> {
  /// All duas inside a specific category. Cached so back-nav is instant.
  ///
  /// Copied from [duasByCategory].
  const DuasByCategoryFamily();

  /// All duas inside a specific category. Cached so back-nav is instant.
  ///
  /// Copied from [duasByCategory].
  DuasByCategoryProvider call(String categoryId) {
    return DuasByCategoryProvider(categoryId);
  }

  @override
  DuasByCategoryProvider getProviderOverride(
    covariant DuasByCategoryProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'duasByCategoryProvider';
}

/// All duas inside a specific category. Cached so back-nav is instant.
///
/// Copied from [duasByCategory].
class DuasByCategoryProvider extends FutureProvider<List<Dua>> {
  /// All duas inside a specific category. Cached so back-nav is instant.
  ///
  /// Copied from [duasByCategory].
  DuasByCategoryProvider(String categoryId)
    : this._internal(
        (ref) => duasByCategory(ref as DuasByCategoryRef, categoryId),
        from: duasByCategoryProvider,
        name: r'duasByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$duasByCategoryHash,
        dependencies: DuasByCategoryFamily._dependencies,
        allTransitiveDependencies:
            DuasByCategoryFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  DuasByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<Dua>> Function(DuasByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DuasByCategoryProvider._internal(
        (ref) => create(ref as DuasByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  FutureProviderElement<List<Dua>> createElement() {
    return _DuasByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DuasByCategoryProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DuasByCategoryRef on FutureProviderRef<List<Dua>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _DuasByCategoryProviderElement extends FutureProviderElement<List<Dua>>
    with DuasByCategoryRef {
  _DuasByCategoryProviderElement(super.provider);

  @override
  String get categoryId => (origin as DuasByCategoryProvider).categoryId;
}

String _$duasSearchHash() => r'7331d9444c1c7ea71b13ee3196c232bd0fb5a9ff';

/// Server-side search across all duas. Used by the global search field on the
/// Duas home screen.
///
/// Copied from [duasSearch].
@ProviderFor(duasSearch)
const duasSearchProvider = DuasSearchFamily();

/// Server-side search across all duas. Used by the global search field on the
/// Duas home screen.
///
/// Copied from [duasSearch].
class DuasSearchFamily extends Family<AsyncValue<List<Dua>>> {
  /// Server-side search across all duas. Used by the global search field on the
  /// Duas home screen.
  ///
  /// Copied from [duasSearch].
  const DuasSearchFamily();

  /// Server-side search across all duas. Used by the global search field on the
  /// Duas home screen.
  ///
  /// Copied from [duasSearch].
  DuasSearchProvider call(String query) {
    return DuasSearchProvider(query);
  }

  @override
  DuasSearchProvider getProviderOverride(
    covariant DuasSearchProvider provider,
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
  String? get name => r'duasSearchProvider';
}

/// Server-side search across all duas. Used by the global search field on the
/// Duas home screen.
///
/// Copied from [duasSearch].
class DuasSearchProvider extends AutoDisposeFutureProvider<List<Dua>> {
  /// Server-side search across all duas. Used by the global search field on the
  /// Duas home screen.
  ///
  /// Copied from [duasSearch].
  DuasSearchProvider(String query)
    : this._internal(
        (ref) => duasSearch(ref as DuasSearchRef, query),
        from: duasSearchProvider,
        name: r'duasSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$duasSearchHash,
        dependencies: DuasSearchFamily._dependencies,
        allTransitiveDependencies: DuasSearchFamily._allTransitiveDependencies,
        query: query,
      );

  DuasSearchProvider._internal(
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
    FutureOr<List<Dua>> Function(DuasSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DuasSearchProvider._internal(
        (ref) => create(ref as DuasSearchRef),
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
  AutoDisposeFutureProviderElement<List<Dua>> createElement() {
    return _DuasSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DuasSearchProvider && other.query == query;
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
mixin DuasSearchRef on AutoDisposeFutureProviderRef<List<Dua>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _DuasSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Dua>>
    with DuasSearchRef {
  _DuasSearchProviderElement(super.provider);

  @override
  String get query => (origin as DuasSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
