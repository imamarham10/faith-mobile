import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/dhikr/presentation/controllers/dhikr_counters_controller.dart';
import '../../features/dhikr/presentation/controllers/dhikr_goals_controller.dart';
import '../../features/duas/presentation/controllers/dua_favorites_controller.dart';
import '../../features/feelings/presentation/controllers/journal_controller.dart';
import '../../features/hindu_japa/presentation/controllers/japa_counters_controller.dart';
import '../../features/hindu_japa/presentation/controllers/japa_goals_controller.dart';
import '../../features/hindu_japa/presentation/controllers/japa_stats_controller.dart';
import '../../features/hindu_scriptures/presentation/controllers/hindu_scriptures_home_controller.dart';
import '../../features/hindu_scriptures/presentation/controllers/scripture_bookmarks_controller.dart';
import '../../features/hindu_stories/presentation/controllers/story_favorites_controller.dart';
import '../../features/hindu_stotras/presentation/controllers/stotra_favorites_controller.dart';
import '../../features/hindu_temples/presentation/controllers/temple_favorites_controller.dart';
import '../../features/names/presentation/controllers/name_favorites_controller.dart';
import '../../features/quran/presentation/controllers/bookmarks_controller.dart';
import '../../features/quran/presentation/controllers/quran_home_controller.dart';
import '../../features/today/presentation/controllers/today_dashboard_controller.dart';
import '../../shared/habit/local_event_queue.dart';

part 'local_data_purge.g.dart';

/// Erases the user-scoped data this device holds, from disk and from memory.
///
/// Run whenever a session ends — sign-out and account deletion both, through
/// the one sequence in `end_session.dart`. The goal is that the next person
/// to sign in on this handset sees what a fresh install would show them.
///
/// A good deal of what this app shows a user never reaches the server: the
/// reflection journal and mood history are explicitly device-only (there is
/// no journal endpoint), every favourites and bookmarks list is a
/// SharedPreferences blob, and the streak is fed by an on-device sqflite
/// queue. Leaving any of it behind hands it to whoever signs in next.
///
/// Deliberately *not* cleared: selected faith, theme mode, Arabic script,
/// calculation method, onboarding-done and the notification-permission flag.
/// Those are device preferences rather than anything the user authored, and
/// clearing `onboarding_done` would additionally bounce the next person on
/// this phone back through onboarding for no reason. Static content caches
/// (the surah index, the dhikr and japa dictionaries, the juz chooser) are
/// left alone for the same reason inverted: they are nobody's data, and
/// dropping them would make the next screen refetch for nothing.
///
/// ## Two phases, and the order between them is not ours to choose
///
/// [eraseDisk] and [dropCachedUserData] are separate because the sign-out
/// that sits between them is a network call, and a network call spans
/// frames. Every provider [dropCachedUserData] names is `keepAlive`, so
/// invalidating one while a screen still watches it schedules a *rebuild* —
/// and a rebuild that happens while the previous user's token is still in
/// secure storage refetches their data and caches it again. So: erase the
/// disk, end the session, and only then drop what is held in memory, by
/// which point there is no token left to refetch with and the router has
/// taken the screens that were watching off the stack. `end_session.dart`
/// owns that ordering; nothing else should call these two directly.
class LocalDataPurge {
  const LocalDataPurge(this._ref, this._queue);

  /// Every SharedPreferences key holding user-authored content.
  ///
  /// Listed explicitly rather than calling `prefs.clear()` so that adding a
  /// device preference tomorrow cannot silently start wiping it — and so the
  /// inverse, a new user-data key that nobody adds here, is a visible
  /// omission in one place.
  static const List<String> userDataKeys = [
    // Reflection
    'feelings.journal.v1',
    // Islam
    'duas.favorites.v1',
    'quran.bookmarks.v1',
    'quran.lastRead.surah',
    'quran.lastRead.verse',
    // The display context the Today screen's continue-reading card reads
    // without a network call. Written beside the pointer, so cleared with
    // it — leaving a name behind for a pointer that is gone would let the
    // next account's empty card inherit the last one's surah.
    'quran.lastRead.surahName',
    'quran.lastRead.verseCount',
    // `NameFavoritesController` keys on `NamesKind.slug`, so this pair has
    // to be spelled out; the test pins them against the enum.
    'names.allah.favorites.v1',
    'names.muhammad.favorites.v1',
    // Hindu
    'stotras.favorites.v1',
    'stories.favorites.v1',
    'temples.favorites.v1',
    'hinduScriptures.bookmarks.v1',
    'hinduScriptures.lastRead.slug',
    'hinduScriptures.lastRead.chapter',
    'hinduScriptures.lastRead.verse',
    'hinduScriptures.lastRead.textName',
    'hinduScriptures.lastRead.chapterVerseCount',
  ];

