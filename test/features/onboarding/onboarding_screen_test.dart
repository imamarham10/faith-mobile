import 'package:faith_mobile/core/router/routes.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  // PoppyCard/PoppyButton/PoppyIcon read
  // Theme.of(context).extension<FaithThemeExtension>()!, which only exists on
  // themes built via AppTheme.light/dark — a bare MaterialApp.router() would
  // null-check-crash on build. Matches the harness convention already used
  // in faith_selection_screen_test.dart / poppy_button_test.dart / etc.
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: GoRouter(
            initialLocation: Routes.onboarding,
            routes: [
              GoRoute(
                path: Routes.onboarding,
                builder: (_, __) => const OnboardingScreen(),
              ),
              GoRoute(
                path: Routes.faithSelection,
                builder: (_, __) => const Text('FAITH PICKER'),
              ),
            ],
          ),
        ),
      ),
    );
    // The slide-entrance flutter_animate effects (fadeIn/moveY) are one-shot,
    // not repeating, so pumpAndSettle safely resolves — no
    // pumpAndSettle-never-resolves risk like MascotView's idle animation in
    // faith_selection_screen_test.dart (this screen carries no MascotView by
    // design, see the doc comment on OnboardingScreen).
    await tester.pumpAndSettle();
  }

  testWidgets('starts on slide 1 with "Next" as the CTA', (tester) async {
    await pump(tester);
    expect(find.text('Meet Siraat'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Get started'), findsNothing);
  });

  testWidgets(
    'exactly 2 slides: one "Next" tap reaches the final slide, whose CTA '
    'reads "Get started"',
    (tester) async {
      await pump(tester);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Stay gently on track'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      // No third slide, and no leftover "Next" CTA — proves the PageView
      // holds exactly 2 pages via public behavior rather than reaching into
      // PageView internals.
      expect(find.text('Next'), findsNothing);
      // The permission-ask action lives only on this slide — its presence
      // is the slide's whole reason to exist, so a regression that dropped
      // it silently would otherwise slip past this smoke test.
      expect(find.text('Turn on reminders'), findsOneWidget);
    },
  );

  testWidgets(
    'final slide\'s "Get started" CTA navigates to /onboarding/faith',
    (tester) async {
      await pump(tester);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get started'));
      // Flush go_router's navigation + route transition.
      await tester.pumpAndSettle();

      expect(find.text('FAITH PICKER'), findsOneWidget);
    },
  );
}
