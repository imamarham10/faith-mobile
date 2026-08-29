import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/onboarding/presentation/screens/faith_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // PoppyCard/PoppyButton read Theme.of(context).extension<FaithThemeExtension>()!,
  // which only exists on themes built via AppTheme.light/dark — a bare
  // MaterialApp.router() (as sketched in the plan) would null-check-crash on
  // build. Matches the harness convention already used in
  // poppy_button_test.dart / poppy_card_test.dart / mascot_view_test.dart.
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: GoRouter(
            initialLocation: '/onboarding/faith',
            routes: [
              GoRoute(
                path: '/onboarding/faith',
                builder: (_, __) => const FaithSelectionScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (_, __) => const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
    // MascotView's idle state (both cards start unselected/idle) repeats its
    // scale animation forever by design, so pumpAndSettle can never resolve
    // here — it would spin until it times out. A single bounded pump flushes
    // the timer flutter_animate schedules on first build, matching the
    // pattern mascot_view_test.dart already uses (pump(fixed duration)
    // instead of pumpAndSettle).
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('shows both Islam and Hindu as tappable (no "Soon" badge)', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Islam'), findsOneWidget);
    expect(find.text('Hindu'), findsOneWidget);
    expect(find.text('Soon'), findsNothing);
  });

  testWidgets('tapping Hindu then Continue persists SelectedFaith.hindu', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: GoRouter(
            initialLocation: '/onboarding/faith',
            routes: [
              GoRoute(
                path: '/onboarding/faith',
                builder: (_, __) => const FaithSelectionScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (_, __) => const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );

    // MascotView's idle animation repeats forever (see comment on `pump`
    // above), so pumpAndSettle would spin until it times out — bounded
    // pumps are used instead everywhere in this test.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Hindu'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Continue'));
    // Flush the async set()/markDone() chain plus the go_router navigation
    // rebuild it triggers.
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(container.read(selectedFaithProvider).valueOrNull, FaithId.hindu);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
