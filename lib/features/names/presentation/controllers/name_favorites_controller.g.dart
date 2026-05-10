// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_favorites_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nameFavoritesControllerHash() =>
    r'dcbee91837a478d128a4e4f31b10db27215dcace';

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

abstract class _$NameFavoritesController
    extends BuildlessAsyncNotifier<List<DivineName>> {
  late final NamesKind kind;

  FutureOr<List<DivineName>> build(NamesKind kind);
}

/// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
/// Muhammad favorites stay independent.
///
/// The local list is canonical so the UI is instant and works offline. On
/// build we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Copied from [NameFavoritesController].
@ProviderFor(NameFavoritesController)
const nameFavoritesControllerProvider = NameFavoritesControllerFamily();

/// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
/// Muhammad favorites stay independent.
///
/// The local list is canonical so the UI is instant and works offline. On
/// build we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Copied from [NameFavoritesController].
class NameFavoritesControllerFamily
    extends Family<AsyncValue<List<DivineName>>> {
  /// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
  /// Muhammad favorites stay independent.
  ///
  /// The local list is canonical so the UI is instant and works offline. On
  /// build we hydrate from `shared_preferences` and lazily merge any remote
  /// favorites the server already knows about.
  ///
  /// Copied from [NameFavoritesController].
  const NameFavoritesControllerFamily();

  /// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
  /// Muhammad favorites stay independent.
  ///
  /// The local list is canonical so the UI is instant and works offline. On
  /// build we hydrate from `shared_preferences` and lazily merge any remote
  /// favorites the server already knows about.
  ///
  /// Copied from [NameFavoritesController].
  NameFavoritesControllerProvider call(NamesKind kind) {
    return NameFavoritesControllerProvider(kind);
  }

  @override
  NameFavoritesControllerProvider getProviderOverride(
    covariant NameFavoritesControllerProvider provider,
  ) {
    return call(provider.kind);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nameFavoritesControllerProvider';
}

/// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
/// Muhammad favorites stay independent.
///
/// The local list is canonical so the UI is instant and works offline. On
/// build we hydrate from `shared_preferences` and lazily merge any remote
/// favorites the server already knows about.
///
/// Copied from [NameFavoritesController].
class NameFavoritesControllerProvider
    extends
        AsyncNotifierProviderImpl<NameFavoritesController, List<DivineName>> {
  /// Local-mirror favorites store, parameterized by [NamesKind] so Allah and
  /// Muhammad favorites stay independent.
  ///
  /// The local list is canonical so the UI is instant and works offline. On
  /// build we hydrate from `shared_preferences` and lazily merge any remote
  /// favorites the server already knows about.
  ///
  /// Copied from [NameFavoritesController].
  NameFavoritesControllerProvider(NamesKind kind)
    : this._internal(
        () => NameFavoritesController()..kind = kind,
        from: nameFavoritesControllerProvider,
        name: r'nameFavoritesControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$nameFavoritesControllerHash,
        dependencies: NameFavoritesControllerFamily._dependencies,
        allTransitiveDependencies:
            NameFavoritesControllerFamily._allTransitiveDependencies,
        kind: kind,
      );

  NameFavoritesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kind,
  }) : super.internal();

  final NamesKind kind;

  @override
  FutureOr<List<DivineName>> runNotifierBuild(
    covariant NameFavoritesController notifier,
  ) {
    return notifier.build(kind);
  }

  @override
  Override overrideWith(NameFavoritesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NameFavoritesControllerProvider._internal(
        () => create()..kind = kind,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kind: kind,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<NameFavoritesController, List<DivineName>>
  createElement() {
    return _NameFavoritesControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NameFavoritesControllerProvider && other.kind == kind;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kind.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NameFavoritesControllerRef on AsyncNotifierProviderRef<List<DivineName>> {
  /// The parameter `kind` of this provider.
  NamesKind get kind;
}

class _NameFavoritesControllerProviderElement
    extends
        AsyncNotifierProviderElement<NameFavoritesController, List<DivineName>>
    with NameFavoritesControllerRef {
  _NameFavoritesControllerProviderElement(super.provider);

  @override
  NamesKind get kind => (origin as NameFavoritesControllerProvider).kind;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
