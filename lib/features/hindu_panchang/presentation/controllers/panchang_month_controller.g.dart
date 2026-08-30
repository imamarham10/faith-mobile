// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_month_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$panchangMonthGridHash() => r'297c7c22264a14b215478911b608f1969c097eb1';

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

/// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
/// A family keyed by both, `keepAlive`, so paging back to a previously
/// viewed month within a session is instant — the screen watches
/// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
/// reading the anchor internally, so each month combination gets its own
/// cached instance instead of one shared provider re-fetching on every page.
///
/// Copied from [panchangMonthGrid].
@ProviderFor(panchangMonthGrid)
const panchangMonthGridProvider = PanchangMonthGridFamily();

/// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
/// A family keyed by both, `keepAlive`, so paging back to a previously
/// viewed month within a session is instant — the screen watches
/// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
/// reading the anchor internally, so each month combination gets its own
/// cached instance instead of one shared provider re-fetching on every page.
///
/// Copied from [panchangMonthGrid].
class PanchangMonthGridFamily
    extends Family<AsyncValue<PanchangMonthGridData?>> {
  /// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
  /// A family keyed by both, `keepAlive`, so paging back to a previously
  /// viewed month within a session is instant — the screen watches
  /// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
  /// reading the anchor internally, so each month combination gets its own
  /// cached instance instead of one shared provider re-fetching on every page.
  ///
  /// Copied from [panchangMonthGrid].
  const PanchangMonthGridFamily();

  /// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
  /// A family keyed by both, `keepAlive`, so paging back to a previously
  /// viewed month within a session is instant — the screen watches
  /// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
  /// reading the anchor internally, so each month combination gets its own
  /// cached instance instead of one shared provider re-fetching on every page.
  ///
  /// Copied from [panchangMonthGrid].
  PanchangMonthGridProvider call(int year, int month) {
    return PanchangMonthGridProvider(year, month);
  }

  @override
  PanchangMonthGridProvider getProviderOverride(
    covariant PanchangMonthGridProvider provider,
  ) {
    return call(provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'panchangMonthGridProvider';
}

/// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
/// A family keyed by both, `keepAlive`, so paging back to a previously
/// viewed month within a session is instant — the screen watches
/// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
/// reading the anchor internally, so each month combination gets its own
/// cached instance instead of one shared provider re-fetching on every page.
///
/// Copied from [panchangMonthGrid].
class PanchangMonthGridProvider extends FutureProvider<PanchangMonthGridData?> {
  /// Builds the 42-cell (Sunday-leading) month grid for a given (year, month).
  /// A family keyed by both, `keepAlive`, so paging back to a previously
  /// viewed month within a session is instant — the screen watches
  /// `panchangMonthGridProvider(anchor.year, anchor.month)` rather than
  /// reading the anchor internally, so each month combination gets its own
  /// cached instance instead of one shared provider re-fetching on every page.
  ///
  /// Copied from [panchangMonthGrid].
  PanchangMonthGridProvider(int year, int month)
    : this._internal(
        (ref) => panchangMonthGrid(ref as PanchangMonthGridRef, year, month),
        from: panchangMonthGridProvider,
        name: r'panchangMonthGridProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$panchangMonthGridHash,
        dependencies: PanchangMonthGridFamily._dependencies,
        allTransitiveDependencies:
            PanchangMonthGridFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  PanchangMonthGridProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<PanchangMonthGridData?> Function(PanchangMonthGridRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PanchangMonthGridProvider._internal(
        (ref) => create(ref as PanchangMonthGridRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  FutureProviderElement<PanchangMonthGridData?> createElement() {
    return _PanchangMonthGridProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PanchangMonthGridProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PanchangMonthGridRef on FutureProviderRef<PanchangMonthGridData?> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _PanchangMonthGridProviderElement
    extends FutureProviderElement<PanchangMonthGridData?>
    with PanchangMonthGridRef {
  _PanchangMonthGridProviderElement(super.provider);

  @override
  int get year => (origin as PanchangMonthGridProvider).year;
  @override
  int get month => (origin as PanchangMonthGridProvider).month;
}

String _$panchangAnchorControllerHash() =>
    r'51c2bc70039feab386b8609e972019a5c10a9ea9';

/// See also [PanchangAnchorController].
@ProviderFor(PanchangAnchorController)
final panchangAnchorControllerProvider =
    NotifierProvider<PanchangAnchorController, PanchangAnchor>.internal(
      PanchangAnchorController.new,
      name: r'panchangAnchorControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$panchangAnchorControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PanchangAnchorController = Notifier<PanchangAnchor>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
