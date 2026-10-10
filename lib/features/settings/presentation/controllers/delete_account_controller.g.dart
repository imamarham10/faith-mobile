// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteAccountControllerHash() =>
    r'87899deb957e3c32addf380a2c8268d3439e6453';

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
///
/// Copied from [DeleteAccountController].
@ProviderFor(DeleteAccountController)
final deleteAccountControllerProvider =
    AutoDisposeNotifierProvider<
      DeleteAccountController,
      AsyncValue<void>
    >.internal(
      DeleteAccountController.new,
      name: r'deleteAccountControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteAccountControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeleteAccountController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
