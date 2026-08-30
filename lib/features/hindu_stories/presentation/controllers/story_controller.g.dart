// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyByIdHash() => r'4df1a1171b15f937e23d927c3857c5823e211d47';

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

/// A single story, by id. `keepAlive` so opening the same story twice in a
/// session is instant.
///
/// Copied from [storyById].
@ProviderFor(storyById)
const storyByIdProvider = StoryByIdFamily();

/// A single story, by id. `keepAlive` so opening the same story twice in a
/// session is instant.
///
/// Copied from [storyById].
class StoryByIdFamily extends Family<AsyncValue<HinduStoryDetail>> {
  /// A single story, by id. `keepAlive` so opening the same story twice in a
  /// session is instant.
  ///
  /// Copied from [storyById].
  const StoryByIdFamily();

  /// A single story, by id. `keepAlive` so opening the same story twice in a
  /// session is instant.
  ///
  /// Copied from [storyById].
  StoryByIdProvider call(String id) {
    return StoryByIdProvider(id);
  }

  @override
  StoryByIdProvider getProviderOverride(covariant StoryByIdProvider provider) {
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
  String? get name => r'storyByIdProvider';
}

/// A single story, by id. `keepAlive` so opening the same story twice in a
/// session is instant.
///
/// Copied from [storyById].
class StoryByIdProvider extends FutureProvider<HinduStoryDetail> {
  /// A single story, by id. `keepAlive` so opening the same story twice in a
  /// session is instant.
  ///
  /// Copied from [storyById].
  StoryByIdProvider(String id)
    : this._internal(
        (ref) => storyById(ref as StoryByIdRef, id),
        from: storyByIdProvider,
        name: r'storyByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$storyByIdHash,
        dependencies: StoryByIdFamily._dependencies,
        allTransitiveDependencies: StoryByIdFamily._allTransitiveDependencies,
        id: id,
      );

  StoryByIdProvider._internal(
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
    FutureOr<HinduStoryDetail> Function(StoryByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryByIdProvider._internal(
        (ref) => create(ref as StoryByIdRef),
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
  FutureProviderElement<HinduStoryDetail> createElement() {
    return _StoryByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryByIdProvider && other.id == id;
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
mixin StoryByIdRef on FutureProviderRef<HinduStoryDetail> {
  /// The parameter `id` of this provider.
  String get id;
}

class _StoryByIdProviderElement extends FutureProviderElement<HinduStoryDetail>
    with StoryByIdRef {
  _StoryByIdProviderElement(super.provider);

  @override
  String get id => (origin as StoryByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
