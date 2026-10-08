import 'package:faith_mobile/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots and lands on splash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FaithApp()));
    // Pump one frame; we should at least see the app brand on the splash.
    await tester.pump();
    expect(find.text('Siraat'), findsOneWidget);

    // The router holds the splash for a 1700ms minimum dwell (app_router.dart)
    // and the splash's ambient animations repeat forever, so pumpAndSettle
    // would never settle. Pump past the dwell so its Timer does not outlive
    // the widget tree.
    await tester.pump(const Duration(milliseconds: 2000));
  });
}
