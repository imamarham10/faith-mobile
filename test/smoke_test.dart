import 'package:faith_mobile/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots and lands on splash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FaithApp()));
    // Pump one frame; we should at least see the app brand on the splash.
    await tester.pump();
    expect(find.text('Faith'), findsOneWidget);
  });
}
