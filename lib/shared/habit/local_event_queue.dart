/// The offline-durable store for activity events awaiting upload.
///
/// Every in-app act of worship mints one [ActivityEvent] and writes it here
/// first. The UI updates optimistically; this queue carries the truth until
/// the network comes back. Reading Qur'an in a basement still counts.
///
/// The contract this file is a client of is
/// `unified-faith-service/docs/contracts/activity-api.md` (frozen
/// 2026-10-08). Two of its rules are load-bearing *here*, not at flush
/// time:
///
/// 1. **`occurredAt` and `localDay` are stamped at the moment of the act and
///    never again** (§2.2). The server validates
///    `|localDay − dateOf(occurredAt, UTC)| ≤ 1` against the event's *own*
///    `occurredAt`, not against its clock when the batch arrives — precisely
///    so a batch may flush days late. Both fields are stored verbatim as
///    text and handed back unchanged; nothing in this file re-derives them.
/// 2. **`timezone` must be a `Region/City` IANA name, or exactly `UTC` /
///    `GMT`** (§1.5). An abbreviation like `IST` is rejected *permanently*,
///    so an event queued with one can never be accepted no matter how many
///    times it is retried. [normaliseTimezone] resolves what it can and
///    falls back to `UTC` for the rest, at enqueue — a queue row that can
///    never land is worse than a row with a slightly wrong zone, because
///    the zone is stored and not used for validation anyway.
///
/// Deliberately *not* here: minting `clientEventId`s, deciding when to
/// flush, and the HTTP call itself. Those are Tasks 1.9 and 1.12. This is
/// the durable store and nothing else.
library;

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Which faith pack an event belongs to. Wire values per contract §1.1.
enum ActivityFaith {
  islam('islam'),
  hindu('hindu');

  const ActivityFaith(this.wireValue);

  /// The exact lowercase string the API accepts.
  final String wireValue;

  /// Parses a stored value back, throwing on anything unrecognised rather
  /// than silently defaulting — a queue row that cannot be read is a bug
  /// worth surfacing, not worth guessing at.
  static ActivityFaith fromWire(String value) => values.firstWhere(
    (f) => f.wireValue == value,
    orElse: () => throw ArgumentError.value(value, 'faith', 'Unknown faithId'),
  );
}

/// What the user did. Wire values and faith ownership per contract §1.2.
///
/// Each type belongs to exactly one faith, and [faith] is derived from the
/// type rather than passed alongside it. That makes the server's
/// `activity_type_faith_mismatch` rejection unrepresentable on this client.
enum ActivityType {
  quranVerse('quran_verse', ActivityFaith.islam),
  prayer('prayer', ActivityFaith.islam),
  dhikr('dhikr', ActivityFaith.islam),
  gitaShloka('gita_shloka', ActivityFaith.hindu),
  sandhya('sandhya', ActivityFaith.hindu),
  japaMala('japa_mala', ActivityFaith.hindu);

  const ActivityType(this.wireValue, this.faith);

  /// The exact lowercase string the API accepts.
  final String wireValue;

  /// The one faith this activity type belongs to.
  final ActivityFaith faith;

  static ActivityType fromWire(String value) => values.firstWhere(
    (t) => t.wireValue == value,
    orElse: () =>
        throw ArgumentError.value(value, 'activityType', 'Unknown type'),
  );
}

