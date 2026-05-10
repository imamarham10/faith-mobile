// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPrefsHash() => r'2aa63216a44b3fa97b9262802ddb76183077bede';

/// Reads + persists the user's prayer-notification preferences.
///
/// Copied from [NotificationPrefs].
@ProviderFor(NotificationPrefs)
final notificationPrefsProvider =
    AsyncNotifierProvider<NotificationPrefs, NotificationPreferences>.internal(
      NotificationPrefs.new,
      name: r'notificationPrefsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationPrefsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationPrefs = AsyncNotifier<NotificationPreferences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
