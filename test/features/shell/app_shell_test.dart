import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Fakes [SelectedFaith] to resolve synchronously to a fixed faith, so the
/// shell's nav destinations render deterministically without touching
/// shared_preferences.
class _FakeSelectedFaith extends SelectedFaith {
  _FakeSelectedFaith(this._faith);

  final FaithId _faith;

  @override
  Future<FaithId?> build() async => _faith;
}

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
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/hadiths',
                  builder: (_, __) => const Text('HADITHS_SCREEN'),
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
      ],
    );
  }

  Future<void> pump(WidgetTester tester, FaithId faith) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => _FakeSelectedFaith(faith)),
        ],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows Quran/Hadiths labels when faith is islam', (
    tester,
  ) async {
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
}
