import 'dart:async';

import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/juz_repository.dart';
import 'package:faith_mobile/features/quran/presentation/screens/juz_reader_screen.dart';
import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/activity_recorder.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_juz.dart';

/// One recorded act, as the juz reader asked for it.
typedef _Call = ({ActivityType type, int quantity, String? ref, String? key});

/// Stands in for the recorder without a database underneath it.
///
/// Subclasses rather than reimplements, so the screen is exercised against
/// the real type it depends on and a parameter added to [record] cannot
/// quietly stop being passed. The queue it inherits is a future that never
/// completes — [record] is overridden and never reaches it.
class _SpyRecorder extends ActivityRecorder {
  _SpyRecorder({this.throws = false})
    : super(queue: Completer<LocalEventQueue>().future);

  /// Whether [record] fails the way an unreadable queue would.
  final bool throws;

  final calls = <_Call>[];

  @override
  Future<bool> record(
    ActivityType type, {
    int quantity = 1,
    String? sourceRef,
    String? dedupeKey,
  }) async {
    calls.add((
      type: type,
      quantity: quantity,
      ref: sourceRef,
      key: dedupeKey,
    ));
    if (throws) throw StateError('queue is gone');
    return true;
  }
}

/// What the juz reader tells the activity engine, and when.
///
/// The screen it must agree with is the surah reader, which records one
/// `quran_verse` for the verse the reader has come to *rest* on — hung off
/// a 350ms debounce, so a fling past a verse deliberately under-counts.
/// The pager equivalent, asserted here, is that the cursor stayed put.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Settles the reader on whatever verse the cursor is now on.
  ///
  /// Two pumps, and both are load-bearing. A tap does not itself build a
  /// frame, so the first pump is what runs `didUpdateWidget` and *starts*
  /// the dwell countdown; only then does advancing the clock land it.
  /// Collapsing these into one `pump(400ms)` advances the clock before the
  /// timer exists, and the verse is recorded a step late — which reads as
  /// a passing test until the step that should not count is the last one.
  Future<void> dwell(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> pump(
    WidgetTester tester,
    FakeJuz juz,
    _SpyRecorder recorder,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          juzRepositoryProvider.overrideWithValue(FakeJuzRepository(juz: juz)),
          activityRecorderProvider.overrideWithValue(recorder),
        ],
        child: MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: JuzReaderScreen(juzNumber: juz.number),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('the verse the reader settles on is recorded once', (
    tester,
  ) async {
    final recorder = _SpyRecorder();
    await pump(tester, FakeJuz.spanningThreeSurahs(), recorder);
    await dwell(tester);

    // The fixture's first verse is Al-Baqarah 253.
    expect(recorder.calls, hasLength(1));
    expect(recorder.calls.single.type, ActivityType.quranVerse);
    expect(recorder.calls.single.quantity, 1);
    expect(
      recorder.calls.single.ref,
      'quran:2:253',
      reason: 'provenance is the verse, never its index in the juz — '
          'Phase 2 reads sourceRef and the two readers must agree',
    );

    // Sitting on the same verse does not keep counting it.
    await tester.pump(const Duration(seconds: 2));
    expect(recorder.calls, hasLength(1));
  });

  testWidgets('a verse stepped straight past does not count', (tester) async {
    final recorder = _SpyRecorder();
    await pump(tester, FakeJuz.spanningThreeSurahs(), recorder);

    // Mash Next five times inside the dwell window, then stop.
    for (var i = 0; i < 5; i++) {
      await tester.tap(find.text('Next'));
      await tester.pump(const Duration(milliseconds: 60));
    }
    await dwell(tester);

    expect(
      recorder.calls.map((c) => c.ref),
      ['quran:2:258'],
      reason: 'holding Next through a juz records the verse you stop on, '
          'not every verse that flickered past — the surah reader '
          'under-counts a fling for the same reason',
    );
  });

  testWidgets('stepping back over a verse already read does not re-count', (
    tester,
  ) async {
    final recorder = _SpyRecorder();
    await pump(tester, FakeJuz.spanningThreeSurahs(), recorder);
    await dwell(tester);

    await tester.tap(find.text('Next'));
    await dwell(tester);
    await tester.tap(find.text('Back'));
    await dwell(tester);

    expect(recorder.calls.map((c) => c.ref), [
      'quran:2:253',
      'quran:2:254',
    ]);
  });

  testWidgets('a second visit to the same verse derives the same event id', (
    tester,
  ) async {
    // The screen-local "already recorded" set cannot survive this: the
    // reader is torn down and rebuilt, exactly as leaving the juz and
    // coming back does. What survives is the key, which is a function of
    // the verse and the day — so both calls name one event and the queue's
    // UNIQUE(client_event_id) and the server's @@unique([userId,
    // clientEventId]) collapse them. (That collapse is proved against a
    // real queue in activity_recorder_test.dart.)
    final recorder = _SpyRecorder();
    final juz = FakeJuz.spanningThreeSurahs();

    await pump(tester, juz, recorder);
    await dwell(tester);
    await tester.pumpWidget(const SizedBox.shrink());

    await pump(tester, juz, recorder);
    await dwell(tester);

    expect(recorder.calls, hasLength(2));
    final keys = recorder.calls.map((c) => c.key).toSet();
    expect(keys, hasLength(1), reason: 'one verse, one key');
    expect(
      keys.single,
      'quran:2:253',
      reason: 'the surah reader derives this same key for this same verse, '
          'so reading it in both readers on one day is one verse read',
    );
  });

  testWidgets('a recorder that fails leaves the reader working', (
    tester,
  ) async {
    final recorder = _SpyRecorder(throws: true);
    await pump(tester, FakeJuz.spanningThreeSurahs(), recorder);
    await dwell(tester);

    expect(recorder.calls, hasLength(1), reason: 'it was attempted');
    expect(tester.takeException(), isNull, reason: 'and it stayed swallowed');

    // Navigation is unaffected: Next still advances, and the next verse is
    // still offered to the recorder that just failed.
    await tester.tap(find.text('Next'));
    await dwell(tester);

    // Surah lengths are not stubbed here, so the position line degrades to
    // the verse number alone — which is still proof the cursor moved.
    expect(find.text('2. Al-Baqarah  ·  Verse 254'), findsOneWidget);
    expect(recorder.calls.map((c) => c.ref), [
      'quran:2:253',
      'quran:2:254',
    ]);
    expect(tester.takeException(), isNull);
  });
}
