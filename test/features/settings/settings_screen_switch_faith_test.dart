import 'package:faith_mobile/core/router/routes.dart';
import 'package:faith_mobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // SettingsScreen's watched providers (theme mode, calc method, notification
  // prefs, Arabic script) are all backed by shared_preferences and fall back
  // to sane defaults while loading (see the `.valueOrNull ?? default`
  // pattern in build()), so a bare MaterialApp.router() harness with mocked
  // prefs is enough — no provider overrides needed. Matches the harness
  // convention used in faith_selection_screen_test.dart.
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/settings',
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, __) => const SettingsScreen(),
              ),
              GoRoute(
                path: Routes.switchFaith,
                builder: (_, __) => const Text('PICKER'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows a "Switch faith" tile', (tester) async {
    await pump(tester);
    // The tile sits near the bottom of a long ListView; the default test
    // viewport doesn't render it until scrolled into the cache extent.
    await tester.scrollUntilVisible(
      find.text('Switch faith'),
      500.0,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Switch faith'), findsOneWidget);
  });

  testWidgets('tapping "Switch faith" pushes Routes.switchFaith', (
    tester,
  ) async {
    await pump(tester);

    await tester.scrollUntilVisible(
      find.text('Switch faith'),
      500.0,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Switch faith'));
    await tester.pumpAndSettle();

    expect(find.text('PICKER'), findsOneWidget);
    // Settings' own AppBar title disappears once we've navigated away.
    expect(find.text('Settings'), findsNothing);

    // Prove this was a push (not a go/replace): the standalone faith picker
    // finishes by calling context.pop(), which only has somewhere to land
    // if SettingsScreen is still underneath it in the stack. Pop from the
    // picker's own context and confirm we land back on Settings rather than
    // an empty/errored navigator.
    final pickerContext = tester.element(find.text('PICKER'));
    GoRouter.of(pickerContext).pop();
    await tester.pumpAndSettle();

    expect(find.text('PICKER'), findsNothing);
    expect(find.text('Settings'), findsOneWidget);
  });
}
