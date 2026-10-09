/// The offline-durable store for activity events awaiting upload.
///
/// Every in-app act of worship mints one [ActivityEvent] and writes it here
/// first. The UI updates optimistically; this queue carries the truth until
/// the network comes back. Reading Qur'an in a basement still counts.
///
/// The event itself — [ActivityEvent], [ActivityType], [ActivityFaith] and
/// the contract rules they enforce — lives in `activity_event.dart`. It was
/// lifted out of this file so that callers which only need the vocabulary
/// (Task 1.11's content packs, for one) do not have to import a storage
/// class to get an enum. Deliberately *not* re-exported from here: a
/// caller that handles [ActivityEvent]s should say so in its own imports,
/// rather than inheriting the vocabulary from whichever file it happened
/// to reach for.
///
/// Deliberately *not* here: minting `clientEventId`s, deciding when to
/// flush, and the HTTP call itself. Those are Tasks 1.9 and 1.12. This is
/// the durable store and nothing else.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'activity_event.dart';

part 'local_event_queue.g.dart';

/// A durable FIFO of [ActivityEvent]s waiting to reach the server.
///
/// The read/delete split is the whole design: [peek] hands out a batch
/// without removing it, and [acknowledge] removes only what the caller says
/// landed. There is no in-flight flag, no lease, no status column — a crash
/// or a kill mid-flush therefore strands nothing, and the worst case is a
/// re-send, which the server's idempotency on `clientEventId` makes free
/// (§4.3). State that could be wrong is state worth not having.
class LocalEventQueue {
  LocalEventQueue._(this._db);

  /// Rows kept at most. Beyond this the oldest are dropped on insert, so a
  /// device that is offline forever cannot fill the user's storage.
  ///
  /// At roughly 220 bytes per event this is a little over a megabyte — and
  /// §2.3 drops anything over 90 days old server-side anyway, so a queue
  /// this deep is already holding events that will never be accepted.
  static const int maxRows = 5000;

  /// Default [peek] size, matching the server's per-request cap (§4.7).
  static const int batchSize = 100;

  /// SQLite's parameter ceiling is 999; stay well clear when deleting.
  static const int _deleteChunk = 500;

  static const String _table = 'activity_event_queue';

  final Database _db;

  /// Where the queue lives, given the app's database directory.
  ///
  /// Takes the directory rather than calling `getDatabasesPath()` itself:
  /// that is a platform channel, so a queue that resolved its own path
  /// could not be opened in a test. The app wiring passes it in.
  static String databasePathIn(String directory) =>
      p.join(directory, 'activity_queue.db');

