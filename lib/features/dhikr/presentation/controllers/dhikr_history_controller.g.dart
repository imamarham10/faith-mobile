// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dhikrHistoryGroupedHash() =>
    r'82b25761ce3b9c4a40e260c6354c4df38680df83';

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

/// Dhikr session history grouped by day, descending.
///
/// Defaults to the last 30 days; the screen can pass a custom range later
/// (Phase 2 — analytics view).
///
/// Copied from [dhikrHistoryGrouped].
@ProviderFor(dhikrHistoryGrouped)
const dhikrHistoryGroupedProvider = DhikrHistoryGroupedFamily();

/// Dhikr session history grouped by day, descending.
///
/// Defaults to the last 30 days; the screen can pass a custom range later
/// (Phase 2 — analytics view).
///
/// Copied from [dhikrHistoryGrouped].
class DhikrHistoryGroupedFamily
    extends Family<AsyncValue<Map<DateTime, List<DhikrHistoryEntry>>>> {
  /// Dhikr session history grouped by day, descending.
  ///
  /// Defaults to the last 30 days; the screen can pass a custom range later
  /// (Phase 2 — analytics view).
  ///
  /// Copied from [dhikrHistoryGrouped].
  const DhikrHistoryGroupedFamily();

  /// Dhikr session history grouped by day, descending.
  ///
  /// Defaults to the last 30 days; the screen can pass a custom range later
  /// (Phase 2 — analytics view).
  ///
  /// Copied from [dhikrHistoryGrouped].
  DhikrHistoryGroupedProvider call({DateTime? fromDate, DateTime? toDate}) {
    return DhikrHistoryGroupedProvider(fromDate: fromDate, toDate: toDate);
  }

  @override
  DhikrHistoryGroupedProvider getProviderOverride(
    covariant DhikrHistoryGroupedProvider provider,
  ) {
    return call(fromDate: provider.fromDate, toDate: provider.toDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dhikrHistoryGroupedProvider';
}

/// Dhikr session history grouped by day, descending.
///
/// Defaults to the last 30 days; the screen can pass a custom range later
/// (Phase 2 — analytics view).
///
/// Copied from [dhikrHistoryGrouped].
class DhikrHistoryGroupedProvider
    extends AutoDisposeFutureProvider<Map<DateTime, List<DhikrHistoryEntry>>> {
  /// Dhikr session history grouped by day, descending.
  ///
  /// Defaults to the last 30 days; the screen can pass a custom range later
  /// (Phase 2 — analytics view).
  ///
  /// Copied from [dhikrHistoryGrouped].
  DhikrHistoryGroupedProvider({DateTime? fromDate, DateTime? toDate})
    : this._internal(
        (ref) => dhikrHistoryGrouped(
          ref as DhikrHistoryGroupedRef,
          fromDate: fromDate,
          toDate: toDate,
        ),
        from: dhikrHistoryGroupedProvider,
        name: r'dhikrHistoryGroupedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dhikrHistoryGroupedHash,
        dependencies: DhikrHistoryGroupedFamily._dependencies,
        allTransitiveDependencies:
            DhikrHistoryGroupedFamily._allTransitiveDependencies,
        fromDate: fromDate,
        toDate: toDate,
      );

  DhikrHistoryGroupedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.fromDate,
    required this.toDate,
  }) : super.internal();

  final DateTime? fromDate;
  final DateTime? toDate;

  @override
  Override overrideWith(
    FutureOr<Map<DateTime, List<DhikrHistoryEntry>>> Function(
      DhikrHistoryGroupedRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DhikrHistoryGroupedProvider._internal(
        (ref) => create(ref as DhikrHistoryGroupedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<DateTime, List<DhikrHistoryEntry>>>
  createElement() {
    return _DhikrHistoryGroupedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DhikrHistoryGroupedProvider &&
        other.fromDate == fromDate &&
        other.toDate == toDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, fromDate.hashCode);
    hash = _SystemHash.combine(hash, toDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DhikrHistoryGroupedRef
    on AutoDisposeFutureProviderRef<Map<DateTime, List<DhikrHistoryEntry>>> {
  /// The parameter `fromDate` of this provider.
  DateTime? get fromDate;

  /// The parameter `toDate` of this provider.
  DateTime? get toDate;
}

class _DhikrHistoryGroupedProviderElement
    extends
        AutoDisposeFutureProviderElement<Map<DateTime, List<DhikrHistoryEntry>>>
    with DhikrHistoryGroupedRef {
  _DhikrHistoryGroupedProviderElement(super.provider);

  @override
  DateTime? get fromDate => (origin as DhikrHistoryGroupedProvider).fromDate;
  @override
  DateTime? get toDate => (origin as DhikrHistoryGroupedProvider).toDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
