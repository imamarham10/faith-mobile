import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/fake_selected_faith.dart';

void main() {
  // A minimal 5-branch StatefulShellRoute, mirroring the real app_router's
  // shape (today/quran-or-scripture/hadiths-or-stories/practice/reflect),
  // but with trivial placeholder screens per branch so the test exercises
  // real navigation-bar wiring without pulling in the whole app.
  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/today',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, __, shell) => AppShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/today',
                  builder: (_, __) => const Text('TODAY_SCREEN'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/quran',
                  builder: (_, __) => const Text('QURAN_SCREEN'),
                  routes: [
                    GoRoute(
                      path: 'surah/:id',
                      builder: (_, state) =>
                          Text('SURAH_${state.pathParameters['id']}'),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/hadiths',
                  builder: (_, __) => const Text('HADITHS_SCREEN'),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, state) =>
                          Text('HADITH_DETAIL_${state.pathParameters['id']}'),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/practice',
                  builder: (_, __) => const Text('PRACTICE_SCREEN'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/reflect',
                  builder: (_, __) => const Text('REFLECT_SCREEN'),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const Scaffold(body: Text('SETTINGS_SCREEN')),
        ),
      ],
    );
  }

  Future<void> pump(WidgetTester tester, FaithId faith) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
        ],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Pumps the shell with a faith that can be flipped mid-test, returning
  /// both handles so a test can drive navigation and a faith switch.
  Future<(GoRouter, MutableFakeSelectedFaith)> pumpMutable(
    WidgetTester tester,
    FaithId faith,
  ) async {
    final router = buildRouter();
    final notifier = MutableFakeSelectedFaith(faith);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [selectedFaithProvider.overrideWith(() => notifier)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return (router, notifier);
  }

  testWidgets('shows Quran/Hadiths labels when faith is islam', (tester) async {
    await pump(tester, FaithId.islam);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Quran'), findsOneWidget);
    expect(find.text('Hadiths'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Reflect'), findsOneWidget);

    expect(find.text('Scripture'), findsNothing);
    expect(find.text('Stories'), findsNothing);
  });

  testWidgets('shows Scripture/Stories labels when faith is hindu', (
    tester,
  ) async {
    await pump(tester, FaithId.hindu);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Scripture'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Reflect'), findsOneWidget);

    expect(find.text('Quran'), findsNothing);
    expect(find.text('Hadiths'), findsNothing);
  });

  testWidgets('tapping a destination switches the visible branch content', (
    tester,
  ) async {
    await pump(tester, FaithId.islam);

    expect(find.text('TODAY_SCREEN'), findsOneWidget);

    await tester.tap(find.text('Quran'));
    await tester.pumpAndSettle();

    expect(find.text('QURAN_SCREEN'), findsOneWidget);
  });

  // Regression: StatefulShellRoute.indexedStack keeps each branch's
  // navigation stack alive independently, so a branch parked on a pushed
  // route kept showing the previous faith's screen after a faith switch.

  testWidgets(
    'a background branch holding a pushed route is reset on faith change',
    (tester) async {
      final (router, faith) = await pumpMutable(tester, FaithId.islam);

      // Park branches 1 and 2 on pushed detail routes, then leave both in
      // the background by switching to branch 0. Two of them, because a
      // reset that only reaches the last-visited branch would still ship
      // the bug.
      await tester.tap(find.text('Quran'));
      await tester.pumpAndSettle();
      router.push('/quran/surah/18');
      await tester.pumpAndSettle();
      expect(find.text('SURAH_18'), findsOneWidget);

      await tester.tap(find.text('Hadiths'));
      await tester.pumpAndSettle();
      router.push('/hadiths/4122');
      await tester.pumpAndSettle();
      expect(find.text('HADITH_DETAIL_4122'), findsOneWidget);

      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();
      expect(find.text('TODAY_SCREEN'), findsOneWidget);

      await faith.set(FaithId.hindu);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Stories'));
      await tester.pumpAndSettle();
      expect(find.text('HADITH_DETAIL_4122'), findsNothing);
      expect(find.text('HADITHS_SCREEN'), findsOneWidget);

      await tester.tap(find.text('Scripture'));
      await tester.pumpAndSettle();
      expect(find.text('SURAH_18'), findsNothing);
      expect(find.text('QURAN_SCREEN'), findsOneWidget);
    },
  );

  testWidgets(
    'the visible branch is reset once the faith picker stack is popped',
    (tester) async {
      final (router, faith) = await pumpMutable(tester, FaithId.islam);

      await tester.tap(find.text('Hadiths'));
      await tester.pumpAndSettle();
      router.push('/hadiths/4122');
      await tester.pumpAndSettle();
      expect(find.text('HADITH_DETAIL_4122'), findsOneWidget);

      // Settings stacks above the shell; the faith flips while it covers
      // the tabs, mirroring Settings -> "Switch faith" -> Continue.
      router.push('/settings');
      await tester.pumpAndSettle();
      await faith.set(FaithId.hindu);
      await tester.pumpAndSettle();

      // The reset must not fight the pop back to Settings.
      expect(find.text('SETTINGS_SCREEN'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();

      expect(find.text('HADITH_DETAIL_4122'), findsNothing);
      expect(find.text('HADITHS_SCREEN'), findsOneWidget);
    },
  );

  testWidgets('a deep link into a stale branch survives the pending reset', (
    tester,
  ) async {
    final (router, faith) = await pumpMutable(tester, FaithId.islam);

    await tester.tap(find.text('Hadiths'));
    await tester.pumpAndSettle();
    router.push('/hadiths/4122');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    await faith.set(FaithId.hindu);
    await tester.pumpAndSettle();

    // Something outside the shell (a notification tap, a deep link)
    // routes into a branch that is still marked stale. That navigation
    // builds a fresh stack, so the pending reset must stand down rather
    // than bounce the user to the branch root.
    router.go('/quran/surah/18');
    await tester.pumpAndSettle();

    expect(find.text('SURAH_18'), findsOneWidget);
  });

  testWidgets('an unchanged faith leaves a pushed route alone', (tester) async {
    final (router, faith) = await pumpMutable(tester, FaithId.islam);

    await tester.tap(find.text('Hadiths'));
    await tester.pumpAndSettle();
    router.push('/hadiths/4122');
    await tester.pumpAndSettle();

    // Re-selecting the same faith is a no-op, as is any unrelated rebuild.
    await faith.set(FaithId.islam);
    await tester.pumpAndSettle();

    expect(find.text('HADITH_DETAIL_4122'), findsOneWidget);
  });
}
