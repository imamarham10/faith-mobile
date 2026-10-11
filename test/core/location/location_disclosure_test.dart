import 'package:flutter_test/flutter_test.dart';

import 'package:faith_mobile/core/location/location_disclosure.dart';
import 'package:faith_mobile/core/notifications/permission_gate.dart';

/// Google Play's Location Permissions policy requires a prominent in-app
/// disclosure *before* the runtime permission request. These tests encode
/// that ordering so a future refactor cannot quietly put the system dialog
/// back in front of the explanation.
void main() {
  group('nextLocationAccessStep', () {
    test('asks for nothing when permission is already held', () {
      expect(
        nextLocationAccessStep(hasPermission: true, disclosureAccepted: false),
        LocationAccessStep.ready,
      );
    });

    test('a held permission wins even once the disclosure was accepted', () {
      expect(
        nextLocationAccessStep(hasPermission: true, disclosureAccepted: true),
        LocationAccessStep.ready,
      );
    });

    test('shows the disclosure before any request on first ask', () {
      expect(
        nextLocationAccessStep(hasPermission: false, disclosureAccepted: false),
        LocationAccessStep.showDisclosure,
      );
    });

    test('never routes a first-time user straight to the system dialog', () {
      // The policy violation in one assertion.
      expect(
        nextLocationAccessStep(hasPermission: false, disclosureAccepted: false),
        isNot(LocationAccessStep.requestPermission),
      );
    });

    test('does not repeat the disclosure once it has been accepted', () {
      expect(
        nextLocationAccessStep(hasPermission: false, disclosureAccepted: true),
        LocationAccessStep.requestPermission,
      );
    });
  });

  group('LocationDisclosure', () {
    test('starts un-accepted on a fresh install', () async {
      final disclosure = LocationDisclosure(InMemoryGateStore());

      expect(await disclosure.wasAccepted, isFalse);
    });

    test('remembers acceptance across reads', () async {
      final store = InMemoryGateStore();
      final disclosure = LocationDisclosure(store);

      await disclosure.accept();

      expect(await disclosure.wasAccepted, isTrue);
      // Survives a new instance, as it must across app launches.
      expect(await LocationDisclosure(store).wasAccepted, isTrue);
    });

    test('a decline is not recorded, so the next ask explains itself again',
        () async {
      final store = InMemoryGateStore();
      final disclosure = LocationDisclosure(store);

      // Declining is simply "never called accept()".
      expect(await disclosure.wasAccepted, isFalse);
      expect(
        nextLocationAccessStep(
          hasPermission: false,
          disclosureAccepted: await disclosure.wasAccepted,
        ),
        LocationAccessStep.showDisclosure,
      );
    });

    test('uses a key distinct from the notification gate', () {
      expect(LocationDisclosure.acceptedKey, isNot(PermissionGate.hasAskedKey));
    });
  });
}
