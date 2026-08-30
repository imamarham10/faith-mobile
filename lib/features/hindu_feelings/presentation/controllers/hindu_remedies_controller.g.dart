// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hindu_remedies_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hinduEmotionDetailHash() =>
    r'd510008ea1b4975a67f52c0f774c5088bdb9cf87';

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

/// Loads the emotion detail (with remedies) for a given mood slug. Cached
/// for the session, mirroring `emotionDetailProvider`.
///
/// Copied from [hinduEmotionDetail].
@ProviderFor(hinduEmotionDetail)
const hinduEmotionDetailProvider = HinduEmotionDetailFamily();

/// Loads the emotion detail (with remedies) for a given mood slug. Cached
/// for the session, mirroring `emotionDetailProvider`.
///
/// Copied from [hinduEmotionDetail].
class HinduEmotionDetailFamily extends Family<AsyncValue<HinduEmotionDetail>> {
  /// Loads the emotion detail (with remedies) for a given mood slug. Cached
  /// for the session, mirroring `emotionDetailProvider`.
  ///
  /// Copied from [hinduEmotionDetail].
  const HinduEmotionDetailFamily();

  /// Loads the emotion detail (with remedies) for a given mood slug. Cached
  /// for the session, mirroring `emotionDetailProvider`.
  ///
  /// Copied from [hinduEmotionDetail].
  HinduEmotionDetailProvider call(String slug) {
    return HinduEmotionDetailProvider(slug);
  }

  @override
  HinduEmotionDetailProvider getProviderOverride(
    covariant HinduEmotionDetailProvider provider,
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
  String? get name => r'hinduEmotionDetailProvider';
}

/// Loads the emotion detail (with remedies) for a given mood slug. Cached
/// for the session, mirroring `emotionDetailProvider`.
///
/// Copied from [hinduEmotionDetail].
class HinduEmotionDetailProvider extends FutureProvider<HinduEmotionDetail> {
  /// Loads the emotion detail (with remedies) for a given mood slug. Cached
  /// for the session, mirroring `emotionDetailProvider`.
  ///
  /// Copied from [hinduEmotionDetail].
  HinduEmotionDetailProvider(String slug)
    : this._internal(
        (ref) => hinduEmotionDetail(ref as HinduEmotionDetailRef, slug),
        from: hinduEmotionDetailProvider,
        name: r'hinduEmotionDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hinduEmotionDetailHash,
        dependencies: HinduEmotionDetailFamily._dependencies,
        allTransitiveDependencies:
            HinduEmotionDetailFamily._allTransitiveDependencies,
        slug: slug,
      );

  HinduEmotionDetailProvider._internal(
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
    FutureOr<HinduEmotionDetail> Function(HinduEmotionDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HinduEmotionDetailProvider._internal(
        (ref) => create(ref as HinduEmotionDetailRef),
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
  FutureProviderElement<HinduEmotionDetail> createElement() {
    return _HinduEmotionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HinduEmotionDetailProvider && other.slug == slug;
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
mixin HinduEmotionDetailRef on FutureProviderRef<HinduEmotionDetail> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _HinduEmotionDetailProviderElement
    extends FutureProviderElement<HinduEmotionDetail>
    with HinduEmotionDetailRef {
  _HinduEmotionDetailProviderElement(super.provider);

  @override
  String get slug => (origin as HinduEmotionDetailProvider).slug;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
