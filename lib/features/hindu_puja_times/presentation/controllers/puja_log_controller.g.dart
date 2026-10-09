// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puja_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayPujaLogsHash() => r'd38ed0528a660281d830b8afe57d5e078368303c';

/// Today's logs, keyed by sandhya name. Mirrors `TodayLogs` (prayers).
///
/// Copied from [TodayPujaLogs].
@ProviderFor(TodayPujaLogs)
final todayPujaLogsProvider =
    AutoDisposeAsyncNotifierProvider<
      TodayPujaLogs,
      Map<String, PujaLog>
    >.internal(
      TodayPujaLogs.new,
      name: r'todayPujaLogsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayPujaLogsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodayPujaLogs = AutoDisposeAsyncNotifier<Map<String, PujaLog>>;
String _$pujaStatsControllerHash() =>
    r'9b09f3a3b5d0109b952281f9816d2102f02fc150';

/// Aggregate stats — totals, streaks, completion rate. Read-only; no
/// increment method (unlike `PrayerStatsController.incrementQada`, which
/// has no analogue here).
///
/// Copied from [PujaStatsController].
@ProviderFor(PujaStatsController)
final pujaStatsControllerProvider =
    AutoDisposeAsyncNotifierProvider<PujaStatsController, PujaStats>.internal(
      PujaStatsController.new,
      name: r'pujaStatsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pujaStatsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PujaStatsController = AutoDisposeAsyncNotifier<PujaStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
