import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../../core/storage/local_data_purge.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../duas/presentation/controllers/dua_favorites_controller.dart';
import '../../../feelings/presentation/controllers/journal_controller.dart';
import '../../../hindu_scriptures/presentation/controllers/hindu_scriptures_home_controller.dart';
import '../../../hindu_scriptures/presentation/controllers/scripture_bookmarks_controller.dart';
import '../../../hindu_stories/presentation/controllers/story_favorites_controller.dart';
import '../../../hindu_stotras/presentation/controllers/stotra_favorites_controller.dart';
import '../../../hindu_temples/presentation/controllers/temple_favorites_controller.dart';
import '../../../quran/presentation/controllers/bookmarks_controller.dart';
import '../../../quran/presentation/controllers/quran_home_controller.dart';
import '../../data/account_repository.dart';

part 'delete_account_controller.g.dart';

/// Drives the irreversible account deletion.
///
/// The ordering is the whole design. The server call goes first and nothing
/// local is touched until it has returned: the handler deletes the user row
/// last specifically so a partial failure leaves the account intact and the
/// call safely retryable, and that property is only worth anything if the
/// client doesn't pre-emptively sign out or wipe the device. So on any
/// failure this leaves the session exactly as it found it, surfaces the
/// error, and lets the user try again — a half-deleted account that still
/// looks signed in is worse than a clean error.
///
/// Once the server confirms, the rest is cleanup that cannot be abandoned
/// halfway: cancel alarms scheduled against an account that no longer
/// exists, erase the device-only data (journal, bookmarks, activity queue),
/// then drop the tokens. `signOut` goes last because it flips the router's
/// redirect to `/login`, tearing this screen down.
@riverpod
class DeleteAccountController extends _$DeleteAccountController {
  @override
  // The initial state: nothing attempted. `AsyncData` rather than `AsyncValue
  // .loading()` so the UI's "in flight" test is just `state.isLoading`.
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Returns true when the account is gone. Never throws — the error is in
  /// [state] so a widget renders it the same way it renders everything else.
  Future<bool> delete() async {
    if (state.isLoading) return false;
    state = const AsyncValue.loading();
    try {
      await ref.read(accountRepositoryProvider).deleteAccount();
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }

    // Through the provider, not `NotificationService.instance`: the alarms
    // are scheduled against an account that no longer exists, and this is
    // also the one step in the sequence that talks to a platform channel.
    await ref.read(prayerNotificationSinkProvider).cancelAll();
    await ref.read(localDataPurgeProvider).run();
    _dropCachedUserData();
    await ref.read(authControllerProvider.notifier).signOut();
    // Deliberately no `state = AsyncValue.data(...)` here. `signOut` flips
    // the auth state the router listens to, which re-runs the boot redirect
    // and tears this screen down — removing this autoDispose provider's only
    // listener. Writing to the notifier after that can land on a disposed
    // one. Leaving it `loading` is also the correct UI for the frame or two
    // that remain: the button stays disabled while the screen is on its way
    // out, where resetting it would re-arm a destructive button that still
    // has DELETE typed into the field beside it.
    return true;
  }

  /// Drops the in-memory copies of everything [LocalDataPurge] just erased
  /// from disk.
  ///
  /// Every one of these is a `keepAlive` notifier that loads once in
  /// `build()` and then holds its list for the life of the process, so
  /// clearing the SharedPreferences key underneath them changes nothing
  /// anybody can see. Caught on-device: after deleting an account the
  /// previous user's journal was still listed, and it survived signing in as
  /// somebody else — the entries only disappeared on a cold start.
  ///
  /// That is worse than a stale read. These controllers persist by writing
  /// their whole in-memory list back, so one save by the next user would
  /// have re-written the deleted entries to disk and undone the deletion.
  ///
  /// Invalidating re-runs each `build()` against the now-empty store. The
  /// list mirrors [LocalDataPurge.userDataKeys] — a key cleared there needs
  /// its reader dropped here.
  void _dropCachedUserData() {
    // Reflection
    ref.invalidate(journalControllerProvider);
    // Islam
    ref.invalidate(duaFavoritesControllerProvider);
    ref.invalidate(bookmarksControllerProvider);
    ref.invalidate(lastReadControllerProvider);
    // Hindu
    ref.invalidate(stotraFavoritesControllerProvider);
    ref.invalidate(storyFavoritesControllerProvider);
    ref.invalidate(templeFavoritesControllerProvider);
    ref.invalidate(scriptureBookmarksControllerProvider);
    ref.invalidate(scriptureLastReadControllerProvider);
  }
}
