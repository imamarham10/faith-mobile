import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(FaithId.islam),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders label and fires onPressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      harness(
        PoppyButton(label: 'Continue', onPressed: () => pressed = true),
      ),
    );
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });

  testWidgets('disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      harness(const PoppyButton(label: 'Disabled', onPressed: null)),
    );
    var pressed = false;
    await tester.tap(find.text('Disabled'));
    await tester.pumpAndSettle();
    expect(pressed, isFalse);
  });

  testWidgets('pressing the button does not reflow sibling widgets', (
    tester,
  ) async {
    // Regression guard for the margin-based-offset bug found in PoppyCard's
    // review (Task A6) — the button uses the same press-offset visual
    // language and must use a paint-only shift (e.g. Transform), not margin.
    const siblingKey = Key('sibling');
    await tester.pumpWidget(
      harness(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PoppyButton(label: 'Tap', onPressed: () {}),
            SizedBox(key: siblingKey, width: 10, height: 10),
          ],
        ),
      ),
    );
    final before = tester.getTopLeft(find.byKey(siblingKey));
    final gesture = await tester.startGesture(tester.getCenter(find.text('Tap')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final duringPress = tester.getTopLeft(find.byKey(siblingKey));
    await tester.pump(const Duration(milliseconds: 100));
    final settledPress = tester.getTopLeft(find.byKey(siblingKey));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(duringPress, equals(before));
    expect(settledPress, equals(before));
  });
}
