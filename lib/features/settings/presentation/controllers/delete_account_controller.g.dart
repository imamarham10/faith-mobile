// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteAccountControllerHash() =>
    r'eaacd7a773b7e704c6fc8fd190e0c19e24dcca3f';

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
