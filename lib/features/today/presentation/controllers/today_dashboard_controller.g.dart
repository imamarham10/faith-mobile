// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayDashboardHash() => r'd4cfa7c2a08e7436ff844102881ad98290bd3215';

/// The Today screen's single source of numbers.
///
/// Branches on faith here rather than in the widgets, so the screen's
/// progress section is built once for both faiths and cannot drift apart.
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
String _$islamTodayDashboardHash() =>
    r'db6c80e66a531c2617ba578754dbfc3034f235d9';

/// Islam: prayers from the log, dhikr from history, streak derived locally.
///
/// There is no server-side prayer streak to read — the Hindu side has one
/// (`PujaStats.currentStreak`) and the Islam side does not — so this one is
/// computed on-device with [deriveStreak], which mirrors the server's rule
/// exactly so the two faiths' chips mean the same thing.
///
/// Copied from [islamTodayDashboard].
@ProviderFor(islamTodayDashboard)
final islamTodayDashboardProvider =
    AutoDisposeFutureProvider<TodayDashboard>.internal(
      islamTodayDashboard,
      name: r'islamTodayDashboardProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$islamTodayDashboardHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IslamTodayDashboardRef = AutoDisposeFutureProviderRef<TodayDashboard>;
String _$hinduTodayDashboardHash() =>
    r'3b61fe1aada1d565e11d6b0769fd16fe6ecb8241';

/// Hindu: sandhya from the puja log, japa from history, and a streak that is
/// read straight off the server — `GET /puja-times/stats` already computes
/// one, so this faith gets an authoritative number for free.
///
/// Copied from [hinduTodayDashboard].
@ProviderFor(hinduTodayDashboard)
final hinduTodayDashboardProvider =
    AutoDisposeFutureProvider<TodayDashboard>.internal(
      hinduTodayDashboard,
      name: r'hinduTodayDashboardProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$hinduTodayDashboardHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HinduTodayDashboardRef = AutoDisposeFutureProviderRef<TodayDashboard>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
