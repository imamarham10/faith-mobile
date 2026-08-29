import 'dart:ui' show Tristate;

import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
    // The disabled branch returns the bare button without wrapping it in a
    // GestureDetector, so a real, falsifiable assertion is that no
    // GestureDetector is built at all — mirrors PoppyCard's equivalent test.
    await tester.pumpWidget(
      harness(const PoppyButton(label: 'Disabled', onPressed: null)),
    );
    expect(find.byType(GestureDetector), findsNothing);
  });

  testWidgets(
    'exposes button role and enabled state to accessibility services',
    (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        harness(PoppyButton(label: 'Continue', onPressed: () {})),
      );
      final node = tester.getSemantics(find.byType(PoppyButton));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isEnabled, isNot(Tristate.none));
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      expect(node.label, 'Continue');
      handle.dispose();
    },
  );

  testWidgets(
    'exposes disabled state to accessibility services',
    (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        harness(const PoppyButton(label: 'Disabled', onPressed: null)),
      );
      final node = tester.getSemantics(find.byType(PoppyButton));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isEnabled, isNot(Tristate.none));
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      expect(node.label, 'Disabled');
      handle.dispose();
    },
  );

  testWidgets(
    // Regression guard: excludeSemantics: true on the wrapping Semantics
    // node drops the GestureDetector's own tap action along with everything
    // else it would contribute, so the activate action must be declared on
    // the Semantics node itself (onTap:) or screen-reader/switch-access
    // activation silently stops working even though a real touch still
    // fires. This was broken and fixed once already; guard it permanently.
    'tap action survives excludeSemantics: fires onPressed when enabled, '
    'absent from the node when disabled',
    (tester) async {
      final handle = tester.ensureSemantics();

      var pressed = false;
      await tester.pumpWidget(
        harness(
          PoppyButton(label: 'Continue', onPressed: () => pressed = true),
        ),
      );
      final enabledNode = tester.getSemantics(find.byType(PoppyButton));
      expect(
        enabledNode.getSemanticsData().hasAction(SemanticsAction.tap),
        isTrue,
      );
      tester.semantics.tap(find.semantics.byLabel('Continue'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);

      await tester.pumpWidget(
        harness(const PoppyButton(label: 'Disabled', onPressed: null)),
      );
      final disabledNode = tester.getSemantics(find.byType(PoppyButton));
      expect(
        disabledNode.getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse,
      );

      handle.dispose();
    },
  );

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
            const SizedBox(key: siblingKey, width: 10, height: 10),
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
