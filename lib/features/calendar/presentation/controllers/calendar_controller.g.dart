// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$islamicEventsHash() => r'7ac5149ed2fa17da89891ecf62a7f861f3c9005c';

/// Cached list of all Islamic events (Hijri-anchored).
///
/// Copied from [islamicEvents].
@ProviderFor(islamicEvents)
final islamicEventsProvider = FutureProvider<List<IslamicEvent>>.internal(
  islamicEvents,
  name: r'islamicEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$islamicEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IslamicEventsRef = FutureProviderRef<List<IslamicEvent>>;
String _$hijriTodayHash() => r'52d1a3341519a02f21c4fd39f99ef5d33618ef1c';

/// Server-side, calendarAdjust-corrected "today" — consumed by the Today
/// screen's greeting so it agrees with the Calendar screen's grid rather
/// than each computing its own (previously uncorrected, and now
/// inconsistent-with-each-other) local Hijri date. Callers should fall back
/// to a local approximation while loading/on error (see
/// `today_screen.dart`) rather than blocking the greeting on network.
///
/// Copied from [hijriToday].
@ProviderFor(hijriToday)
final hijriTodayProvider = AutoDisposeFutureProvider<HijriToday>.internal(
  hijriToday,
  name: r'hijriTodayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hijriTodayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HijriTodayRef = AutoDisposeFutureProviderRef<HijriToday>;
String _$islamicEventByIdHash() => r'7fe518f811501056da79706d13dc953c896fe838';

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

/// Single event lookup helper.
///
/// Copied from [islamicEventById].
@ProviderFor(islamicEventById)
const islamicEventByIdProvider = IslamicEventByIdFamily();

/// Single event lookup helper.
///
/// Copied from [islamicEventById].
class IslamicEventByIdFamily extends Family<AsyncValue<IslamicEvent?>> {
  /// Single event lookup helper.
  ///
  /// Copied from [islamicEventById].
  const IslamicEventByIdFamily();

  /// Single event lookup helper.
  ///
  /// Copied from [islamicEventById].
  IslamicEventByIdProvider call(String id) {
    return IslamicEventByIdProvider(id);
  }

  @override
  IslamicEventByIdProvider getProviderOverride(
    covariant IslamicEventByIdProvider provider,
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
  String? get name => r'islamicEventByIdProvider';
}

/// Single event lookup helper.
///
/// Copied from [islamicEventById].
class IslamicEventByIdProvider
    extends AutoDisposeFutureProvider<IslamicEvent?> {
  /// Single event lookup helper.
  ///
  /// Copied from [islamicEventById].
  IslamicEventByIdProvider(String id)
    : this._internal(
        (ref) => islamicEventById(ref as IslamicEventByIdRef, id),
        from: islamicEventByIdProvider,
        name: r'islamicEventByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$islamicEventByIdHash,
        dependencies: IslamicEventByIdFamily._dependencies,
        allTransitiveDependencies:
            IslamicEventByIdFamily._allTransitiveDependencies,
        id: id,
      );

  IslamicEventByIdProvider._internal(
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
    FutureOr<IslamicEvent?> Function(IslamicEventByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IslamicEventByIdProvider._internal(
        (ref) => create(ref as IslamicEventByIdRef),
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
  AutoDisposeFutureProviderElement<IslamicEvent?> createElement() {
    return _IslamicEventByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IslamicEventByIdProvider && other.id == id;
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
mixin IslamicEventByIdRef on AutoDisposeFutureProviderRef<IslamicEvent?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _IslamicEventByIdProviderElement
    extends AutoDisposeFutureProviderElement<IslamicEvent?>
    with IslamicEventByIdRef {
  _IslamicEventByIdProviderElement(super.provider);

  @override
  String get id => (origin as IslamicEventByIdProvider).id;
}

String _$calendarMonthHash() => r'e2738348607fbba47463c34448371b52411decad';

/// Builds the 42-cell grid for the active anchor and folds in any events for
/// the visible Hijri month.
///
/// Grid-window seeding (which Gregorian dates the 42 cells span) still uses
/// the local `hijri` package — it only needs to be in the right ballpark
/// (the 42-cell window has generous lead-in/lead-out slack either side of
/// the target month), so a ~1-day local approximation here is harmless. The
/// per-cell Hijri day/month/year actually shown to the user — and therefore
/// which cells highlight as "in view" and which events land on which day —
/// comes from the backend's calendarAdjust-corrected `/gregorian-month`
/// endpoint instead, since that's the data users actually read off screen
/// (see kCalendarAdjust's doc comment for why the correction matters).
///
/// Copied from [calendarMonth].
@ProviderFor(calendarMonth)
final calendarMonthProvider =
    AutoDisposeFutureProvider<CalendarMonthData>.internal(
      calendarMonth,
      name: r'calendarMonthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calendarMonthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalendarMonthRef = AutoDisposeFutureProviderRef<CalendarMonthData>;
String _$calendarAnchorControllerHash() =>
    r'39a8815eba087a59314f67d5ce5a34167cc03c86';

/// Controls the active calendar anchor + mode.
///
/// Copied from [CalendarAnchorController].
@ProviderFor(CalendarAnchorController)
final calendarAnchorControllerProvider =
    NotifierProvider<CalendarAnchorController, CalendarAnchor>.internal(
      CalendarAnchorController.new,
      name: r'calendarAnchorControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calendarAnchorControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CalendarAnchorController = Notifier<CalendarAnchor>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
