// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nameDetailHash() => r'cf3a4c03b959311863cd470c0bfcda9bda3f2692';

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

/// One name's full detail. Family parameter is `(kind, id)` so Allah and
/// Muhammad detail caches don't collide.
///
/// Copied from [nameDetail].
@ProviderFor(nameDetail)
const nameDetailProvider = NameDetailFamily();

/// One name's full detail. Family parameter is `(kind, id)` so Allah and
/// Muhammad detail caches don't collide.
///
/// Copied from [nameDetail].
class NameDetailFamily extends Family<AsyncValue<DivineName>> {
  /// One name's full detail. Family parameter is `(kind, id)` so Allah and
  /// Muhammad detail caches don't collide.
  ///
  /// Copied from [nameDetail].
  const NameDetailFamily();

  /// One name's full detail. Family parameter is `(kind, id)` so Allah and
  /// Muhammad detail caches don't collide.
  ///
  /// Copied from [nameDetail].
  NameDetailProvider call({required NamesKind kind, required int id}) {
    return NameDetailProvider(kind: kind, id: id);
  }

  @override
  NameDetailProvider getProviderOverride(
    covariant NameDetailProvider provider,
  ) {
    return call(kind: provider.kind, id: provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nameDetailProvider';
}

/// One name's full detail. Family parameter is `(kind, id)` so Allah and
/// Muhammad detail caches don't collide.
///
/// Copied from [nameDetail].
class NameDetailProvider extends FutureProvider<DivineName> {
  /// One name's full detail. Family parameter is `(kind, id)` so Allah and
  /// Muhammad detail caches don't collide.
  ///
  /// Copied from [nameDetail].
  NameDetailProvider({required NamesKind kind, required int id})
    : this._internal(
        (ref) => nameDetail(ref as NameDetailRef, kind: kind, id: id),
        from: nameDetailProvider,
        name: r'nameDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$nameDetailHash,
        dependencies: NameDetailFamily._dependencies,
        allTransitiveDependencies: NameDetailFamily._allTransitiveDependencies,
        kind: kind,
        id: id,
      );

  NameDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kind,
    required this.id,
  }) : super.internal();

  final NamesKind kind;
  final int id;

  @override
  Override overrideWith(
    FutureOr<DivineName> Function(NameDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NameDetailProvider._internal(
        (ref) => create(ref as NameDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kind: kind,
        id: id,
      ),
    );
  }

  @override
  FutureProviderElement<DivineName> createElement() {
    return _NameDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NameDetailProvider && other.kind == kind && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kind.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NameDetailRef on FutureProviderRef<DivineName> {
  /// The parameter `kind` of this provider.
  NamesKind get kind;

  /// The parameter `id` of this provider.
  int get id;
}

class _NameDetailProviderElement extends FutureProviderElement<DivineName>
    with NameDetailRef {
  _NameDetailProviderElement(super.provider);

  @override
  NamesKind get kind => (origin as NameDetailProvider).kind;
  @override
  int get id => (origin as NameDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
