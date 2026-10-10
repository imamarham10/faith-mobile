import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/habit/local_event_queue.dart';

part 'local_data_purge.g.dart';

/// Erases the user-owned data this device holds locally.
///
/// Account deletion is only honest if it covers the device too. A good deal
/// of what this app shows a user never reaches the server: the reflection
/// journal and mood history are explicitly device-only (there is no journal
/// endpoint), every favourites and bookmarks list is a SharedPreferences
/// blob, and the streak is computed from an on-device sqflite queue. Deleting
/// the server rows alone would leave all of it sitting on the phone for
/// whoever signs in next.
///
/// Deliberately *not* cleared: selected faith, theme mode, Arabic script,
/// calculation method, onboarding-done and the notification-permission flag.
/// Those are device preferences rather than anything the user authored, and
/// clearing `onboarding_done` would additionally bounce the next person on
/// this phone back through onboarding for no reason.
class LocalDataPurge {
  const LocalDataPurge(this._queue);

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
    // Hindu
    'stotras.favorites.v1',
    'stories.favorites.v1',
    'temples.favorites.v1',
    'hinduScriptures.bookmarks.v1',
    'hinduScriptures.lastRead.slug',
    'hinduScriptures.lastRead.chapter',
    'hinduScriptures.lastRead.verse',
  ];

  final Future<LocalEventQueue> _queue;

  /// Best-effort, and intentionally so: this runs *after* the server has
  /// confirmed the account is gone, so there is no longer an account to
  /// abort back to. A failure here must not surface as "deletion failed"
  /// when the deletion plainly succeeded — it is logged and swallowed.
  Future<void> run() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait(userDataKeys.map(prefs.remove));
    } on Object catch (e, st) {
      developer.log(
        'Failed to clear local preferences on account deletion',
        name: 'account.purge',
        error: e,
        stackTrace: st,
      );
    }
    try {
      await (await _queue).deleteAll();
    } on Object catch (e, st) {
      developer.log(
        'Failed to clear the activity queue on account deletion',
        name: 'account.purge',
        error: e,
        stackTrace: st,
      );
    }
  }
}

@Riverpod(keepAlive: true)
LocalDataPurge localDataPurge(Ref ref) =>
    LocalDataPurge(ref.watch(localEventQueueProvider.future));
