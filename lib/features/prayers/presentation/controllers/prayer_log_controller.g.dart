// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayLogsHash() => r'b86159c9ac1a9be7aec308572ec09c9f1cfdbcca';

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
    r'52f900e551f9a10e8f5c2079bd27b86d1f0e3535';

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
