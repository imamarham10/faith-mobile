// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_katha_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyKathaHash() => r'f107056348efbd10913be04445a76b2225a57768';

/// "Katha for today" — used by the Hindu Today screen card, mirroring
/// `dailyHadithProvider`'s role for Islam.
///
/// The backend has no `/stories/daily` or `/stories/featured` endpoint and
/// no curated flag on the story DTO (unlike scripture verses' `isFeatured`),
/// so this picks a stable day-of-year index into the full, unfiltered
/// story list — small enough (order of tens) to fetch whole. Same rotation
/// rule as `dailyShlokaProvider`: identical for every user on a given day.
///
/// Copied from [dailyKatha].
@ProviderFor(dailyKatha)
final dailyKathaProvider = FutureProvider<HinduStory?>.internal(
  dailyKatha,
  name: r'dailyKathaProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyKathaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyKathaRef = FutureProviderRef<HinduStory?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
