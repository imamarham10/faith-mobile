// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayLogsHash() => r'8bb08a22e4e491082526c9ca1d119c55e9dacf07';

/// Today's logs, indexed by `prayerName.toLowerCase()` for O(1) lookup.
///
/// Copied from [TodayLogs].
@ProviderFor(TodayLogs)
final todayLogsProvider =
    AutoDisposeAsyncNotifierProvider<
      TodayLogs,
      Map<String, PrayerLog>
    >.internal(
      TodayLogs.new,
      name: r'todayLogsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayLogsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodayLogs = AutoDisposeAsyncNotifier<Map<String, PrayerLog>>;
String _$prayerStatsControllerHash() =>
    r'7cbb554c844477cc9c36dbd5d8f690763eb9eb3d';

/// Aggregate qaza stats for the qaza tracker screen.
///
/// Copied from [PrayerStatsController].
@ProviderFor(PrayerStatsController)
final prayerStatsControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PrayerStatsController,
      PrayerStats
    >.internal(
      PrayerStatsController.new,
      name: r'prayerStatsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$prayerStatsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PrayerStatsController = AutoDisposeAsyncNotifier<PrayerStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
