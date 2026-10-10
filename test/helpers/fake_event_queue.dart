import 'package:faith_mobile/shared/habit/activity_event.dart';
import 'package:faith_mobile/shared/habit/local_event_queue.dart';

/// An in-memory stand-in for [LocalEventQueue], for widget tests.
///
/// The real queue is sqflite — even through the FFI factory that is file
/// I/O on a background isolate, and a `testWidgets` body runs inside
/// `FakeAsync`, where that I/O does not complete between pumps. A test that
/// drove it would hang rather than fail, which is how it fails: by timing
/// out ten minutes later with nothing useful to say.
///
/// So the semantics the purge depends on are reproduced here, in plain
/// Dart: rows go in, `deleteAll` takes them all out, and `count` reports
/// what is left. The real implementation of those is covered against a real
/// database in `local_event_queue_test.dart` and
/// `local_data_purge_test.dart`; what a widget test needs from it is that
/// the wipe actually empties it, so a fake that merely counted calls would
/// be no better than the one that let this bug through the first time.
class FakeEventQueue implements LocalEventQueue {
  final List<ActivityEvent> rows = [];
  bool closed = false;

  @override
  Future<void> enqueue(ActivityEvent event) => enqueueAll([event]);

  @override
  Future<void> enqueueAll(Iterable<ActivityEvent> events) async {
    for (final event in events) {
      // `INSERT OR IGNORE` on a UNIQUE client_event_id, as the real one does.
      if (rows.any((r) => r.clientEventId == event.clientEventId)) continue;
      rows.add(event);
    }
  }

  @override
  Future<List<ActivityEvent>> peek({int limit = LocalEventQueue.batchSize}) async =>
      List.unmodifiable(rows.take(limit < 1 ? 1 : limit));

  @override
  Future<int> acknowledge(Iterable<String> clientEventIds) async {
    final ids = clientEventIds.toSet();
    final before = rows.length;
    rows.removeWhere((r) => ids.contains(r.clientEventId));
    return before - rows.length;
  }

  @override
  Future<List<ActivityEvent>> pendingBetween({
    required ActivityFaith faith,
    required String from,
    required String to,
  }) async => List.unmodifiable(
    rows.where(
      (r) =>
          r.faith == faith && r.localDay.compareTo(from) >= 0 && r.localDay.compareTo(to) <= 0,
    ),
  );

  @override
  Future<int> count() async => rows.length;

  @override
  Future<int> deleteAll() async {
    final removed = rows.length;
    rows.clear();
    return removed;
  }

  @override
  Future<void> close() async => closed = true;
}
