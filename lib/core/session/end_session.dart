import 'dart:developer' as developer;

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../notifications/notification_service.dart';
import '../storage/local_data_purge.dart';

/// Ends the current session and leaves the device as a fresh install would.
///
/// The one sequence behind both sign-out and account deletion. They used to
/// be different code with different coverage, and the cost of that showed
/// up exactly where you would expect: deletion invalidated nine providers
/// alongside twelve storage keys, sign-out invalidated none of them, and a
/// user who signed out and handed the phone to somebody else left their
/// journal on screen — re-persisted in full by the next person's first
/// save. One list, one order, two call sites.
///
/// ## The order is the design
///
///  1. **Cancel the alarms.** They are scheduled against this user's prayer
///     times and must not fire into the next session.
///  2. **Erase the disk.** Before the session ends, so that any controller
///     that does rebuild — and on the sign-out path the Today branch is
///     still mounted under the pushed settings route — reads an empty
///     store rather than the outgoing user's.
///  3. **Sign out.** Clears the tokens and flips the state the router
///     redirects on.
///  4. **Drop the in-memory copies.** Last, deliberately: these are
///     `keepAlive` providers, so invalidating one that a live screen is
///     watching schedules a rebuild, and a rebuild while the old token is
///     still in secure storage refetches the outgoing user's server data
///     and caches it again. Step 3 is a network call and spans frames, so
///     "last" is the only safe place for it. By here the redirect has taken
///     those screens off the stack, so nothing is listening and nothing
///     refetches until a screen in the new session asks.
///
/// Every step is wrapped so a failure in it cannot skip the ones after.
/// Half-wiped and still signed in as the previous user is the worst state
/// this flow can land in, so the sign-out is reached from a `finally` and
/// [AuthController.signOut] itself survives a server that will not answer.
Future<void> endSession({
  required PrayerNotificationSink notifications,
  required LocalDataPurge purge,
  required AuthController auth,
}) async {
  try {
    await notifications.cancelAll();
  } on Object catch (e, st) {
    // A platform channel that will not answer is not a reason to keep the
    // user signed in; the worst case is a reminder that fires once.
    developer.log(
      'Failed to cancel scheduled notifications at end of session',
      name: 'session.end',
      error: e,
      stackTrace: st,
    );
  }
  try {
    await purge.eraseDisk();
  } finally {
    try {
      await auth.signOut();
    } finally {
      purge.dropCachedUserData();
    }
  }
}
