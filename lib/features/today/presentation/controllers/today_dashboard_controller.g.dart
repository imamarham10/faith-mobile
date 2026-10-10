// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activitySnapshotHash() => r'6aebacad70bcb92e150610f57cee6733ef987a93';

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

/// The raw engine reads, cached across rebuilds.
///
/// Separate from [todayDashboard] so that recording something rebuilds the
/// *projection* — which is local and instant — without firing a network
/// request per tap. A dhikr counter tapped a hundred times would otherwise
/// make a hundred `GET /today`s.
///
/// Invalidated after a flush actually lands, which is when the server has
/// something new to say.
///
/// Copied from [activitySnapshot].
@ProviderFor(activitySnapshot)
const activitySnapshotProvider = ActivitySnapshotFamily();

/// The raw engine reads, cached across rebuilds.
///
/// Separate from [todayDashboard] so that recording something rebuilds the
/// *projection* — which is local and instant — without firing a network
/// request per tap. A dhikr counter tapped a hundred times would otherwise
/// make a hundred `GET /today`s.
///
/// Invalidated after a flush actually lands, which is when the server has
/// something new to say.
///
/// Copied from [activitySnapshot].
class ActivitySnapshotFamily
    extends
        Family<
          AsyncValue<
            ({
              ActivityTodaySnapshot today,
              List<ActivityHistoryDay> history,
              bool isStale,
            })
          >
        > {
  /// The raw engine reads, cached across rebuilds.
  ///
  /// Separate from [todayDashboard] so that recording something rebuilds the
  /// *projection* — which is local and instant — without firing a network
  /// request per tap. A dhikr counter tapped a hundred times would otherwise
  /// make a hundred `GET /today`s.
  ///
  /// Invalidated after a flush actually lands, which is when the server has
  /// something new to say.
  ///
  /// Copied from [activitySnapshot].
  const ActivitySnapshotFamily();

  /// The raw engine reads, cached across rebuilds.
  ///
  /// Separate from [todayDashboard] so that recording something rebuilds the
  /// *projection* — which is local and instant — without firing a network
  /// request per tap. A dhikr counter tapped a hundred times would otherwise
  /// make a hundred `GET /today`s.
  ///
  /// Invalidated after a flush actually lands, which is when the server has
  /// something new to say.
  ///
  /// Copied from [activitySnapshot].
  ActivitySnapshotProvider call(ActivityFaith faith) {
    return ActivitySnapshotProvider(faith);
  }

  @override
  ActivitySnapshotProvider getProviderOverride(
    covariant ActivitySnapshotProvider provider,
  ) {
    return call(provider.faith);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activitySnapshotProvider';
}

/// The raw engine reads, cached across rebuilds.
///
/// Separate from [todayDashboard] so that recording something rebuilds the
/// *projection* — which is local and instant — without firing a network
/// request per tap. A dhikr counter tapped a hundred times would otherwise
/// make a hundred `GET /today`s.
///
/// Invalidated after a flush actually lands, which is when the server has
/// something new to say.
///
/// Copied from [activitySnapshot].
class ActivitySnapshotProvider
    extends
        AutoDisposeFutureProvider<
          ({
            ActivityTodaySnapshot today,
            List<ActivityHistoryDay> history,
            bool isStale,
          })
        > {
  /// The raw engine reads, cached across rebuilds.
  ///
  /// Separate from [todayDashboard] so that recording something rebuilds the
  /// *projection* — which is local and instant — without firing a network
  /// request per tap. A dhikr counter tapped a hundred times would otherwise
  /// make a hundred `GET /today`s.
  ///
  /// Invalidated after a flush actually lands, which is when the server has
  /// something new to say.
  ///
  /// Copied from [activitySnapshot].
  ActivitySnapshotProvider(ActivityFaith faith)
    : this._internal(
        (ref) => activitySnapshot(ref as ActivitySnapshotRef, faith),
        from: activitySnapshotProvider,
        name: r'activitySnapshotProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activitySnapshotHash,
        dependencies: ActivitySnapshotFamily._dependencies,
        allTransitiveDependencies:
            ActivitySnapshotFamily._allTransitiveDependencies,
        faith: faith,
      );

  ActivitySnapshotProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.faith,
  }) : super.internal();

  final ActivityFaith faith;

  @override
  Override overrideWith(
    FutureOr<
      ({
        ActivityTodaySnapshot today,
        List<ActivityHistoryDay> history,
        bool isStale,
      })
    >
    Function(ActivitySnapshotRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActivitySnapshotProvider._internal(
        (ref) => create(ref as ActivitySnapshotRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        faith: faith,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    ({
      ActivityTodaySnapshot today,
      List<ActivityHistoryDay> history,
      bool isStale,
    })
  >
  createElement() {
    return _ActivitySnapshotProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivitySnapshotProvider && other.faith == faith;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, faith.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActivitySnapshotRef
    on
        AutoDisposeFutureProviderRef<
          ({
            ActivityTodaySnapshot today,
            List<ActivityHistoryDay> history,
            bool isStale,
          })
        > {
  /// The parameter `faith` of this provider.
  ActivityFaith get faith;
}

class _ActivitySnapshotProviderElement
    extends
        AutoDisposeFutureProviderElement<
          ({
            ActivityTodaySnapshot today,
            List<ActivityHistoryDay> history,
            bool isStale,
          })
        >
    with ActivitySnapshotRef {
  _ActivitySnapshotProviderElement(super.provider);

  @override
  ActivityFaith get faith => (origin as ActivitySnapshotProvider).faith;
}

String _$todayDashboardHash() => r'b02650721a453816ff07fa0473417d34b900e517';

/// The Today screen's numbers, for whichever faith is selected.
///
/// Branches on faith exactly once — to pick the content pack — rather than
/// in the widgets, so the progress section is built once for both faiths
/// and cannot drift apart. There is no Islam copy of this function and no
/// Hindu one; that is the change Task 1.12 makes possible, because the two
/// faiths now read the same endpoint instead of four different ones.
///
/// Copied from [todayDashboard].
@ProviderFor(todayDashboard)
final todayDashboardProvider =
    AutoDisposeFutureProvider<TodayDashboard>.internal(
      todayDashboard,
      name: r'todayDashboardProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayDashboardHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayDashboardRef = AutoDisposeFutureProviderRef<TodayDashboard>;
String _$practiceChecklistHash() => r'227b68754bb1af30cb1c89915c4b87fbe967ffc6';

/// The day's named acts, ticked from the log that owns them.
///
/// Deliberately **not** read from the engine. `/today`'s `counts` says
/// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
/// checklist is exactly a question about which. The `sourceRef` that
/// carries `prayer:fajr` is stored but not projected by any Phase 1
/// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
/// puja logs remain the source for the ticks, as they always were; the
/// engine mirrors them through `record()`.
///
/// **Its own provider, so it is memoised.** [todayDashboard] watches the
/// record counter and therefore re-runs its whole body on every recorded
/// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
/// past. Twenty verses was twenty requests.
///
/// Being memoised, it must be invalidated explicitly when a prayer or
/// sandhya is logged — invalidating [todayDashboardProvider] does *not*
/// reach it, because invalidating a watcher does nothing to what it
/// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
/// is the only thing that changes a tick.
///
/// Copied from [practiceChecklist].
@ProviderFor(practiceChecklist)
const practiceChecklistProvider = PracticeChecklistFamily();

/// The day's named acts, ticked from the log that owns them.
///
/// Deliberately **not** read from the engine. `/today`'s `counts` says
/// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
/// checklist is exactly a question about which. The `sourceRef` that
/// carries `prayer:fajr` is stored but not projected by any Phase 1
/// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
/// puja logs remain the source for the ticks, as they always were; the
/// engine mirrors them through `record()`.
///
/// **Its own provider, so it is memoised.** [todayDashboard] watches the
/// record counter and therefore re-runs its whole body on every recorded
/// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
/// past. Twenty verses was twenty requests.
///
/// Being memoised, it must be invalidated explicitly when a prayer or
/// sandhya is logged — invalidating [todayDashboardProvider] does *not*
/// reach it, because invalidating a watcher does nothing to what it
/// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
/// is the only thing that changes a tick.
///
/// Copied from [practiceChecklist].
class PracticeChecklistFamily extends Family<AsyncValue<List<ChecklistItem>>> {
  /// The day's named acts, ticked from the log that owns them.
  ///
  /// Deliberately **not** read from the engine. `/today`'s `counts` says
  /// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
  /// checklist is exactly a question about which. The `sourceRef` that
  /// carries `prayer:fajr` is stored but not projected by any Phase 1
  /// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
  /// puja logs remain the source for the ticks, as they always were; the
  /// engine mirrors them through `record()`.
  ///
  /// **Its own provider, so it is memoised.** [todayDashboard] watches the
  /// record counter and therefore re-runs its whole body on every recorded
  /// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
  /// past. Twenty verses was twenty requests.
  ///
  /// Being memoised, it must be invalidated explicitly when a prayer or
  /// sandhya is logged — invalidating [todayDashboardProvider] does *not*
  /// reach it, because invalidating a watcher does nothing to what it
  /// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
  /// is the only thing that changes a tick.
  ///
  /// Copied from [practiceChecklist].
  const PracticeChecklistFamily();

  /// The day's named acts, ticked from the log that owns them.
  ///
  /// Deliberately **not** read from the engine. `/today`'s `counts` says
  /// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
  /// checklist is exactly a question about which. The `sourceRef` that
  /// carries `prayer:fajr` is stored but not projected by any Phase 1
  /// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
  /// puja logs remain the source for the ticks, as they always were; the
  /// engine mirrors them through `record()`.
  ///
  /// **Its own provider, so it is memoised.** [todayDashboard] watches the
  /// record counter and therefore re-runs its whole body on every recorded
  /// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
  /// past. Twenty verses was twenty requests.
  ///
  /// Being memoised, it must be invalidated explicitly when a prayer or
  /// sandhya is logged — invalidating [todayDashboardProvider] does *not*
  /// reach it, because invalidating a watcher does nothing to what it
  /// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
  /// is the only thing that changes a tick.
  ///
  /// Copied from [practiceChecklist].
  PracticeChecklistProvider call(FaithId faith) {
    return PracticeChecklistProvider(faith);
  }

  @override
  PracticeChecklistProvider getProviderOverride(
    covariant PracticeChecklistProvider provider,
  ) {
    return call(provider.faith);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'practiceChecklistProvider';
}

/// The day's named acts, ticked from the log that owns them.
///
/// Deliberately **not** read from the engine. `/today`'s `counts` says
/// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
/// checklist is exactly a question about which. The `sourceRef` that
/// carries `prayer:fajr` is stored but not projected by any Phase 1
/// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
/// puja logs remain the source for the ticks, as they always were; the
/// engine mirrors them through `record()`.
///
/// **Its own provider, so it is memoised.** [todayDashboard] watches the
/// record counter and therefore re-runs its whole body on every recorded
/// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
/// past. Twenty verses was twenty requests.
///
/// Being memoised, it must be invalidated explicitly when a prayer or
/// sandhya is logged — invalidating [todayDashboardProvider] does *not*
/// reach it, because invalidating a watcher does nothing to what it
/// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
/// is the only thing that changes a tick.
///
/// Copied from [practiceChecklist].
class PracticeChecklistProvider
    extends AutoDisposeFutureProvider<List<ChecklistItem>> {
  /// The day's named acts, ticked from the log that owns them.
  ///
  /// Deliberately **not** read from the engine. `/today`'s `counts` says
  /// `prayer: 3` — a sum, not a set — so it cannot say *which* three, and a
  /// checklist is exactly a question about which. The `sourceRef` that
  /// carries `prayer:fajr` is stored but not projected by any Phase 1
  /// endpoint (§1.6 makes it load-bearing from Phase 2). So the prayer and
  /// puja logs remain the source for the ticks, as they always were; the
  /// engine mirrors them through `record()`.
  ///
  /// **Its own provider, so it is memoised.** [todayDashboard] watches the
  /// record counter and therefore re-runs its whole body on every recorded
  /// act; inlined, this read fired a `GET /prayers/log` per verse scrolled
  /// past. Twenty verses was twenty requests.
  ///
  /// Being memoised, it must be invalidated explicitly when a prayer or
  /// sandhya is logged — invalidating [todayDashboardProvider] does *not*
  /// reach it, because invalidating a watcher does nothing to what it
  /// watches. `TodayLogs.log` and `TodayPujaLogs.log` both do so, and that
  /// is the only thing that changes a tick.
  ///
  /// Copied from [practiceChecklist].
  PracticeChecklistProvider(FaithId faith)
    : this._internal(
        (ref) => practiceChecklist(ref as PracticeChecklistRef, faith),
        from: practiceChecklistProvider,
        name: r'practiceChecklistProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$practiceChecklistHash,
        dependencies: PracticeChecklistFamily._dependencies,
        allTransitiveDependencies:
            PracticeChecklistFamily._allTransitiveDependencies,
        faith: faith,
      );

  PracticeChecklistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.faith,
  }) : super.internal();

  final FaithId faith;

  @override
  Override overrideWith(
    FutureOr<List<ChecklistItem>> Function(PracticeChecklistRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PracticeChecklistProvider._internal(
        (ref) => create(ref as PracticeChecklistRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        faith: faith,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChecklistItem>> createElement() {
    return _PracticeChecklistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PracticeChecklistProvider && other.faith == faith;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, faith.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PracticeChecklistRef
    on AutoDisposeFutureProviderRef<List<ChecklistItem>> {
  /// The parameter `faith` of this provider.
  FaithId get faith;
}

class _PracticeChecklistProviderElement
    extends AutoDisposeFutureProviderElement<List<ChecklistItem>>
    with PracticeChecklistRef {
  _PracticeChecklistProviderElement(super.provider);

  @override
  FaithId get faith => (origin as PracticeChecklistProvider).faith;
}

String _$activitySnapshotCacheHash() =>
    r'8f100909800f84e0400db26b5408a4f7001dc94c';

/// The last good response per faith, so a lost connection does not blank
/// the screen.
///
/// Without this a failed `GET /today` sends `TodayProgressSection` down its
/// error branch, and a user who turns off wifi and records a verse watches
/// the whole section disappear — on the one screen whose entire promise is
/// that offline worship still counts. In memory only: it is a render cache,
/// not a second source of truth, and persisting it would create a second
/// place the streak can be wrong.
///
/// Copied from [ActivitySnapshotCache].
@ProviderFor(ActivitySnapshotCache)
final activitySnapshotCacheProvider =
    NotifierProvider<
      ActivitySnapshotCache,
      Map<
        ActivityFaith,
        ({ActivityTodaySnapshot today, List<ActivityHistoryDay> history})
      >
    >.internal(
      ActivitySnapshotCache.new,
      name: r'activitySnapshotCacheProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activitySnapshotCacheHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivitySnapshotCache =
    Notifier<
      Map<
        ActivityFaith,
        ({ActivityTodaySnapshot today, List<ActivityHistoryDay> history})
      >
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
