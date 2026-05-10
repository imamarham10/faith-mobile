// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duaByIdHash() => r'f0e41d0c6e754a80c9c5695ca3f826f48ccd3739';

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

/// A single dua, by id. `keepAlive` so opening the same dua twice in a session
/// is instant.
///
/// Copied from [duaById].
@ProviderFor(duaById)
const duaByIdProvider = DuaByIdFamily();

/// A single dua, by id. `keepAlive` so opening the same dua twice in a session
/// is instant.
///
/// Copied from [duaById].
class DuaByIdFamily extends Family<AsyncValue<Dua>> {
  /// A single dua, by id. `keepAlive` so opening the same dua twice in a session
  /// is instant.
  ///
  /// Copied from [duaById].
  const DuaByIdFamily();

  /// A single dua, by id. `keepAlive` so opening the same dua twice in a session
  /// is instant.
  ///
  /// Copied from [duaById].
  DuaByIdProvider call(String id) {
    return DuaByIdProvider(id);
  }

  @override
  DuaByIdProvider getProviderOverride(covariant DuaByIdProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'duaByIdProvider';
}

/// A single dua, by id. `keepAlive` so opening the same dua twice in a session
/// is instant.
///
/// Copied from [duaById].
class DuaByIdProvider extends FutureProvider<Dua> {
  /// A single dua, by id. `keepAlive` so opening the same dua twice in a session
  /// is instant.
  ///
  /// Copied from [duaById].
  DuaByIdProvider(String id)
    : this._internal(
        (ref) => duaById(ref as DuaByIdRef, id),
        from: duaByIdProvider,
        name: r'duaByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$duaByIdHash,
        dependencies: DuaByIdFamily._dependencies,
        allTransitiveDependencies: DuaByIdFamily._allTransitiveDependencies,
        id: id,
      );

  DuaByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(FutureOr<Dua> Function(DuaByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: DuaByIdProvider._internal(
        (ref) => create(ref as DuaByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  FutureProviderElement<Dua> createElement() {
    return _DuaByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DuaByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DuaByIdRef on FutureProviderRef<Dua> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DuaByIdProviderElement extends FutureProviderElement<Dua>
    with DuaByIdRef {
  _DuaByIdProviderElement(super.provider);

  @override
  String get id => (origin as DuaByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
