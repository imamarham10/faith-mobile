import 'package:faith_mobile/core/location/request_location_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Google Play requires the prominent disclosure to say *what* is accessed
/// and *why*, before the system dialog, in-app and separately from the
/// privacy policy. These tests pin the substance of that text so an
/// innocent-looking copy edit cannot quietly remove a required claim — and
/// pin that dismissing it is a "no".
void main() {
  Future<bool?> pumpAndTap(WidgetTester tester, String label) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async =>
                result = await showLocationDisclosure(context),
            child: const Text('go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationDisclosureDialog), findsOneWidget);
    if (label.isEmpty) return result;
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('names the features the location is for', (tester) async {
    await pumpAndTap(tester, '');

    expect(find.textContaining('Prayer times'), findsWidgets);
    expect(find.textContaining('Qibla'), findsWidgets);
  });

  testWidgets('discloses that coordinates are sent to the server', (
    tester,
  ) async {
    await pumpAndTap(tester, '');

    // The app really does send lat/lng to `/api/v1/islam/prayers/times`, so
    // the disclosure must not claim the data stays on the device.
    expect(find.textContaining('sent to Siraat'), findsOneWidget);
    expect(find.textContaining('not saved to your account'), findsOneWidget);
  });

  testWidgets('states that collection is foreground-only', (tester) async {
    await pumpAndTap(tester, '');

    expect(find.textContaining('never in the background'), findsOneWidget);
  });

  testWidgets('offers a real way to decline', (tester) async {
    final result = await pumpAndTap(tester, 'Not now');

    expect(result, isFalse);
  });

  testWidgets('continuing consents to the permission request', (tester) async {
    final result = await pumpAndTap(tester, 'Continue');

    expect(result, isTrue);
  });

  testWidgets('a barrier dismissal is not consent', (tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async =>
                result = await showLocationDisclosure(context),
            child: const Text('go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    // Tapping the scrim dismisses the dialog with no result.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
