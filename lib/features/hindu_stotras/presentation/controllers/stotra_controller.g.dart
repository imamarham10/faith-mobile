// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stotra_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stotraBySlugHash() => r'0d48e513af3b1af10ca5fb2e481f17a366d77ead';

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

/// A single stotra, by slug. `keepAlive` so opening the same stotra twice
/// in a session is instant.
///
/// Copied from [stotraBySlug].
@ProviderFor(stotraBySlug)
const stotraBySlugProvider = StotraBySlugFamily();

/// A single stotra, by slug. `keepAlive` so opening the same stotra twice
/// in a session is instant.
///
/// Copied from [stotraBySlug].
class StotraBySlugFamily extends Family<AsyncValue<StotraDetail>> {
  /// A single stotra, by slug. `keepAlive` so opening the same stotra twice
  /// in a session is instant.
  ///
  /// Copied from [stotraBySlug].
  const StotraBySlugFamily();

  /// A single stotra, by slug. `keepAlive` so opening the same stotra twice
  /// in a session is instant.
  ///
  /// Copied from [stotraBySlug].
  StotraBySlugProvider call(String slug) {
    return StotraBySlugProvider(slug);
  }

  @override
  StotraBySlugProvider getProviderOverride(
    covariant StotraBySlugProvider provider,
  ) {
    return call(provider.slug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stotraBySlugProvider';
}

/// A single stotra, by slug. `keepAlive` so opening the same stotra twice
/// in a session is instant.
///
/// Copied from [stotraBySlug].
class StotraBySlugProvider extends FutureProvider<StotraDetail> {
  /// A single stotra, by slug. `keepAlive` so opening the same stotra twice
  /// in a session is instant.
  ///
  /// Copied from [stotraBySlug].
  StotraBySlugProvider(String slug)
    : this._internal(
        (ref) => stotraBySlug(ref as StotraBySlugRef, slug),
        from: stotraBySlugProvider,
        name: r'stotraBySlugProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stotraBySlugHash,
        dependencies: StotraBySlugFamily._dependencies,
        allTransitiveDependencies:
            StotraBySlugFamily._allTransitiveDependencies,
        slug: slug,
      );

  StotraBySlugProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<StotraDetail> Function(StotraBySlugRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StotraBySlugProvider._internal(
        (ref) => create(ref as StotraBySlugRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  FutureProviderElement<StotraDetail> createElement() {
    return _StotraBySlugProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StotraBySlugProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StotraBySlugRef on FutureProviderRef<StotraDetail> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _StotraBySlugProviderElement extends FutureProviderElement<StotraDetail>
    with StotraBySlugRef {
  _StotraBySlugProviderElement(super.provider);

  @override
  String get slug => (origin as StotraBySlugProvider).slug;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
