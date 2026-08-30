import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/today/presentation/screens/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_selected_faith.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // TodayScreen pulls in several network/plugin-backed providers on both
  // branches (Islam: prayer times, daily hadith, last-read, server Hijri
  // date; Hindu: panchang-today, puja-times/sandhya countdown) that never
  // resolve in a widget test — they stay in their loading state (shimmers)
  // or fail over to a local/static fallback, and none of that is asserted
  // on here. So — matching the bounded-pump convention already used in
  // faith_selection_screen_test.dart / onboarding_screen_test.dart — every
  // test below uses a fixed-duration `pump` instead of `pumpAndSettle`,
  // which would never settle while those providers stay pending.
  //
  // The leading bare `pump()` matters: `_FakeSelectedFaith.build()` is async,
  // so the very first frame renders with `selectedFaithProvider` still
  // loading (TodayScreen's `?? FaithId.islam` fallback applies), then a
  // microtask later the override resolves and TodayScreen rebuilds into the
  // *other* branch.
  Future<void> pump(WidgetTester tester, FaithId faith) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(faith),
          home: const TodayScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('Islam branch', () {
    testWidgets('shows the Islam greeting and section content', (
      tester,
    ) async {
      await pump(tester, FaithId.islam);

      expect(find.text('As-salāmu ʿalaykum'), findsOneWidget);
      // SectionLabel uppercases its text.
      expect(find.text('VERSE FOR TODAY'), findsOneWidget);
      expect(find.text('HADITH OF THE DAY'), findsOneWidget);
      expect(
        find.text('وَمَن يَتَّقِ ٱللَّهَ يَجْعَل لَّهُۥ مَخْرَجًا'),
        findsOneWidget,
      );

      // "Quick" + the quick-actions row sit further down the scroll view
      // than the default test viewport shows — scroll to reveal them rather
      // than assuming they're already built/painted.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pump();
      expect(find.text('QUICK'), findsOneWidget);
      expect(find.text('How are you feeling?'), findsOneWidget);
    });

    testWidgets('does not show the Hindu placeholder copy', (tester) async {
      await pump(tester, FaithId.islam);

      expect(find.text('Hindu home is coming soon'), findsNothing);
    });

    testWidgets(
      'MoodPrompt opens the mood sheet, and picking a mood chip pops it',
      (tester) async {
        await pump(tester, FaithId.islam);

        // MoodPrompt is now a PoppyCard (was Material+InkWell) — confirm the
        // tap-to-open-sheet behavior survived that conversion, and that the
        // mood chips (also converted to PoppyCard) are themselves tappable.
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -600),
        );
        await tester.pump();
        expect(find.text('How are you feeling?'), findsOneWidget);

        await tester.tap(find.text('How are you feeling?'));
        await tester.pump(); // start the bottom-sheet route transition
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('How are you?'), findsOneWidget);
        expect(find.text('Grateful'), findsOneWidget);

        await tester.tap(find.text('Grateful'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('How are you?'), findsNothing);
      },
    );
  });

  group('Hindu branch', () {
    testWidgets('shows the Hindu greeting and quick actions', (tester) async {
      await pump(tester, FaithId.hindu);

      expect(find.text('Namaste'), findsOneWidget);
      // SectionLabel uppercases its text.
      expect(find.text('QUICK'), findsOneWidget);
      expect(find.text('Japa'), findsOneWidget);
      expect(find.text('Stotras'), findsOneWidget);
      expect(find.text('Temples'), findsOneWidget);
    });

    testWidgets('does not reuse any Islam-specific copy or widgets', (
      tester,
    ) async {
      await pump(tester, FaithId.hindu);

      expect(find.text('As-salāmu ʿalaykum'), findsNothing);
      expect(find.text('VERSE FOR TODAY'), findsNothing);
      expect(find.text('HADITH OF THE DAY'), findsNothing);
      expect(find.text('How are you feeling?'), findsNothing);
    });

    testWidgets('still exposes a way back to Settings', (tester) async {
      await pump(tester, FaithId.hindu);

      expect(find.byTooltip('Settings'), findsOneWidget);
    });
  });
}
