import 'package:faith_mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:faith_mobile/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots and lands on splash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FaithApp()));
    // Pump one frame; we should at least see the app brand on the splash.
    await tester.pump();
    expect(find.text('Siraat'), findsOneWidget);

    // The router holds the splash for [kSplashDwell] (app_router.dart) and
    // the splash's ambient animations repeat forever, so pumpAndSettle
    // would never settle. Pump past the dwell so its Timer does not outlive
    // the widget tree. Read from the constant rather than restated here —
    // a literal would have to be edited in lockstep with the choreography,
    // and silently hangs the suite when it isn't.
    await tester.pump(kSplashDwell + const Duration(milliseconds: 300));
  });
}
