// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_festivals_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hinduFestivalsHash() => r'f47912ed72c0f48cff8b193c5612983786604739';

/// The full festival catalogue, cached for the session. Mirrors
/// `islamicEventsProvider`'s keepAlive rationale.
///
/// Copied from [hinduFestivals].
@ProviderFor(hinduFestivals)
final hinduFestivalsProvider = FutureProvider<List<HinduFestival>>.internal(
  hinduFestivals,
  name: r'hinduFestivalsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hinduFestivalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HinduFestivalsRef = FutureProviderRef<List<HinduFestival>>;
String _$hinduFestivalBySlugHash() =>
    r'038e5ceba73ab1b10e490a6cd6570e227317c9f4';

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

/// A single festival by slug — a linear scan over the cached catalogue,
/// same pattern as calendar's `islamicEventById` (no extra network round
/// trip for a single-item lookup once the list is already cached).
///
/// Copied from [hinduFestivalBySlug].
@ProviderFor(hinduFestivalBySlug)
const hinduFestivalBySlugProvider = HinduFestivalBySlugFamily();

/// A single festival by slug — a linear scan over the cached catalogue,
/// same pattern as calendar's `islamicEventById` (no extra network round
/// trip for a single-item lookup once the list is already cached).
///
/// Copied from [hinduFestivalBySlug].
class HinduFestivalBySlugFamily extends Family<AsyncValue<HinduFestival?>> {
  /// A single festival by slug — a linear scan over the cached catalogue,
  /// same pattern as calendar's `islamicEventById` (no extra network round
  /// trip for a single-item lookup once the list is already cached).
  ///
  /// Copied from [hinduFestivalBySlug].
  const HinduFestivalBySlugFamily();

  /// A single festival by slug — a linear scan over the cached catalogue,
  /// same pattern as calendar's `islamicEventById` (no extra network round
  /// trip for a single-item lookup once the list is already cached).
  ///
  /// Copied from [hinduFestivalBySlug].
  HinduFestivalBySlugProvider call(String slug) {
    return HinduFestivalBySlugProvider(slug);
  }

  @override
  HinduFestivalBySlugProvider getProviderOverride(
    covariant HinduFestivalBySlugProvider provider,
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
  String? get name => r'hinduFestivalBySlugProvider';
}

/// A single festival by slug — a linear scan over the cached catalogue,
/// same pattern as calendar's `islamicEventById` (no extra network round
/// trip for a single-item lookup once the list is already cached).
///
/// Copied from [hinduFestivalBySlug].
class HinduFestivalBySlugProvider
    extends AutoDisposeFutureProvider<HinduFestival?> {
  /// A single festival by slug — a linear scan over the cached catalogue,
  /// same pattern as calendar's `islamicEventById` (no extra network round
  /// trip for a single-item lookup once the list is already cached).
  ///
  /// Copied from [hinduFestivalBySlug].
  HinduFestivalBySlugProvider(String slug)
    : this._internal(
        (ref) => hinduFestivalBySlug(ref as HinduFestivalBySlugRef, slug),
        from: hinduFestivalBySlugProvider,
        name: r'hinduFestivalBySlugProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hinduFestivalBySlugHash,
        dependencies: HinduFestivalBySlugFamily._dependencies,
        allTransitiveDependencies:
            HinduFestivalBySlugFamily._allTransitiveDependencies,
        slug: slug,
      );

  HinduFestivalBySlugProvider._internal(
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
    FutureOr<HinduFestival?> Function(HinduFestivalBySlugRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HinduFestivalBySlugProvider._internal(
        (ref) => create(ref as HinduFestivalBySlugRef),
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
  AutoDisposeFutureProviderElement<HinduFestival?> createElement() {
    return _HinduFestivalBySlugProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HinduFestivalBySlugProvider && other.slug == slug;
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
mixin HinduFestivalBySlugRef on AutoDisposeFutureProviderRef<HinduFestival?> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _HinduFestivalBySlugProviderElement
    extends AutoDisposeFutureProviderElement<HinduFestival?>
    with HinduFestivalBySlugRef {
  _HinduFestivalBySlugProviderElement(super.provider);

  @override
  String get slug => (origin as HinduFestivalBySlugProvider).slug;
}

String _$upcomingFestivalsControllerHash() =>
    r'82e63c5b51e504458ae6baff6b0885b6ece1f0a2';

/// Festivals resolved to actual upcoming dates — the panchang screen's
/// equivalent of calendar's "Events this month" section, except already
/// resolved server-side (no client-side rule matching needed). Location
/// gated, null-on-unavailable like the other panchang controllers.
///
/// Copied from [UpcomingFestivalsController].
@ProviderFor(UpcomingFestivalsController)
final upcomingFestivalsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      UpcomingFestivalsController,
      List<FestivalOccurrence>?
    >.internal(
      UpcomingFestivalsController.new,
      name: r'upcomingFestivalsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$upcomingFestivalsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UpcomingFestivalsController =
    AutoDisposeAsyncNotifier<List<FestivalOccurrence>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
