import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../notifications/permission_gate.dart' show GateStore, SharedPrefsGateStore;

part 'location_disclosure.g.dart';

/// What the caller must do before the device can be located.
enum LocationAccessStep {
  /// Permission is already held. Go straight to the fix — no UI, no prompt.
  ready,

  /// Permission is not held and the user has never been shown why the app
  /// wants it. Google Play requires an in-app disclosure *before* the
  /// system dialog appears.
  showDisclosure,

  /// The disclosure has been shown and accepted in a previous session, but
  /// permission is not currently held (revoked in settings, or denied at the
  /// time). Re-request without repeating the disclosure.
  requestPermission,
}

/// Decides what has to happen before [LocationService.requestPermission].
///
/// Pure, so the Play requirement — *no permission request may be issued
/// before the disclosure has been accepted* — is assertable in a unit test
/// rather than only observable by watching a real device.
LocationAccessStep nextLocationAccessStep({
  required bool hasPermission,
  required bool disclosureAccepted,
}) {
  if (hasPermission) return LocationAccessStep.ready;
  return disclosureAccepted
      ? LocationAccessStep.requestPermission
      : LocationAccessStep.showDisclosure;
}

/// Remembers whether the prominent location disclosure has been accepted.
///
/// Google Play's Location Permissions policy requires an in-app disclosure
/// that names the data collected and the feature it powers, shown *before*
/// the runtime permission request, and separate from any privacy-policy
/// link. This is the one place that fact is enforced: every location request
/// in the app routes through [requestLocationAccess], which consults this.
///
/// Only acceptance is stored. A decline is deliberately not remembered — the
/// user is simply not prompted until they tap a location CTA again, and when
/// they do, they see the disclosure again rather than an unexplained system
/// dialog. Storing "declined" would only let the app skip an explanation the
/// user has never agreed to.
class LocationDisclosure {
  const LocationDisclosure(this._store);

  static const String acceptedKey = 'location.disclosure.accepted';

  final GateStore _store;

  Future<bool> get wasAccepted async =>
      await _store.readBool(acceptedKey) ?? false;

  Future<void> accept() => _store.writeBool(acceptedKey, true);
}

@Riverpod(keepAlive: true)
LocationDisclosure locationDisclosure(Ref ref) =>
    const LocationDisclosure(SharedPrefsGateStore());
