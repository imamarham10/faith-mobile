// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_verse_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyVerseHash() => r'44030f968a009c3c619a32e9d4679b29860b6825';

/// Verse of the day — mirrors [dailyHadith]'s shape so the two Today cards
/// behave identically (same four states, same keep-alive).
///
/// Resolves today's curated [VerseRef] against the live corpus. Kept alive
/// because the answer is stable for the whole calendar day and the surah
/// payload is the largest single read on this screen.
///
/// Copied from [dailyVerse].
@ProviderFor(dailyVerse)
final dailyVerseProvider = FutureProvider<DailyVerse>.internal(
  dailyVerse,
  name: r'dailyVerseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyVerseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyVerseRef = FutureProviderRef<DailyVerse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
