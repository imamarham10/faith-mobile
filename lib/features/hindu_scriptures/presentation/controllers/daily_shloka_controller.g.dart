// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_shloka_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyShlokaHash() => r'b12f49e5250eceb83daa3faa6283d6dd22301f99';

/// "Shloka for today" — used by the Hindu Today screen card, mirroring
/// `dailyHadithProvider`'s role for Islam.
///
/// Unlike hadiths, the backend has no `/scriptures/daily` endpoint — only
/// `/scriptures/featured`, a curated pool for exactly this kind of surface
/// (each entry is hand-marked `isFeatured` server-side). So the "for today"
/// rotation happens client-side: a stable pick keyed by day-of-year, which
/// changes once a day and is identical for every user on the same day
/// without needing per-user or per-request randomness.
///
/// Copied from [dailyShloka].
@ProviderFor(dailyShloka)
final dailyShlokaProvider = FutureProvider<ScriptureVerse?>.internal(
  dailyShloka,
  name: r'dailyShlokaProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyShlokaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyShlokaRef = FutureProviderRef<ScriptureVerse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
