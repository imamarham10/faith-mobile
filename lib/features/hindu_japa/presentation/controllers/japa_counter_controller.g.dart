// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'japa_counter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$japaCounterControllerHash() =>
    r'a7b773b6c302e487c31ac7834bda131493b5d6c5';

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

abstract class _$JapaCounterController
    extends BuildlessAutoDisposeAsyncNotifier<JapaCounter> {
  late final String id;

  FutureOr<JapaCounter> build(String id);
}

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync. Mirrors `DhikrCounterController`, with one important
/// difference driven by the backend contract: this API's `count` field is
/// an **absolute** value, not a delta. That makes sync retries naturally
/// idempotent — a failed flush can just resend the current local count
/// next time, no delta bookkeeping required.
///
/// Copied from [JapaCounterController].
@ProviderFor(JapaCounterController)
const japaCounterControllerProvider = JapaCounterControllerFamily();

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync. Mirrors `DhikrCounterController`, with one important
/// difference driven by the backend contract: this API's `count` field is
/// an **absolute** value, not a delta. That makes sync retries naturally
/// idempotent — a failed flush can just resend the current local count
/// next time, no delta bookkeeping required.
///
/// Copied from [JapaCounterController].
class JapaCounterControllerFamily extends Family<AsyncValue<JapaCounter>> {
  /// Per-counter state owner — fast, optimistic increments with debounced
  /// server sync. Mirrors `DhikrCounterController`, with one important
  /// difference driven by the backend contract: this API's `count` field is
  /// an **absolute** value, not a delta. That makes sync retries naturally
  /// idempotent — a failed flush can just resend the current local count
  /// next time, no delta bookkeeping required.
  ///
  /// Copied from [JapaCounterController].
  const JapaCounterControllerFamily();

  /// Per-counter state owner — fast, optimistic increments with debounced
  /// server sync. Mirrors `DhikrCounterController`, with one important
  /// difference driven by the backend contract: this API's `count` field is
  /// an **absolute** value, not a delta. That makes sync retries naturally
  /// idempotent — a failed flush can just resend the current local count
  /// next time, no delta bookkeeping required.
  ///
  /// Copied from [JapaCounterController].
  JapaCounterControllerProvider call(String id) {
    return JapaCounterControllerProvider(id);
  }

  @override
  JapaCounterControllerProvider getProviderOverride(
    covariant JapaCounterControllerProvider provider,
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
  String? get name => r'japaCounterControllerProvider';
}

/// Per-counter state owner — fast, optimistic increments with debounced
/// server sync. Mirrors `DhikrCounterController`, with one important
/// difference driven by the backend contract: this API's `count` field is
/// an **absolute** value, not a delta. That makes sync retries naturally
/// idempotent — a failed flush can just resend the current local count
/// next time, no delta bookkeeping required.
///
/// Copied from [JapaCounterController].
class JapaCounterControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          JapaCounterController,
          JapaCounter
        > {
  /// Per-counter state owner — fast, optimistic increments with debounced
  /// server sync. Mirrors `DhikrCounterController`, with one important
  /// difference driven by the backend contract: this API's `count` field is
  /// an **absolute** value, not a delta. That makes sync retries naturally
  /// idempotent — a failed flush can just resend the current local count
  /// next time, no delta bookkeeping required.
  ///
  /// Copied from [JapaCounterController].
  JapaCounterControllerProvider(String id)
    : this._internal(
        () => JapaCounterController()..id = id,
        from: japaCounterControllerProvider,
        name: r'japaCounterControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$japaCounterControllerHash,
        dependencies: JapaCounterControllerFamily._dependencies,
        allTransitiveDependencies:
            JapaCounterControllerFamily._allTransitiveDependencies,
        id: id,
      );

  JapaCounterControllerProvider._internal(
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
  FutureOr<JapaCounter> runNotifierBuild(
    covariant JapaCounterController notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(JapaCounterController Function() create) {
    return ProviderOverride(
      origin: this,
      override: JapaCounterControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<JapaCounterController, JapaCounter>
  createElement() {
    return _JapaCounterControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JapaCounterControllerProvider && other.id == id;
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
mixin JapaCounterControllerRef
    on AutoDisposeAsyncNotifierProviderRef<JapaCounter> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JapaCounterControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          JapaCounterController,
          JapaCounter
        >
    with JapaCounterControllerRef {
  _JapaCounterControllerProviderElement(super.provider);

  @override
  String get id => (origin as JapaCounterControllerProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
