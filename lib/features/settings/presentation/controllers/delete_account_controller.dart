import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../../core/session/end_session.dart';
import '../../../../core/storage/local_data_purge.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
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
/// Once the server confirms, the rest is [endSession] — the same cleanup,
/// in the same order, that signing out runs. It is deliberately not a
/// second copy of that list: deletion grew the thorough version of it while
/// sign-out kept a two-line one, and the gap between them was a
/// cross-account data leak. Whatever either path needs, both now get.
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

    // Read through the providers, not `NotificationService.instance`: the
    // alarms are scheduled against an account that no longer exists, and
    // this is the one step in the sequence that talks to a platform
    // channel.
    await endSession(
      notifications: ref.read(prayerNotificationSinkProvider),
      purge: ref.read(localDataPurgeProvider),
      auth: ref.read(authControllerProvider.notifier),
    );
    // Deliberately no `state = AsyncValue.data(...)` here. The sign-out
    // inside `endSession` flips the auth state the router listens to, which
    // re-runs the boot redirect and tears this screen down — removing this
    // autoDispose provider's only listener. Writing to the notifier after
    // that can land on a disposed one. Leaving it `loading` is also the
    // correct UI for the frame or two that remain: the button stays
    // disabled while the screen is on its way out, where resetting it would
    // re-arm a destructive button that still has DELETE typed into the
    // field beside it.
    return true;
  }
}
