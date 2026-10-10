import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/feelings/data/dtos/journal_entry.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/journal_controller.dart';
import 'package:faith_mobile/features/feelings/presentation/screens/mood_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [JournalController] resolving synchronously to a fixed entry list.
class _FakeJournal extends JournalController {
  _FakeJournal(this._entries);

  final List<JournalEntry> _entries;

  @override
  Future<List<JournalEntry>> build() async => _entries;
}

JournalEntry _entry(String mood, {int daysAgo = 0}) => JournalEntry(
  id: '$mood-$daysAgo',
  mood: mood,
  note: '',
  createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pump(
    WidgetTester tester,
    List<JournalEntry> entries, {
    FaithId faith = FaithId.islam,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalControllerProvider.overrideWith(() => _FakeJournal(entries)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(faith),
          routerConfig: GoRouter(
            initialLocation: '/history',
            routes: [
              GoRoute(
                path: '/history',
                builder: (_, __) => const MoodHistoryScreen(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  /// Text inside the frequency chart specifically.
  ///
  /// The timeline below it legitimately repeats every logged mood's name, so
  /// an unscoped `find.text` cannot tell "charted" from "listed" — and it is
  /// the chart, not the list, that used to be driven by a hardcoded set. The
  /// chart is the screen's only [Wrap]; each test asserts that first, so if
  /// that ever stops being true these fail loudly instead of silently
  /// widening.
  Finder charted(String text) =>
      find.descendant(of: find.byType(Wrap), matching: find.text(text));

  void expectOneChart(WidgetTester tester) =>
      expect(find.byType(Wrap), findsOneWidget);

  testWidgets('charts only moods that were actually logged', (tester) async {
    await pump(tester, [
      _entry('overwhelmed'),
      _entry('overwhelmed', daysAgo: 1),
      _entry('grateful', daysAgo: 2),
    ]);

    expectOneChart(tester);
    expect(charted('Overwhelmed'), findsOneWidget);
    expect(charted('Grateful'), findsOneWidget);
    // "2" is the Overwhelmed dot's count; "1" is Grateful's.
    expect(charted('2'), findsOneWidget);
    expect(charted('1'), findsOneWidget);
  });

  testWidgets('charts no mood that has never been logged', (tester) async {
    await pump(tester, [_entry('grateful')]);

    // The row used to be driven by a hardcoded nine, so it drew a permanent
    // zero dot for six moods no chooser in the app can even produce.
    for (final absent in const [
      'Anxious',
      'Lonely',
      'Hopeful',
      'Tested',
      'Joyful',
      'Heavy',
      'Searching',
      'Lost',
    ]) {
      expect(charted(absent), findsNothing);
    }
    expect(charted('0'), findsNothing);
  });

  testWidgets('charts Hindu moods for a Hindu user', (tester) async {
    // Same screen, same client-side journal, different faith — it used to
    // plot Islam's hardcoded list here regardless.
    await pump(tester, [
      _entry('lonely'),
      _entry('restless'),
    ], faith: FaithId.hindu);

    expectOneChart(tester);
    expect(charted('Lonely'), findsOneWidget);
    expect(charted('Restless'), findsOneWidget);
  });

  testWidgets('shows the empty state when nothing has been logged', (
    tester,
  ) async {
    await pump(tester, const []);
    expect(find.text('No history yet.'), findsOneWidget);
  });
}
