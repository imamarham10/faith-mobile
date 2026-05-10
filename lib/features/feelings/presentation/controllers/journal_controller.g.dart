// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentJournalEntriesHash() =>
    r'a50f6a01cccdf83f10d71bb90beba4a831a8ed0d';

/// Three most-recent entries, cheap to read on the Reflect home.
///
/// Copied from [recentJournalEntries].
@ProviderFor(recentJournalEntries)
final recentJournalEntriesProvider =
    AutoDisposeProvider<List<JournalEntry>>.internal(
      recentJournalEntries,
      name: r'recentJournalEntriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentJournalEntriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentJournalEntriesRef = AutoDisposeProviderRef<List<JournalEntry>>;
String _$journalEntriesThisMonthHash() =>
    r'82c57bce7b1befc2f48b6b37e84ff3a6b36cfe68';

/// Count of entries created in the current calendar month — used by the
/// "Journal" home card subtitle.
///
/// Copied from [journalEntriesThisMonth].
@ProviderFor(journalEntriesThisMonth)
final journalEntriesThisMonthProvider = AutoDisposeProvider<int>.internal(
  journalEntriesThisMonth,
  name: r'journalEntriesThisMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalEntriesThisMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalEntriesThisMonthRef = AutoDisposeProviderRef<int>;
String _$journalControllerHash() => r'0e4e899875c3c108ff4256b3cd2df115037237f1';

/// Persisted reflection journal.
///
/// The backend exposes no journal endpoint (per APIs.md), so the device is
/// the source of truth for now. All mutations go through this controller
/// so the screens never touch SharedPreferences directly.
///
/// Copied from [JournalController].
@ProviderFor(JournalController)
final journalControllerProvider =
    AsyncNotifierProvider<JournalController, List<JournalEntry>>.internal(
      JournalController.new,
      name: r'journalControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$journalControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JournalController = AsyncNotifier<List<JournalEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