/// `YYYY-MM-DD`, and nothing else. No time, no zone, no `T`.
final RegExp _localDayPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Abbreviations the Android platform still hands out, mapped to the IANA
/// name the server will accept.
///
/// This duplicates the smaller table in `notification_service.dart`, which
/// cannot be reused as-is: that one falls through to the raw name, which is
/// right for the `timezone` package (it throws, and the caller catches) and
/// wrong here (the string would be queued and rejected forever).
const Map<String, String> _abbreviationToIana = {
  'IST': 'Asia/Kolkata',
  'PKT': 'Asia/Karachi',
  'WIB': 'Asia/Jakarta',
  'WITA': 'Asia/Makassar',
  'WIT': 'Asia/Jayapura',
  'MYT': 'Asia/Kuala_Lumpur',
  'SGT': 'Asia/Singapore',
  'PHT': 'Asia/Manila',
  'ICT': 'Asia/Bangkok',
  'HKT': 'Asia/Hong_Kong',
  'JST': 'Asia/Tokyo',
  'KST': 'Asia/Seoul',
  'CST': 'America/Chicago',
  'CDT': 'America/Chicago',
  'EST': 'America/New_York',
  'EDT': 'America/New_York',
  'MST': 'America/Denver',
  'MDT': 'America/Denver',
  'PST': 'America/Los_Angeles',
  'PDT': 'America/Los_Angeles',
  'AKST': 'America/Anchorage',
  'AKDT': 'America/Anchorage',
  'HST': 'Pacific/Honolulu',
  'BST': 'Europe/London',
  'WET': 'Europe/Lisbon',
  'WEST': 'Europe/Lisbon',
  'CET': 'Europe/Paris',
  'CEST': 'Europe/Paris',
  'EET': 'Europe/Athens',
  'EEST': 'Europe/Athens',
  'MSK': 'Europe/Moscow',
  'TRT': 'Europe/Istanbul',
  'AST': 'Asia/Riyadh',
  'GST': 'Asia/Dubai',
  'SAST': 'Africa/Johannesburg',
  'EAT': 'Africa/Nairobi',
  'WAT': 'Africa/Lagos',
  'CAT': 'Africa/Maputo',
  'AEST': 'Australia/Sydney',
  'AEDT': 'Australia/Sydney',
  'ACST': 'Australia/Adelaide',
  'ACDT': 'Australia/Adelaide',
  'AWST': 'Australia/Perth',
  'NZST': 'Pacific/Auckland',
  'NZDT': 'Pacific/Auckland',
  'BRT': 'America/Sao_Paulo',
  'ART': 'America/Argentina/Buenos_Aires',
  'CLT': 'America/Santiago',
};

/// Coerces [raw] into something `POST /activity/events` will accept.
///
/// * `Region/City` (and `Region/Sub/City`) passes through untouched.
/// * `UTC` and `GMT` pass through — §1.5 accepts both verbatim, which
///   matters because an Android device with no region configured reports
///   exactly `UTC` from `TimeZone.getID()`.
/// * A known abbreviation is resolved to its IANA name.
/// * Everything else — a fixed offset (`+05:30`), an empty string, an
///   abbreviation nobody mapped — becomes `UTC`.
///
/// Falling back is the right call because `timezone` is *stored*, not
/// validated against `localDay` (§2.2): a slightly wrong zone costs the
/// user nothing today, while a malformed one costs them the event forever.
String normaliseTimezone(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return 'UTC';
  if (value.contains('/')) return value;
  final upper = value.toUpperCase();
  if (upper == 'UTC' || upper == 'GMT') return upper;
  return _abbreviationToIana[upper] ?? 'UTC';
}

/// One act of worship, as it will be sent to `POST /activity/events`.
///
/// Immutable, and validated on construction: an instance that exists is one
/// the server will not reject for shape. Construction throws [ArgumentError]
/// rather than returning a failure, because every one of these is a client
/// bug at the call site, not a condition the UI can recover from.
class ActivityEvent {
  /// Builds an event, validating and normalising every field.
  ///
  /// [clientEventId] is supplied by the caller and never generated here —
  /// the recorder (Task 1.9) mints it once per act so that retries of the
  /// same queue row reuse it, which is the whole basis of the server's
  /// idempotency (§4.3).
  factory ActivityEvent({
    required String clientEventId,
    required ActivityType activityType,
    required DateTime occurredAt,
    required String localDay,
    required String timezone,
    int quantity = 1,
    String? sourceRef,
  }) {
    final id = clientEventId.trim();
    if (id.isEmpty) {
      throw ArgumentError.value(
        clientEventId,
        'clientEventId',
        'must not be empty',
      );
    }
    if (quantity < 1 || quantity > 10000) {
      throw ArgumentError.value(quantity, 'quantity', 'must be 1…10000');
    }
    if (!_localDayPattern.hasMatch(localDay)) {
      throw ArgumentError.value(localDay, 'localDay', 'must be YYYY-MM-DD');
    }
    final ref = sourceRef?.trim();
    if (ref != null && ref.length > 128) {
      throw ArgumentError.value(
        sourceRef,
        'sourceRef',
        'must be at most 128 characters',
      );
    }
    return ActivityEvent._(
      clientEventId: id,
      activityType: activityType,
      // Normalised to UTC once, here, and never recomputed. The zone offset
      // is preserved as an instant; `timezone` carries the civil zone.
      occurredAt: occurredAt.toUtc(),
      localDay: localDay,
      timezone: normaliseTimezone(timezone),
      quantity: quantity,
      sourceRef: (ref == null || ref.isEmpty) ? null : ref,
    );
  }

