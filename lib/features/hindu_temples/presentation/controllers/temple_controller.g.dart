// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temple_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$templeByIdHash() => r'0ba6eda3ff9e34ce4847c6609a4568d187fca9fe';

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

/// A single temple, by id. `keepAlive` so opening the same temple twice in
/// a session is instant.
///
/// Copied from [templeById].
@ProviderFor(templeById)
const templeByIdProvider = TempleByIdFamily();

/// A single temple, by id. `keepAlive` so opening the same temple twice in
/// a session is instant.
///
/// Copied from [templeById].
class TempleByIdFamily extends Family<AsyncValue<Temple>> {
  /// A single temple, by id. `keepAlive` so opening the same temple twice in
  /// a session is instant.
  ///
  /// Copied from [templeById].
  const TempleByIdFamily();

  /// A single temple, by id. `keepAlive` so opening the same temple twice in
  /// a session is instant.
  ///
  /// Copied from [templeById].
  TempleByIdProvider call(String id) {
    return TempleByIdProvider(id);
  }

  @override
  TempleByIdProvider getProviderOverride(
    covariant TempleByIdProvider provider,
  ) {
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
  String? get name => r'templeByIdProvider';
}

/// A single temple, by id. `keepAlive` so opening the same temple twice in
/// a session is instant.
///
/// Copied from [templeById].
class TempleByIdProvider extends FutureProvider<Temple> {
  /// A single temple, by id. `keepAlive` so opening the same temple twice in
  /// a session is instant.
  ///
  /// Copied from [templeById].
  TempleByIdProvider(String id)
    : this._internal(
        (ref) => templeById(ref as TempleByIdRef, id),
        from: templeByIdProvider,
        name: r'templeByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$templeByIdHash,
        dependencies: TempleByIdFamily._dependencies,
        allTransitiveDependencies: TempleByIdFamily._allTransitiveDependencies,
        id: id,
      );

  TempleByIdProvider._internal(
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
  Override overrideWith(
    FutureOr<Temple> Function(TempleByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TempleByIdProvider._internal(
        (ref) => create(ref as TempleByIdRef),
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
  FutureProviderElement<Temple> createElement() {
    return _TempleByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TempleByIdProvider && other.id == id;
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
mixin TempleByIdRef on FutureProviderRef<Temple> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TempleByIdProviderElement extends FutureProviderElement<Temple>
    with TempleByIdRef {
  _TempleByIdProviderElement(super.provider);

  @override
  String get id => (origin as TempleByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