  final Ref _ref;
  final Future<LocalEventQueue> _queue;

  /// Wipes the user's content from storage: the preference keys above and
  /// every event still queued for upload.
  ///
  /// Best-effort, and intentionally so. On the deletion path this runs
  /// *after* the server has confirmed the account is gone, so there is no
  /// longer an account to abort back to; on the sign-out path a failure
  /// here must not be the thing that keeps a user signed in. Either way it
  /// is logged and swallowed, and the sign-out that follows is
  /// unconditional.
  Future<void> eraseDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait(userDataKeys.map(prefs.remove));
    } on Object catch (e, st) {
      developer.log(
        'Failed to clear local preferences at end of session',
        name: 'session.purge',
        error: e,
        stackTrace: st,
      );
    }
    try {
      await (await _queue).deleteAll();
    } on Object catch (e, st) {
      developer.log(
        'Failed to clear the activity queue at end of session',
        name: 'session.purge',
        error: e,
        stackTrace: st,
      );
    }
    // The queue is deliberately emptied on sign-out too, not only on
    // deletion. Its rows carry no user id: `ActivityFlusher` would upload
    // whatever is in it under whichever credentials are current, so one
    // user's unflushed reads would land on the next user's account. The
    // dedupe key has the smaller version of the same problem — it is a
    // v5 UUID over `type | key | localDay` with no user component, so A's
    // unflushed verse silently swallows B's same-day read of it via
    // `INSERT OR IGNORE`. Both disappear once the queue ends with the
    // session, which is where `ActivityRecorder`'s class doc says the fix
    // belongs.
  }

  /// Drops the in-memory copies of everything the session owned.
  ///
  /// Every one of these is a `keepAlive` notifier that loads once in
  /// `build()` and then holds its value for the life of the process, so
  /// clearing storage underneath them changes nothing anybody can see.
  /// Caught on-device twice: after deleting an account the previous user's
  /// journal was still listed, and it survived signing in as somebody else
  /// — the entries only disappeared on a cold start.
  ///
  /// That is worse than a stale read. The local-backed controllers persist
  /// by writing their whole in-memory list back, so one save by the next
  /// user would re-write the previous user's entries to disk.
  ///
  /// Invalidating re-runs each `build()` — against the now-empty store for
  /// the local ones, and against the new session for the server-backed
  /// ones. Lazily: Riverpod's scheduler only recomputes an invalidated
  /// provider that still `hasListeners`, and by the time this runs the
  /// router has moved to `/login`, so none of these does. They recompute
  /// when a screen in the new session first reads them.
  ///
  /// Through `ref.container` rather than `ref.invalidate`, and that is not
  /// a style choice. `Ref.invalidate` asserts `_debugAssertCanDependOn`
  /// first, and that assert *reads* the provider — so in a debug build it
  /// **creates** every provider in this list that the session never
  /// happened to open, runs its `build()`, and fires a request per
  /// controller with the tokens already gone. `ProviderContainer
  /// .invalidate` takes the element only if one exists, which is the whole
  /// intent here: forget what was cached, build nothing.
  void dropCachedUserData() {
    final container = _ref.container;
    // Device-only, and mirroring [userDataKeys] — a key cleared there needs
    // its reader dropped here.
    container.invalidate(journalControllerProvider);
    container.invalidate(duaFavoritesControllerProvider);
    container.invalidate(bookmarksControllerProvider);
    container.invalidate(lastReadControllerProvider);
    // The family root, which drops both `NamesKind` instances.
    container.invalidate(nameFavoritesControllerProvider);
    container.invalidate(stotraFavoritesControllerProvider);
    container.invalidate(storyFavoritesControllerProvider);
    container.invalidate(templeFavoritesControllerProvider);
    container.invalidate(scriptureBookmarksControllerProvider);
    container.invalidate(scriptureLastReadControllerProvider);

    // Server data, cached in memory and keyed to the account it was fetched
    // for. Only the `keepAlive` ones are listed: everything else that holds
    // a user's server rows — today's dashboard, prayer and puja logs, japa
    // history — is auto-disposed and dies with the screen the redirect to
    // `/login` tears down.
    container.invalidate(activitySnapshotCacheProvider);
    container.invalidate(dhikrCountersControllerProvider);
    container.invalidate(dhikrGoalsControllerProvider);
    container.invalidate(japaCountersControllerProvider);
    container.invalidate(japaGoalsControllerProvider);
    container.invalidate(japaStatsProvider);
  }
}

@Riverpod(keepAlive: true)
LocalDataPurge localDataPurge(Ref ref) =>
    LocalDataPurge(ref, ref.watch(localEventQueueProvider.future));
