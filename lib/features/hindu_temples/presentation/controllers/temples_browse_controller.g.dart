// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temples_browse_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTemplesHash() => r'b1c4d05bcf45b44387a0551660d0f2ca18f5dcb0';

/// The full unfiltered temple list. Used both as its own "browse all" view
/// and as the source for deriving distinct deity keys client-side — there's
/// no `/deities` endpoint the way `/states` exists.
///
/// Copied from [allTemples].
@ProviderFor(allTemples)
final allTemplesProvider = FutureProvider<List<Temple>>.internal(
  allTemples,
  name: r'allTemplesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allTemplesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTemplesRef = FutureProviderRef<List<Temple>>;
String _$templeDeityKeysHash() => r'8b9000b5ed482eecd863eb026e8cf036e63ae8af';

/// Distinct deity keys observed across the loaded temple list, sorted.
/// Not exhaustive by design — the backend has no fixed deity taxonomy, so
/// "browse by deity" can only ever offer what's actually present in data.
///
/// Copied from [templeDeityKeys].
@ProviderFor(templeDeityKeys)
final templeDeityKeysProvider = AutoDisposeProvider<List<String>>.internal(
  templeDeityKeys,
  name: r'templeDeityKeysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templeDeityKeysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TempleDeityKeysRef = AutoDisposeProviderRef<List<String>>;
String _$templeStatesHash() => r'7b6d004ebea598a182cfa605d1da6916983f9227';

/// All states with at least one temple, alphabetized server-side.
///
/// Copied from [templeStates].
@ProviderFor(templeStates)
final templeStatesProvider = FutureProvider<List<String>>.internal(
  templeStates,
  name: r'templeStatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templeStatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TempleStatesRef = FutureProviderRef<List<String>>;
String _$templesByStateHash() => r'dfc87bd2e595e16e6bdc924610afa72725dd1f75';

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

/// Temples in a specific state. Cached so back-nav is instant.
///
/// Named `stateName`, not `state` — the generated `Ref` for a family
/// provider already exposes a `state` getter (the provider's own
/// `AsyncValue`), so a parameter literally named `state` collides with it
/// and fails to compile.
///
/// Copied from [templesByState].
@ProviderFor(templesByState)
const templesByStateProvider = TemplesByStateFamily();

/// Temples in a specific state. Cached so back-nav is instant.
///
/// Named `stateName`, not `state` — the generated `Ref` for a family
/// provider already exposes a `state` getter (the provider's own
/// `AsyncValue`), so a parameter literally named `state` collides with it
/// and fails to compile.
///
/// Copied from [templesByState].
class TemplesByStateFamily extends Family<AsyncValue<List<Temple>>> {
  /// Temples in a specific state. Cached so back-nav is instant.
  ///
  /// Named `stateName`, not `state` — the generated `Ref` for a family
  /// provider already exposes a `state` getter (the provider's own
  /// `AsyncValue`), so a parameter literally named `state` collides with it
  /// and fails to compile.
  ///
  /// Copied from [templesByState].
  const TemplesByStateFamily();

  /// Temples in a specific state. Cached so back-nav is instant.
  ///
  /// Named `stateName`, not `state` — the generated `Ref` for a family
  /// provider already exposes a `state` getter (the provider's own
  /// `AsyncValue`), so a parameter literally named `state` collides with it
  /// and fails to compile.
  ///
  /// Copied from [templesByState].
  TemplesByStateProvider call(String stateName) {
    return TemplesByStateProvider(stateName);
  }

  @override
  TemplesByStateProvider getProviderOverride(
    covariant TemplesByStateProvider provider,
  ) {
    return call(provider.stateName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'templesByStateProvider';
}

/// Temples in a specific state. Cached so back-nav is instant.
///
/// Named `stateName`, not `state` — the generated `Ref` for a family
/// provider already exposes a `state` getter (the provider's own
/// `AsyncValue`), so a parameter literally named `state` collides with it
/// and fails to compile.
///
/// Copied from [templesByState].
class TemplesByStateProvider extends FutureProvider<List<Temple>> {
  /// Temples in a specific state. Cached so back-nav is instant.
  ///
  /// Named `stateName`, not `state` — the generated `Ref` for a family
  /// provider already exposes a `state` getter (the provider's own
  /// `AsyncValue`), so a parameter literally named `state` collides with it
  /// and fails to compile.
  ///
  /// Copied from [templesByState].
  TemplesByStateProvider(String stateName)
    : this._internal(
        (ref) => templesByState(ref as TemplesByStateRef, stateName),
        from: templesByStateProvider,
        name: r'templesByStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$templesByStateHash,
        dependencies: TemplesByStateFamily._dependencies,
        allTransitiveDependencies:
            TemplesByStateFamily._allTransitiveDependencies,
        stateName: stateName,
      );

  TemplesByStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.stateName,
  }) : super.internal();

  final String stateName;

  @override
  Override overrideWith(
    FutureOr<List<Temple>> Function(TemplesByStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplesByStateProvider._internal(
        (ref) => create(ref as TemplesByStateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        stateName: stateName,
      ),
    );
  }

  @override
  FutureProviderElement<List<Temple>> createElement() {
    return _TemplesByStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplesByStateProvider && other.stateName == stateName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, stateName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TemplesByStateRef on FutureProviderRef<List<Temple>> {
  /// The parameter `stateName` of this provider.
  String get stateName;
}

class _TemplesByStateProviderElement extends FutureProviderElement<List<Temple>>
    with TemplesByStateRef {
  _TemplesByStateProviderElement(super.provider);

  @override
  String get stateName => (origin as TemplesByStateProvider).stateName;
}

String _$templesByDeityHash() => r'8a5bff8d8ecd51cb540ddcb6d56d2e01da1adaeb';

/// Temples matching a specific deity key. Cached so back-nav is instant.
///
/// Copied from [templesByDeity].
@ProviderFor(templesByDeity)
const templesByDeityProvider = TemplesByDeityFamily();

/// Temples matching a specific deity key. Cached so back-nav is instant.
///
/// Copied from [templesByDeity].
class TemplesByDeityFamily extends Family<AsyncValue<List<Temple>>> {
  /// Temples matching a specific deity key. Cached so back-nav is instant.
  ///
  /// Copied from [templesByDeity].
  const TemplesByDeityFamily();

  /// Temples matching a specific deity key. Cached so back-nav is instant.
  ///
  /// Copied from [templesByDeity].
  TemplesByDeityProvider call(String deity) {
    return TemplesByDeityProvider(deity);
  }

  @override
  TemplesByDeityProvider getProviderOverride(
    covariant TemplesByDeityProvider provider,
  ) {
    return call(provider.deity);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'templesByDeityProvider';
}

/// Temples matching a specific deity key. Cached so back-nav is instant.
///
/// Copied from [templesByDeity].
class TemplesByDeityProvider extends FutureProvider<List<Temple>> {
  /// Temples matching a specific deity key. Cached so back-nav is instant.
  ///
  /// Copied from [templesByDeity].
  TemplesByDeityProvider(String deity)
    : this._internal(
        (ref) => templesByDeity(ref as TemplesByDeityRef, deity),
        from: templesByDeityProvider,
        name: r'templesByDeityProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$templesByDeityHash,
        dependencies: TemplesByDeityFamily._dependencies,
        allTransitiveDependencies:
            TemplesByDeityFamily._allTransitiveDependencies,
        deity: deity,
      );

  TemplesByDeityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deity,
  }) : super.internal();

  final String deity;

  @override
  Override overrideWith(
    FutureOr<List<Temple>> Function(TemplesByDeityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplesByDeityProvider._internal(
        (ref) => create(ref as TemplesByDeityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deity: deity,
      ),
    );
  }

  @override
  FutureProviderElement<List<Temple>> createElement() {
    return _TemplesByDeityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplesByDeityProvider && other.deity == deity;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deity.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TemplesByDeityRef on FutureProviderRef<List<Temple>> {
  /// The parameter `deity` of this provider.
  String get deity;
}

class _TemplesByDeityProviderElement extends FutureProviderElement<List<Temple>>
    with TemplesByDeityRef {
  _TemplesByDeityProviderElement(super.provider);

  @override
  String get deity => (origin as TemplesByDeityProvider).deity;
}

String _$templesSearchHash() => r'f03a26dc266fe6b41163d6d5e06428bace7bcfef';

/// Server-side name search. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
///
/// Copied from [templesSearch].
@ProviderFor(templesSearch)
const templesSearchProvider = TemplesSearchFamily();

/// Server-side name search. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
///
/// Copied from [templesSearch].
class TemplesSearchFamily extends Family<AsyncValue<List<Temple>>> {
  /// Server-side name search. Not `keepAlive` — per-query results aren't
  /// worth caching indefinitely.
  ///
  /// Copied from [templesSearch].
  const TemplesSearchFamily();

  /// Server-side name search. Not `keepAlive` — per-query results aren't
  /// worth caching indefinitely.
  ///
  /// Copied from [templesSearch].
  TemplesSearchProvider call(String query) {
    return TemplesSearchProvider(query);
  }

  @override
  TemplesSearchProvider getProviderOverride(
    covariant TemplesSearchProvider provider,
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
  String? get name => r'templesSearchProvider';
}

/// Server-side name search. Not `keepAlive` — per-query results aren't
/// worth caching indefinitely.
///
/// Copied from [templesSearch].
class TemplesSearchProvider extends AutoDisposeFutureProvider<List<Temple>> {
  /// Server-side name search. Not `keepAlive` — per-query results aren't
  /// worth caching indefinitely.
  ///
  /// Copied from [templesSearch].
  TemplesSearchProvider(String query)
    : this._internal(
        (ref) => templesSearch(ref as TemplesSearchRef, query),
        from: templesSearchProvider,
        name: r'templesSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$templesSearchHash,
        dependencies: TemplesSearchFamily._dependencies,
        allTransitiveDependencies:
            TemplesSearchFamily._allTransitiveDependencies,
        query: query,
      );

  TemplesSearchProvider._internal(
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
    FutureOr<List<Temple>> Function(TemplesSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplesSearchProvider._internal(
        (ref) => create(ref as TemplesSearchRef),
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
  AutoDisposeFutureProviderElement<List<Temple>> createElement() {
    return _TemplesSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplesSearchProvider && other.query == query;
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
mixin TemplesSearchRef on AutoDisposeFutureProviderRef<List<Temple>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _TemplesSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Temple>>
    with TemplesSearchRef {
  _TemplesSearchProviderElement(super.provider);

  @override
  String get query => (origin as TemplesSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