  const ActivityEvent._({
    required this.clientEventId,
    required this.activityType,
    required this.occurredAt,
    required this.localDay,
    required this.timezone,
    required this.quantity,
    required this.sourceRef,
  });

  /// Rebuilds an event from a queue row.
  factory ActivityEvent.fromRow(Map<String, Object?> row) => ActivityEvent(
    clientEventId: row['client_event_id']! as String,
    activityType: ActivityType.fromWire(row['activity_type']! as String),
    occurredAt: DateTime.parse(row['occurred_at']! as String),
    localDay: row['local_day']! as String,
    timezone: row['timezone']! as String,
    quantity: row['quantity']! as int,
    sourceRef: row['source_ref'] as String?,
  );

  /// UUID v4 minted on the device; the server's idempotency key (§4.3).
  final String clientEventId;

  /// What the user did. Carries its own [ActivityFaith].
  final ActivityType activityType;

  /// The instant the act happened, in UTC.
  final DateTime occurredAt;

  /// The calendar day the user believed it was, `YYYY-MM-DD`. Streaks count
  /// these, and the server validates them against [occurredAt] (§2.2).
  final String localDay;

  /// IANA zone name, or `UTC` / `GMT`. Already normalised.
  final String timezone;

  /// How many units of [activityType] — a sum, not a count, server-side.
  final int quantity;

  /// Optional provenance, e.g. `quran:2:148` (§1.6).
  final String? sourceRef;

  /// The faith this event belongs to, derived from [activityType].
  ActivityFaith get faith => activityType.faith;

  /// The event object `POST /activity/events` expects.
  ///
  /// Note what is absent: any call to [DateTime.now]. Serialising an event
  /// for the wire must never re-stamp it, however late the flush is.
  Map<String, Object?> toJson() => <String, Object?>{
    'clientEventId': clientEventId,
    'faithId': faith.wireValue,
    'activityType': activityType.wireValue,
    'quantity': quantity,
    'occurredAt': _iso(occurredAt),
    'localDay': localDay,
    'timezone': timezone,
    if (sourceRef != null) 'sourceRef': sourceRef,
  };

  /// The queue row, keyed by column name.
  Map<String, Object?> toRow() => <String, Object?>{
    'client_event_id': clientEventId,
    'faith_id': faith.wireValue,
    'activity_type': activityType.wireValue,
    'quantity': quantity,
    'occurred_at': _iso(occurredAt),
    'local_day': localDay,
    'timezone': timezone,
    'source_ref': sourceRef,
  };

  /// RFC 3339 with an explicit `Z`. [DateTime.toIso8601String] on a UTC
  /// value already ends in `Z`; this is belt-and-braces against a non-UTC
  /// value slipping through, since a bare instant is rejected (§1.5).
  static String _iso(DateTime at) => at.toUtc().toIso8601String();

  @override
  String toString() =>
      'ActivityEvent($clientEventId, ${activityType.wireValue} x$quantity, '
      'localDay=$localDay, occurredAt=${_iso(occurredAt)}, tz=$timezone)';
}

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