  /// Opens (creating if needed) the queue at [path].
  ///
  /// [factory] defaults to the platform's sqflite implementation; tests pass
  /// the FFI factory so the same code runs against a real file on the Dart
  /// VM.
  static Future<LocalEventQueue> open({
    required String path,
    DatabaseFactory? factory,
  }) async {
    final db = await (factory ?? databaseFactory).openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) async {
          // AUTOINCREMENT, not a bare INTEGER PRIMARY KEY: it forbids rowid
          // reuse, so row_id stays strictly increasing across trims and
          // "oldest" never becomes ambiguous after the cap has bitten.
          //
          // The cap evicts by row_id — insertion order — and not by
          // occurred_at, which can legitimately run backwards across the
          // queue when a backdated event is recorded or the device clock
          // moves. Sorting by it would discard the newer row.
          await db.execute('''
            CREATE TABLE $_table (
              row_id          INTEGER PRIMARY KEY AUTOINCREMENT,
              client_event_id TEXT    NOT NULL UNIQUE,
              faith_id        TEXT    NOT NULL,
              activity_type   TEXT    NOT NULL,
              quantity        INTEGER NOT NULL,
              occurred_at     TEXT    NOT NULL,
              local_day       TEXT    NOT NULL,
              timezone        TEXT    NOT NULL,
              source_ref      TEXT
            )
          ''');
        },
      ),
    );
    return LocalEventQueue._(db);
  }

  /// Appends one event. Shorthand for [enqueueAll].
  Future<void> enqueue(ActivityEvent event) => enqueueAll([event]);

  /// Appends [events] and enforces the cap, atomically.
  ///
  /// A `clientEventId` already in the queue is ignored, not overwritten:
  /// the UNIQUE index plus `INSERT OR IGNORE` mirror the server's
  /// first-write-wins rule (§4.3), so a double-tap or a retried recorder
  /// call cannot produce two rows or mutate the original.
  ///
  /// The trim runs inside the same transaction as the inserts, so the cap
  /// holds at every point an outside reader could observe.
  Future<void> enqueueAll(Iterable<ActivityEvent> events) async {
    final batch = events.toList(growable: false);
    if (batch.isEmpty) return;
    await _db.transaction((txn) async {
      for (final event in batch) {
        await txn.insert(
          _table,
          event.toRow(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      final total =
          Sqflite.firstIntValue(
            await txn.rawQuery('SELECT COUNT(*) FROM $_table'),
          ) ??
          0;
      if (total > maxRows) {
        await txn.rawDelete(
          'DELETE FROM $_table WHERE row_id NOT IN '
          '(SELECT row_id FROM $_table ORDER BY row_id DESC LIMIT ?)',
          [maxRows],
        );
      }
    });
  }

  /// The oldest [limit] events, still in the queue afterwards.
  ///
  /// Nothing is marked, locked or removed. A caller that fails to send what
  /// it reads simply drops it on the floor and the next [peek] returns the
  /// same rows.
  ///
  /// A row this build cannot decode — an `activity_type` written by a newer
  /// version of the app, a column corrupted on disk — is dropped rather
  /// than thrown. [ActivityEvent.fromRow] validates, so one bad row would
  /// otherwise make the *entire* queue unreadable and cost the user every
  /// event behind it. That is the poison pill §4.2 made the server's batch
  /// partial-not-atomic to avoid, and it deserves the same answer here.
  /// Such a row can never be sent, so it is deleted on the way past.
  Future<List<ActivityEvent>> peek({int limit = batchSize}) async {
    final rows = await _db.query(
      _table,
      orderBy: 'row_id ASC',
      limit: limit < 1 ? 1 : limit,
    );
    final events = <ActivityEvent>[];
    final undecodable = <Object?>[];
    for (final row in rows) {
      try {
        events.add(ActivityEvent.fromRow(row));
      } on Object {
        undecodable.add(row['row_id']);
      }
    }
    if (undecodable.isNotEmpty) {
      final holes = List.filled(undecodable.length, '?').join(', ');
      await _db.delete(
        _table,
        where: 'row_id IN ($holes)',
        whereArgs: undecodable,
      );
    }
    return List.unmodifiable(events);
  }

  /// Deletes the events the server has settled, and only those.
  ///
  /// "Settled" is the contract's word for it (§4.8): on a `200` every event
  /// in the batch is accepted, duplicate or permanently rejected, and all
  /// three are finished with. Anything the caller omits — because the
  /// request failed, timed out, or returned something unparseable — stays
  /// exactly where it is.
  ///
  /// Returns how many rows were removed.
  Future<int> acknowledge(Iterable<String> clientEventIds) async {
    final ids = clientEventIds.toSet().toList(growable: false);
    if (ids.isEmpty) return 0;
    var removed = 0;
    await _db.transaction((txn) async {
      for (var i = 0; i < ids.length; i += _deleteChunk) {
        final chunk = ids.sublist(
          i,
          i + _deleteChunk > ids.length ? ids.length : i + _deleteChunk,
        );
        final holes = List.filled(chunk.length, '?').join(', ');
        removed += await txn.delete(
          _table,
          where: 'client_event_id IN ($holes)',
          whereArgs: chunk,
        );
      }
    });
    return removed;
  }

  /// Events for [faith] filed under a day in `[from, to]` inclusive.
  ///
  /// The optimistic overlay reads this: anything still here is something
  /// the server has not seen, so the Today screen adds it on top of what
  /// `/today` and `/history` reported. That is what makes a verse read in a
  /// basement move the goal ring immediately.
  ///
  /// Filtered in SQL rather than by reading the queue and discarding:
  /// this runs on every dashboard rebuild, and the cap is 5000 rows.
  ///
  /// Undecodable rows are skipped — but **not deleted**, unlike [peek].
  /// This is a read for display, and a display path that silently destroys
  /// data is a much worse bargain than one that renders slightly low.
  Future<List<ActivityEvent>> pendingBetween({
    required ActivityFaith faith,
    required String from,
    required String to,
  }) async {
    final rows = await _db.query(
      _table,
      where: 'faith_id = ? AND local_day >= ? AND local_day <= ?',
      whereArgs: [faith.wireValue, from, to],
      orderBy: 'row_id ASC',
    );
    final events = <ActivityEvent>[];
    for (final row in rows) {
      try {
        events.add(ActivityEvent.fromRow(row));
      } on Object {
        continue;
      }
    }
    return List.unmodifiable(events);
  }

  /// How many events are waiting.
  Future<int> count() async =>
      Sqflite.firstIntValue(
        await _db.rawQuery('SELECT COUNT(*) FROM $_table'),
      ) ??
      0;

  /// Closes the underlying database. The file, and everything in it,
  /// survives.
  Future<void> close() => _db.close();
}

/// The app's one queue, opened once and kept for the process lifetime.
///
/// `keepAlive` because the whole point is durability across screens: a
/// queue disposed with the last widget that recorded something would
/// reopen the database on every tap. Closed on dispose so a test container
/// does not leak the file handle.
@Riverpod(keepAlive: true)
Future<LocalEventQueue> localEventQueue(Ref ref) async {
  final queue = await LocalEventQueue.open(
    path: LocalEventQueue.databasePathIn(await getDatabasesPath()),
  );
  ref.onDispose(queue.close);
  return queue;
}
