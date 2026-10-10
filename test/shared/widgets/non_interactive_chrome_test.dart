import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faith_mobile/core/art/artwork.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/shared/widgets/colophon.dart';
import 'package:faith_mobile/shared/widgets/page_masthead.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';

/// Guards the one rule the Practice tab's dead-click reports came down to:
///
/// > What you can press sits *on* the page. What you can only read *is* the
/// > page.
///
/// Both of these widgets replaced a [PoppyCard] that carried no action. The
/// first attempt at a fix only removed the card's press shadow and left its
/// fill, outline, corner and anatomy in place — which users went on tapping,
/// because a card in this design system *is* a button. So the assertion that
/// matters is not "has no shadow" but **"is not a card at all"**.
void main() {
  Widget host(Widget child, {FaithId faith = FaithId.islam}) => MaterialApp(
    theme: AppTheme.light(faith),
    home: Scaffold(body: child),
  );

  group('PageMasthead', () {
    testWidgets('is not built from a card', (tester) async {
      await tester.pumpWidget(
        host(
          const PageMasthead(
            title: 'Practice',
            subtitle: 'Tend your practice.',
            slot: ArtSlot.practiceHero,
          ),
        ),
      );

      expect(
        find.byType(PoppyCard),
        findsNothing,
        reason: 'a masthead in a card reads as pressable — reported twice',
      );
    });

    testWidgets('offers nothing to tap', (tester) async {
      await tester.pumpWidget(
        host(
          const PageMasthead(
            title: 'Practice',
            subtitle: 'Tend your practice.',
            slot: ArtSlot.practiceHero,
          ),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('still shows its title and subtitle', (tester) async {
      await tester.pumpWidget(
        host(
          const PageMasthead(
            title: 'Practice',
            subtitle: 'Tend your practice.',
            slot: ArtSlot.practiceHero,
          ),
        ),
      );

      expect(find.text('Practice'), findsOneWidget);
      expect(find.text('Tend your practice.'), findsOneWidget);
    });
  });

  group('Colophon', () {
    const subject = Colophon(
      line: 'Little and often.',
      caption: 'A steady practice outlasts a strong one.',
      slot: ArtSlot.practiceHero,
      ornamentAlignment: Alignment.topCenter,
    );

    testWidgets('is not built from a card', (tester) async {
      await tester.pumpWidget(host(subject));

      expect(
        find.byType(PoppyCard),
        findsNothing,
        reason: 'it previously shared a tile\'s exact anatomy at tile width',
      );
    });

    testWidgets('offers nothing to tap', (tester) async {
      await tester.pumpWidget(host(subject));

      expect(find.byType(InkWell), findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('centres its text, unlike every control on these screens', (
      tester,
    ) async {
      await tester.pumpWidget(host(subject));

      final line = tester.widget<Text>(find.text('Little and often.'));
      final caption = tester.widget<Text>(
        find.text('A steady practice outlasts a strong one.'),
      );

      expect(line.textAlign, TextAlign.center);
      expect(caption.textAlign, TextAlign.center);
    });

    testWidgets('keeps the ornament too shallow to read as a tap target', (
      tester,
    ) async {
      await tester.pumpWidget(host(subject));

      // Android's minimum touch target is 48dp. The rule must stay well
      // under it, or it becomes a credible button again.
      final ornament = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(Colophon),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(ornament.height, lessThan(48));
    });
  });
}
