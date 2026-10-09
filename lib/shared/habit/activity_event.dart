/// The vocabulary of a recorded act of worship and of the goal it counts
/// toward, and the one shape the server accepts for an event.
///
/// Lifted out of `local_event_queue.dart`: these types are the *contract*,
/// not the storage. A caller that only needs to name an activity — Task
/// 1.11's content packs, a future analytics mapper — should not have to
/// import a SQLite wrapper to get an enum.
///
/// The contract this file is a client of is
/// `unified-faith-service/docs/contracts/activity-api.md` (frozen
/// 2026-10-08). Two of its rules are load-bearing *here*, at the moment an
/// event is constructed, rather than at flush time:
///
/// 1. **`occurredAt` and `localDay` are stamped at the moment of the act and
///    never again** (§2.2). The server validates
///    `|localDay − dateOf(occurredAt, UTC)| ≤ 1` against the event's *own*
///    `occurredAt`, not against its clock when the batch arrives — precisely
///    so a batch may flush days late. Both fields are carried verbatim and
///    nothing downstream re-derives them.
/// 2. **`timezone` must be a `Region/City` IANA name, or exactly `UTC` /
///    `GMT`** (§1.5). An abbreviation like `IST` is rejected *permanently*,
///    so an event queued with one can never be accepted no matter how many
///    times it is retried. [normaliseActivityTimezone] resolves what it can
///    and falls back to `UTC` for the rest, at construction.
library;

import '../../core/time/timezone_names.dart';

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

/// What the user set a target in. Wire values and ranges per contract §1.3.
///
/// Plural and readable (`verses`) rather than mirroring [ActivityType]
/// (`quran_verse`) because it names the *unit the user counts in*, which is
/// what the goal card says out loud: "5 / 5 verses".
///
/// Each goal type counts exactly one [ActivityType], and [faith] is derived
/// from that rather than carried separately — which makes the server's
/// `goal_type_faith_mismatch` rejection unrepresentable here, the same way
/// [ActivityType.faith] does for events.
///
/// Deliberately absent: `pages` and `minutes`. §1.3 rules both out of Phase
/// 1 and the server rejects them as unknown.
enum GoalType {
  verses('verses', ActivityType.quranVerse, 1000),
  prayers('prayers', ActivityType.prayer, 5),
  dhikr('dhikr', ActivityType.dhikr, 10000),
  shlokas('shlokas', ActivityType.gitaShloka, 1000),
  sandhyas('sandhyas', ActivityType.sandhya, 3),
  malas('malas', ActivityType.japaMala, 108);

  const GoalType(this.wireValue, this.counts, this.maxTarget);

  /// The exact lowercase string the API accepts.
  final String wireValue;

  /// The one activity type whose `quantity` this goal sums (§2.4).
  final ActivityType counts;

  /// The largest target §1.3 allows. The smallest is always 1.
  final int maxTarget;

  /// The faith this goal belongs to, via the activity it counts.
  ActivityFaith get faith => counts.faith;

  static GoalType fromWire(String value) => values.firstWhere(
    (g) => g.wireValue == value,
    orElse: () => throw ArgumentError.value(value, 'goalType', 'Unknown type'),
  );
}

/// `YYYY-MM-DD`, and nothing else. No time, no zone, no `T`.
final RegExp _localDayPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

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
      timezone: normaliseActivityTimezone(timezone),
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
