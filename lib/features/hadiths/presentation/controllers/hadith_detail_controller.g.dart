// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hadithDetailHash() => r'456fd7165ffbe40dac2f1dc5abf7ed9263123bf5';

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

/// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
///
/// Copied from [hadithDetail].
@ProviderFor(hadithDetail)
const hadithDetailProvider = HadithDetailFamily();

/// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
///
/// Copied from [hadithDetail].
class HadithDetailFamily extends Family<AsyncValue<Hadith>> {
  /// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
  ///
  /// Copied from [hadithDetail].
  const HadithDetailFamily();

  /// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
  ///
  /// Copied from [hadithDetail].
  HadithDetailProvider call(String id) {
    return HadithDetailProvider(id);
  }

  @override
  HadithDetailProvider getProviderOverride(
    covariant HadithDetailProvider provider,
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
  String? get name => r'hadithDetailProvider';
}

/// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
///
/// Copied from [hadithDetail].
class HadithDetailProvider extends FutureProvider<Hadith> {
  /// A single hadith by id. `keepAlive` so back-and-forth navigation is instant.
  ///
  /// Copied from [hadithDetail].
  HadithDetailProvider(String id)
    : this._internal(
        (ref) => hadithDetail(ref as HadithDetailRef, id),
        from: hadithDetailProvider,
        name: r'hadithDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hadithDetailHash,
        dependencies: HadithDetailFamily._dependencies,
        allTransitiveDependencies:
            HadithDetailFamily._allTransitiveDependencies,
        id: id,
      );

  HadithDetailProvider._internal(
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
    FutureOr<Hadith> Function(HadithDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HadithDetailProvider._internal(
        (ref) => create(ref as HadithDetailRef),
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
  FutureProviderElement<Hadith> createElement() {
    return _HadithDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HadithDetailProvider && other.id == id;
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
mixin HadithDetailRef on FutureProviderRef<Hadith> {
  /// The parameter `id` of this provider.
  String get id;
}

class _HadithDetailProviderElement extends FutureProviderElement<Hadith>
    with HadithDetailRef {
  _HadithDetailProviderElement(super.provider);

  @override
  String get id => (origin as HadithDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
