import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(FaithId.islam),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders child content', (tester) async {
    await tester.pumpWidget(
      harness(const PoppyCard(child: Text('hello'))),
    );
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('calls onTap and shows pressed state on tap-down', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      harness(
        PoppyCard(onTap: () => tapped = true, child: const Text('tap me')),
      ),
    );
    await tester.tap(find.text('tap me'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets(
    'pressing a card does not reflow sibling widgets (paint-only offset)',
    (tester) async {
      const siblingKey = Key('sibling');
      await tester.pumpWidget(
        harness(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PoppyCard(onTap: () {}, child: const Text('press me')),
              const SizedBox(key: siblingKey, height: 20, width: 20),
            ],
          ),
        ),
      );

      final siblingUnpressed = tester.getTopLeft(find.byKey(siblingKey));
      final cardTextUnpressed = tester.getTopLeft(find.text('press me'));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('press me')),
      );
      await tester.pump(); // onTapDown fires -> setState(_pressed = true)

      // Mid-animation: the old margin-based implementation would already be
      // reflowing the sibling downward at this point.
      await tester.pump(const Duration(milliseconds: 50));
      final siblingMidPress = tester.getTopLeft(find.byKey(siblingKey));
      expect(
        siblingMidPress,
        equals(siblingUnpressed),
        reason:
            'sibling moved mid-animation while card was pressed; the press '
            'offset is leaking into layout instead of staying paint-only',
      );

      // Fully settled in the pressed state.
      await tester.pump(const Duration(milliseconds: 100));
      final siblingFullyPressed = tester.getTopLeft(find.byKey(siblingKey));
      expect(
        siblingFullyPressed,
        equals(siblingUnpressed),
        reason:
            'sibling moved once the press animation settled; the press '
            'offset is leaking into layout instead of staying paint-only',
      );

      // The card's own content DOES shift (paint-only) — proves the press
      // effect still happens and this test isn't just passing because the
      // shift was silently dropped.
      final cardTextPressed = tester.getTopLeft(find.text('press me'));
      expect(
        cardTextPressed.dy - cardTextUnpressed.dy,
        closeTo(4.0, 0.01),
        reason:
            'card content should paint-shift down by pressOffset (4) when '
            'pressed; if this is 0 the press animation was lost, not just '
            'made paint-only',
      );

      await gesture.up();
      await tester.pumpAndSettle();
      final siblingReleased = tester.getTopLeft(find.byKey(siblingKey));
      expect(siblingReleased, equals(siblingUnpressed));
    },
  );

  testWidgets(
    'decorative card (onTap: null) does not build a GestureDetector',
    (tester) async {
      await tester.pumpWidget(
        harness(const PoppyCard(child: Text('decorative'))),
      );
      expect(find.byType(GestureDetector), findsNothing);
    },
  );
}
