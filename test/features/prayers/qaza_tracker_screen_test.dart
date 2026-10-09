import 'package:dio/dio.dart';
import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/prayers/data/dtos/prayer_stats.dart';
import 'package:faith_mobile/features/prayers/data/prayers_repository.dart';
import 'package:faith_mobile/features/prayers/presentation/screens/qaza_tracker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A repository whose qada calls move an in-memory tally, or throw.
///
/// Subclasses the real [PrayersRepository] rather than faking the HTTP
/// layer, because what these tests are about is the screen's behaviour
/// around a *successful* and a *failing* adjustment — the wire format is
/// already pinned in `prayers_repository_qada_test.dart`.
class _FakeRepo extends PrayersRepository {
  _FakeRepo({required int fajr, this.failWith}) : _fajr = fajr, super(Dio());

  int _fajr;
  final Object? failWith;

  final List<String> calls = <String>[];

  PrayerStats get _stats => PrayerStats(
    totalQaza: _fajr,
    fajrQaza: _fajr,
    dhuhrQaza: 0,
    asrQaza: 0,
    maghribQaza: 0,
    ishaQaza: 0,
  );

  @override
  Future<PrayerStats> getStats() async => _stats;

  @override
  Future<PrayerStats> incrementQada({
    required String prayerName,
    int by = 1,
  }) async {
    calls.add('increment:$prayerName');
    if (failWith != null) throw failWith!;
    if (prayerName == 'fajr') _fajr += by;
    return _stats;
  }

  @override
  Future<PrayerStats> decrementQada({
    required String prayerName,
    int by = 1,
  }) async {
    calls.add('decrement:$prayerName');
    if (failWith != null) throw failWith!;
    // Mirrors the server's `Math.max(0, count + by)`.
    if (prayerName == 'fajr') _fajr = (_fajr - by) < 0 ? 0 : _fajr - by;
    return _stats;
  }
}

Future<void> _pump(WidgetTester tester, _FakeRepo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [prayersRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        theme: AppTheme.light(FaithId.islam),
        home: const QazaTrackerScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

/// The minus button on the Fajr row — the first `Icons.remove` built.
Finder get _fajrMinus => find.byIcon(Icons.remove).first;

/// The plus button on the Fajr row.
Finder get _fajrPlus => find.byIcon(Icons.add).first;

/// How many rows the viewport actually built.
int get _plusCount => find.byIcon(Icons.add).evaluate().length;

void main() {
  group('QazaTrackerScreen decrement', () {
    testWidgets('offers a minus control once a count is above zero', (
      tester,
    ) async {
      await _pump(tester, _FakeRepo(fajr: 1));

      // One minus per plus. Counted against the plus rather than against a
      // literal 5: the list culls rows below the fold, so a hard-coded
      // count would be a test of the viewport height.
      expect(find.byIcon(Icons.remove), findsNWidgets(_plusCount));
      // The label is both the tooltip and the semantics label, so this is
      // the same string a screen reader announces.
      expect(find.byTooltip('Remove one Fajr qaḍāʾ'), findsOneWidget);
      expect(find.byTooltip('No Fajr qaḍāʾ to remove'), findsNothing);
    });

    testWidgets('decrements the tally and adopts the server number', (
      tester,
    ) async {
      final repo = _FakeRepo(fajr: 1);
      await _pump(tester, repo);

      expect(find.text('1'), findsWidgets);

      await tester.tap(_fajrMinus);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(repo.calls, ['decrement:fajr']);
      // Both the per-prayer chip and the total header are now zero, and the
      // "caught up" copy has taken over.
      expect(
        find.text('You\'re caught up. May Allah keep it that way.'),
        findsOneWidget,
      );
    });

    testWidgets('disables the minus at zero so no no-op request is sent', (
      tester,
    ) async {
      final repo = _FakeRepo(fajr: 0);
      await _pump(tester, repo);

      // Still rendered — the row must not reflow as counts cross zero —
      // but inert, and it says so rather than silently doing nothing.
      expect(find.byIcon(Icons.remove), findsNWidgets(_plusCount));
      expect(find.byTooltip('No Fajr qaḍāʾ to remove'), findsOneWidget);

      await tester.tap(_fajrMinus);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        repo.calls,
        isEmpty,
        reason:
            'the client half of the below-zero guard: the server clamps '
            'anyway, so this only stops a guaranteed no-op round-trip',
      );
    });

    testWidgets('a failed adjustment keeps the counts on screen', (
      tester,
    ) async {
      // The regression this guards: the controller used to park the failure
      // in `state` via `AsyncValue.guard`, which both swallowed the throw
      // (so no snackbar) and flipped `when(error:)` to the full-screen retry
      // view — wiping every count the user was looking at. For an *undo*
      // that is the worst possible outcome.
      final repo = _FakeRepo(
        fajr: 2,
        failWith: const ApiException(message: 'nope'),
      );
      await _pump(tester, repo);

      await tester.tap(_fajrMinus);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(repo.calls, ['decrement:fajr']);
      expect(
        find.text('Couldn\'t load qaḍāʾ stats'),
        findsNothing,
        reason: 'one failed tap must not replace the list with the error view',
      );
      expect(find.textContaining('Couldn\'t update'), findsOneWidget);
      // The tally the user was looking at is still the tally on screen.
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('a failed increment behaves the same way', (tester) async {
      final repo = _FakeRepo(
        fajr: 0,
        failWith: const ApiException(message: 'nope'),
      );
      await _pump(tester, repo);

      await tester.tap(_fajrPlus);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(repo.calls, ['increment:fajr']);
      expect(find.text('Couldn\'t load qaḍāʾ stats'), findsNothing);
      expect(find.textContaining('Couldn\'t update'), findsOneWidget);
    });
  });
}
