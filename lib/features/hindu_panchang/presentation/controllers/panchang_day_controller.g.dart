// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_day_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$panchangByDateHash() => r'0ef58f78afc4448558668b49ef504061928a146b';

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

/// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
/// screen reached by tapping a grid cell. Same location-gated,
/// null-on-unavailable pattern as [PanchangTodayController]. Not
/// `keepAlive` — an autodispose family per date is fine, since a user opens
/// a handful of day-detail screens per session at most.
///
/// Copied from [panchangByDate].
@ProviderFor(panchangByDate)
const panchangByDateProvider = PanchangByDateFamily();

/// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
/// screen reached by tapping a grid cell. Same location-gated,
/// null-on-unavailable pattern as [PanchangTodayController]. Not
/// `keepAlive` — an autodispose family per date is fine, since a user opens
/// a handful of day-detail screens per session at most.
///
/// Copied from [panchangByDate].
class PanchangByDateFamily extends Family<AsyncValue<PanchangDay?>> {
  /// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
  /// screen reached by tapping a grid cell. Same location-gated,
  /// null-on-unavailable pattern as [PanchangTodayController]. Not
  /// `keepAlive` — an autodispose family per date is fine, since a user opens
  /// a handful of day-detail screens per session at most.
  ///
  /// Copied from [panchangByDate].
  const PanchangByDateFamily();

  /// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
  /// screen reached by tapping a grid cell. Same location-gated,
  /// null-on-unavailable pattern as [PanchangTodayController]. Not
  /// `keepAlive` — an autodispose family per date is fine, since a user opens
  /// a handful of day-detail screens per session at most.
  ///
  /// Copied from [panchangByDate].
  PanchangByDateProvider call(String date) {
    return PanchangByDateProvider(date);
  }

  @override
  PanchangByDateProvider getProviderOverride(
    covariant PanchangByDateProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'panchangByDateProvider';
}

/// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
/// screen reached by tapping a grid cell. Same location-gated,
/// null-on-unavailable pattern as [PanchangTodayController]. Not
/// `keepAlive` — an autodispose family per date is fine, since a user opens
/// a handful of day-detail screens per session at most.
///
/// Copied from [panchangByDate].
class PanchangByDateProvider extends AutoDisposeFutureProvider<PanchangDay?> {
  /// Fetches a specific date's panchang (`yyyy-MM-dd`), for the day-detail
  /// screen reached by tapping a grid cell. Same location-gated,
  /// null-on-unavailable pattern as [PanchangTodayController]. Not
  /// `keepAlive` — an autodispose family per date is fine, since a user opens
  /// a handful of day-detail screens per session at most.
  ///
  /// Copied from [panchangByDate].
  PanchangByDateProvider(String date)
    : this._internal(
        (ref) => panchangByDate(ref as PanchangByDateRef, date),
        from: panchangByDateProvider,
        name: r'panchangByDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$panchangByDateHash,
        dependencies: PanchangByDateFamily._dependencies,
        allTransitiveDependencies:
            PanchangByDateFamily._allTransitiveDependencies,
        date: date,
      );

  PanchangByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String date;

  @override
  Override overrideWith(
    FutureOr<PanchangDay?> Function(PanchangByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PanchangByDateProvider._internal(
        (ref) => create(ref as PanchangByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PanchangDay?> createElement() {
    return _PanchangByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PanchangByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PanchangByDateRef on AutoDisposeFutureProviderRef<PanchangDay?> {
  /// The parameter `date` of this provider.
  String get date;
}

class _PanchangByDateProviderElement
    extends AutoDisposeFutureProviderElement<PanchangDay?>
    with PanchangByDateRef {
  _PanchangByDateProviderElement(super.provider);

  @override
  String get date => (origin as PanchangByDateProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
