// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_counter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dhikrCounterControllerHash() =>
    r'c9061a3e42ecd140e4a41f4ee82f0eb35e4cb1d1';

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

abstract class _$DhikrCounterController
    extends BuildlessAutoDisposeAsyncNotifier<DhikrCounter> {
  late final String id;

  FutureOr<DhikrCounter> build(String id);
}

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync.
///
/// Why a family: the counter screen rebuilds its `displayLarge` count text
/// on every tap. Scoping that rebuild to a single provider keeps the home
/// list off the rebuild path and the count buttery at 120fps.
///
/// Sync strategy:
/// * Increments are applied immediately to local state and accumulated
///   into [_pendingDelta].
/// * A 5-second debounce timer fires the accumulated delta to the server.
/// * The screen also calls [flush] on pop / done, so we never lose a tap.
/// * On server failure we log + retain the pending delta so the next flush
///   tries again. We do not surface errors to UI; the local count is
///   canonical for the session.
///
/// Copied from [DhikrCounterController].
@ProviderFor(DhikrCounterController)
const dhikrCounterControllerProvider = DhikrCounterControllerFamily();

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync.
///
/// Why a family: the counter screen rebuilds its `displayLarge` count text
/// on every tap. Scoping that rebuild to a single provider keeps the home
/// list off the rebuild path and the count buttery at 120fps.
///
/// Sync strategy:
/// * Increments are applied immediately to local state and accumulated
///   into [_pendingDelta].
/// * A 5-second debounce timer fires the accumulated delta to the server.
/// * The screen also calls [flush] on pop / done, so we never lose a tap.
/// * On server failure we log + retain the pending delta so the next flush
///   tries again. We do not surface errors to UI; the local count is
///   canonical for the session.
///
/// Copied from [DhikrCounterController].
class DhikrCounterControllerFamily extends Family<AsyncValue<DhikrCounter>> {
  /// Per-counter state owner — fast, optimistic increments with debounced
  /// server sync.
  ///
  /// Why a family: the counter screen rebuilds its `displayLarge` count text
  /// on every tap. Scoping that rebuild to a single provider keeps the home
  /// list off the rebuild path and the count buttery at 120fps.
  ///
  /// Sync strategy:
  /// * Increments are applied immediately to local state and accumulated
  ///   into [_pendingDelta].
  /// * A 5-second debounce timer fires the accumulated delta to the server.
  /// * The screen also calls [flush] on pop / done, so we never lose a tap.
  /// * On server failure we log + retain the pending delta so the next flush
  ///   tries again. We do not surface errors to UI; the local count is
  ///   canonical for the session.
  ///
  /// Copied from [DhikrCounterController].
  const DhikrCounterControllerFamily();

  /// Per-counter state owner — fast, optimistic increments with debounced
  /// server sync.
  ///
  /// Why a family: the counter screen rebuilds its `displayLarge` count text
  /// on every tap. Scoping that rebuild to a single provider keeps the home
  /// list off the rebuild path and the count buttery at 120fps.
  ///
  /// Sync strategy:
  /// * Increments are applied immediately to local state and accumulated
  ///   into [_pendingDelta].
  /// * A 5-second debounce timer fires the accumulated delta to the server.
  /// * The screen also calls [flush] on pop / done, so we never lose a tap.
  /// * On server failure we log + retain the pending delta so the next flush
  ///   tries again. We do not surface errors to UI; the local count is
  ///   canonical for the session.
  ///
  /// Copied from [DhikrCounterController].
  DhikrCounterControllerProvider call(String id) {
    return DhikrCounterControllerProvider(id);
  }

  @override
  DhikrCounterControllerProvider getProviderOverride(
    covariant DhikrCounterControllerProvider provider,
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
  String? get name => r'dhikrCounterControllerProvider';
}

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync.
///
/// Why a family: the counter screen rebuilds its `displayLarge` count text
/// on every tap. Scoping that rebuild to a single provider keeps the home
/// list off the rebuild path and the count buttery at 120fps.
///
/// Sync strategy:
/// * Increments are applied immediately to local state and accumulated
///   into [_pendingDelta].
/// * A 5-second debounce timer fires the accumulated delta to the server.
/// * The screen also calls [flush] on pop / done, so we never lose a tap.
/// * On server failure we log + retain the pending delta so the next flush
///   tries again. We do not surface errors to UI; the local count is
///   canonical for the session.
///
/// Copied from [DhikrCounterController].
class DhikrCounterControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          DhikrCounterController,
          DhikrCounter
        > {
  /// Per-counter state owner — fast, optimistic increments with debounced
  /// server sync.
  ///
  /// Why a family: the counter screen rebuilds its `displayLarge` count text
  /// on every tap. Scoping that rebuild to a single provider keeps the home
  /// list off the rebuild path and the count buttery at 120fps.
  ///
  /// Sync strategy:
  /// * Increments are applied immediately to local state and accumulated
  ///   into [_pendingDelta].
  /// * A 5-second debounce timer fires the accumulated delta to the server.
  /// * The screen also calls [flush] on pop / done, so we never lose a tap.
  /// * On server failure we log + retain the pending delta so the next flush
  ///   tries again. We do not surface errors to UI; the local count is
  ///   canonical for the session.
  ///
  /// Copied from [DhikrCounterController].
  DhikrCounterControllerProvider(String id)
    : this._internal(
        () => DhikrCounterController()..id = id,
        from: dhikrCounterControllerProvider,
        name: r'dhikrCounterControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dhikrCounterControllerHash,
        dependencies: DhikrCounterControllerFamily._dependencies,
        allTransitiveDependencies:
            DhikrCounterControllerFamily._allTransitiveDependencies,
        id: id,
      );

  DhikrCounterControllerProvider._internal(
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
  FutureOr<DhikrCounter> runNotifierBuild(
    covariant DhikrCounterController notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(DhikrCounterController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DhikrCounterControllerProvider._internal(
        () => create()..id = id,
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
  AutoDisposeAsyncNotifierProviderElement<DhikrCounterController, DhikrCounter>
  createElement() {
    return _DhikrCounterControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DhikrCounterControllerProvider && other.id == id;
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
mixin DhikrCounterControllerRef
    on AutoDisposeAsyncNotifierProviderRef<DhikrCounter> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DhikrCounterControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          DhikrCounterController,
          DhikrCounter
        >
    with DhikrCounterControllerRef {
  _DhikrCounterControllerProviderElement(super.provider);

  @override
  String get id => (origin as DhikrCounterControllerProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
