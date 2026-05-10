// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remedies_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emotionDetailHash() => r'd1ddbd8fd54928a4e9f167c61a8f6e1ed6d20d5d';

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

/// Loads the emotion detail (with remedies) for a given mood slug.
///
/// Cached for the session so re-entering a mood from the journal is instant.
///
/// Copied from [emotionDetail].
@ProviderFor(emotionDetail)
const emotionDetailProvider = EmotionDetailFamily();

/// Loads the emotion detail (with remedies) for a given mood slug.
///
/// Cached for the session so re-entering a mood from the journal is instant.
///
/// Copied from [emotionDetail].
class EmotionDetailFamily extends Family<AsyncValue<EmotionDetail>> {
  /// Loads the emotion detail (with remedies) for a given mood slug.
  ///
  /// Cached for the session so re-entering a mood from the journal is instant.
  ///
  /// Copied from [emotionDetail].
  const EmotionDetailFamily();

  /// Loads the emotion detail (with remedies) for a given mood slug.
  ///
  /// Cached for the session so re-entering a mood from the journal is instant.
  ///
  /// Copied from [emotionDetail].
  EmotionDetailProvider call(String slug) {
    return EmotionDetailProvider(slug);
  }

  @override
  EmotionDetailProvider getProviderOverride(
    covariant EmotionDetailProvider provider,
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
  String? get name => r'emotionDetailProvider';
}

/// Loads the emotion detail (with remedies) for a given mood slug.
///
/// Cached for the session so re-entering a mood from the journal is instant.
///
/// Copied from [emotionDetail].
class EmotionDetailProvider extends FutureProvider<EmotionDetail> {
  /// Loads the emotion detail (with remedies) for a given mood slug.
  ///
  /// Cached for the session so re-entering a mood from the journal is instant.
  ///
  /// Copied from [emotionDetail].
  EmotionDetailProvider(String slug)
    : this._internal(
        (ref) => emotionDetail(ref as EmotionDetailRef, slug),
        from: emotionDetailProvider,
        name: r'emotionDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$emotionDetailHash,
        dependencies: EmotionDetailFamily._dependencies,
        allTransitiveDependencies:
            EmotionDetailFamily._allTransitiveDependencies,
        slug: slug,
      );

  EmotionDetailProvider._internal(
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
    FutureOr<EmotionDetail> Function(EmotionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmotionDetailProvider._internal(
        (ref) => create(ref as EmotionDetailRef),
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
  FutureProviderElement<EmotionDetail> createElement() {
    return _EmotionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmotionDetailProvider && other.slug == slug;
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
mixin EmotionDetailRef on FutureProviderRef<EmotionDetail> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _EmotionDetailProviderElement extends FutureProviderElement<EmotionDetail>
    with EmotionDetailRef {
  _EmotionDetailProviderElement(super.provider);

  @override
  String get slug => (origin as EmotionDetailProvider).slug;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
