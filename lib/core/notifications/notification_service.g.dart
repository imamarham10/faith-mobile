// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prayerNotificationSinkHash() =>
    r'2f517a32b9a6f255940ed1f946f8197ef1ba08f0';

/// See also [prayerNotificationSink].
@ProviderFor(prayerNotificationSink)
final prayerNotificationSinkProvider =
    Provider<PrayerNotificationSink>.internal(
      prayerNotificationSink,
      name: r'prayerNotificationSinkProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$prayerNotificationSinkHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PrayerNotificationSinkRef = ProviderRef<PrayerNotificationSink>;
String _$exactAlarmsAllowedHash() =>
    r'af7b7fc6ecf005888ba64d6b06fceb8dd19f9505';

/// Whether the OS currently lets the app set exact alarms.
///
/// Auto-disposing and deliberately uncached across screens: the user can
/// flip this in system settings at any moment, so the Settings screen reads
/// it fresh and invalidates it after sending them there.
///
/// Copied from [exactAlarmsAllowed].
@ProviderFor(exactAlarmsAllowed)
final exactAlarmsAllowedProvider = AutoDisposeFutureProvider<bool>.internal(
  exactAlarmsAllowed,
  name: r'exactAlarmsAllowedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exactAlarmsAllowedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExactAlarmsAllowedRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
