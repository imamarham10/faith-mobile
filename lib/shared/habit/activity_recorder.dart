/// The single entry point every feature calls to record an act of worship.
///
/// ```dart
/// await ref.read(activityRecorderProvider).record(
///   ActivityType.quranVerse, quantity: 1, sourceRef: 'quran:2:148');
/// ```
///
/// Two properties make this safe to call from a tap handler, and both are
/// structural rather than incidental:
///
/// 1. **It never touches the network.** [ActivityRecorder] is constructed
///    from a queue, a clock and an id generator; there is no `Dio` in this
///    file and no import that could reach one. `record()` stamps the event
///    and hands it to the durable queue, which is a local SQLite write.
///    Reading Qur'an in a basement with no signal counts the same as
///    reading it on wifi, and the UI can update optimistically because the
///    queue is already carrying the truth.
/// 2. **It never throws.** A recorder that threw into a tap handler would
///    be the same trap as a tracker that only counts up: the user's act
///    would surface as an error dialog, or worse, be silently lost behind
///    an unhandled future. Failures are logged and swallowed; [record]
///    reports whether the event landed for callers that care.
///
/// The upload itself is [ActivityFlusher] (`activity_flusher.dart`) and the
/// decision of *when* to run it is [ActivityFlushScope]
/// (`activity_flush_scheduler.dart`). This class signals the second of
/// those through a counter and never reaches either directly, which is what
/// keeps property 1 structural rather than a promise.
library;

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/time/device_timezone.dart';
import '../../core/time/timezone_names.dart';
import 'activity_event.dart';
import 'activity_flush_scheduler.dart';
import 'local_event_queue.dart';

part 'activity_recorder.g.dart';

/// Mints, stamps and durably enqueues one act of worship.
///
/// ## The one corner `dedupeKey` does not cover
///
/// A deterministic `clientEventId` (see [record]) carries no user
/// component, because the server's unique index is
/// `(userId, clientEventId)` and scopes it already. The local queue's
/// index is not scoped that way, and `AuthController.signOut()` does not
/// purge the queue — only account deletion does, via `LocalDataPurge`. So
/// if user A reads 2:142, signs out before the queue flushes, and user B
/// signs in on the same handset and reads 2:142 the same day, B's event is
/// swallowed by `INSERT OR IGNORE` against A's row.
///
/// Left as-is deliberately. `AuthAuthenticated` carries an access token
/// and an email, no stable user id, and keying on a token that rotates on
/// every refresh would destroy the determinism this exists for. The same
/// unpurged queue already has the larger version of this problem — A's
/// events flush under B's credentials — so the fix belongs in `signOut`,
/// not in the key.
class ActivityRecorder {
  /// Builds a recorder over [queue].
  ///
  /// [now], [newId] and [timezoneName] are injected so the stamping can be
  /// asserted without waiting for midnight or guessing a UUID. Every one of
  /// them defaults to the real thing.
  ActivityRecorder({
    required Future<LocalEventQueue> queue,
    DateTime Function() now = DateTime.now,
    String Function() newId = _uuidV4,
    String Function() timezoneName = _deviceTimezoneName,
    VoidCallback? onRecorded,
  }) : _queue = queue,
       _now = now,
       _newId = newId,
       _timezoneName = timezoneName,
       _onRecorded = onRecorded;

  static const Uuid _uuid = Uuid();
  static String _uuidV4() => _uuid.v4();

  /// Namespace for the deterministic ids [record]'s `dedupeKey` mints.
  ///
  /// A fixed, arbitrary UUID, and it must stay fixed forever: changing it
  /// re-keys every act, and the server's first-write-wins (§4.3) would
  /// then count a re-read of a verse already stored under the old key as a
  /// second verse. It is private for the same reason — nothing outside
  /// this class should be able to mint an id in this namespace.
  static const String _dedupeNamespace = '8f14d6b2-4c71-4a0e-9f3b-5d2e71c8a640';

  /// The device's civil timezone, as the platform names it.
  ///
  /// Contract §1.5 asks for the platform's IANA identifier and explicitly
  /// warns against `DateTime.timeZoneName`, which on Android and iOS is
  /// the *abbreviation* (`IST`) rather than the zone (`Asia/Kolkata`).
  /// [DeviceTimezone] is that IANA source: it reads
  /// `TimeZone.getDefault().getID()` / `TimeZone.current.identifier`
  /// through `flutter_timezone` and caches the answer, so this getter is
  /// synchronous and [_stamp] stays synchronous with it.
  ///
  /// The abbreviation table is still underneath, as the fallback for a
  /// platform that has not answered yet or cannot — see [DeviceTimezone].
  /// Either way the value is run through [normaliseActivityTimezone], so
  /// the event never carries a shape the server rejects permanently.
  static String _deviceTimezoneName() => DeviceTimezone.instance.current;

  /// Resolved lazily and awaited inside [record], never in the constructor:
  /// the queue's path comes from a platform channel, and the provider is
  /// read synchronously at the call site.
  final Future<LocalEventQueue> _queue;

  final DateTime Function() _now;
  final String Function() _newId;
  final String Function() _timezoneName;

  /// Called after an event is durably queued, so the flush scheduler can
  /// start its debounce. Deliberately a bare callback and not a flusher:
  /// property 1 above — *it never touches the network* — is enforced by
  /// there being no way to reach one from here, and handing this class a
  /// `Dio` to satisfy a convenience would quietly give that up. The
  /// callback is invoked after the write, never before, so a flush it
  /// triggers can only ever find a row that is already durable.
  final VoidCallback? _onRecorded;

  /// Records one act of worship and returns once it is durably queued.
  ///
  /// Returns `true` when the event reached the queue. A `false` means it
  /// did not and never will — the event is lost — which is a client bug
  /// worth an analytics event once Task 1.14 lands, not something the UI
  /// should surface or retry.
  ///
  /// [quantity] is the number of units of [type] (verses, repetitions,
  /// prayers), not a number of events: one call with `quantity: 33` and 33
  /// calls with `quantity: 1` sum to the same thing server-side, and the
  /// first is one queue row instead of 33.
  ///
  /// [sourceRef] must follow §1.6's shape for [type] — `quran:2:148`,
  /// `prayer:fajr`, `dhikr:<counterId>`. Nothing validates it yet; Phase 2
  /// derives challenge progress from it, so emitting it correctly now is
  /// what makes that data exist when it is needed.
  ///
  /// There is deliberately no way to backdate an act. A `DateTime at`
  /// parameter would read as if §2.2's `|localDay − dateOf(occurredAt)| ≤ 1`
  /// bounded it, and it would not: [_stamp] derives `localDay` from the
  /// same instant as `occurredAt`, so that inequality holds for any value a
  /// caller passes and the only real limit is §2.3's 90-day server window.
  /// An unbounded backfill is not something to hand a caller by accident.
  /// Task 1.12 can add one, with its own bound, when a call site needs it —
  /// logging a prayer made earlier in the day is the obvious candidate.
  ///
  /// ## [dedupeKey] — "this act, at most once a day"
  ///
  /// Left null (the default, and what every counter call site wants) each
  /// call mints a fresh UUID v4 and is its own event: thirty-three taps of
  /// a dhikr counter are thirty-three acts.
  ///
  /// Passed, the `clientEventId` becomes a **UUID v5 over
  /// `type | dedupeKey | localDay`** instead, so the same key recorded
  /// twice on the same local day is the *same* event — collapsed by the
  /// queue's `UNIQUE(client_event_id)` on the way in and by the server's
  /// `@@unique([userId, clientEventId])` (§4.3) on the way out, whichever
  /// gets there first. That is what a *reader* wants: re-opening a surah
  /// and scrolling over a verse already read today is not a second verse.
  ///
  /// Three properties make this safe rather than clever:
  ///
  /// * **The day comes from the same clock reading as the event's own
  ///   `localDay`** — see [_stamp]. A key derived by the caller could name
  ///   one day while the event it keys is filed under another, across
  ///   midnight or a timezone change.
  /// * **The id is a real UUID.** The server validates shape, not version
  ///   (`activity.service.ts`), and rejects a non-UUID *permanently* — a
  ///   plain `quran:2:142:2026-10-10` would be dropped silently for ever.
  ///   v5 is the deterministic UUID, so there is no trade here.
  /// * **The key is not user-scoped, and does not need to be.** The
  ///   server's unique index is `(userId, clientEventId)`, so two users
  ///   cannot collide where it counts. See the class doc for the one
  ///   on-device corner this leaves.
  ///
  /// Because the id *is* the content, reusing a key for different content
  /// is the one thing a caller must not do: §4.3 is first-write-wins, so
  /// the second act would be counted a duplicate and lost. Key on what was
  /// done (`quran:2:142`), never on where the user was when they did it.
  Future<bool> record(
    ActivityType type, {
    int quantity = 1,
    String? sourceRef,
    String? dedupeKey,
  }) async {
    final ActivityEvent event;
    try {
      // Stamped BEFORE the queue is awaited, deliberately. `_queue` opens a
      // database on first use, and that await can take long enough to cross
      // midnight on an unlucky night; stamping afterwards would file the
      // act under the wrong day and break the streak it was meant to feed.
      event = _stamp(
        type,
        quantity: quantity,
        sourceRef: sourceRef,
        dedupeKey: dedupeKey,
      );
    } on Object catch (e, st) {
      // Only reachable from ActivityEvent's own validation — a quantity
      // outside 1…10000, an over-long sourceRef. Every one of those is a
      // bug at the call site, so it is logged loudly and dropped rather
      // than thrown into whatever widget tapped.
      developer.log(
        'refused to record ${type.wireValue}: invalid event',
        name: 'habit.recorder',
        error: e,
        stackTrace: st,
      );
      return false;
    }

    try {
      await (await _queue).enqueue(event);
      // After the row is durable, and guarded: a scheduler that threw must
      // not turn a successful record into a `false`.
      try {
        _onRecorded?.call();
      } on Object catch (e, st) {
        developer.log(
          'flush request failed after recording ${event.clientEventId}',
          name: 'habit.recorder',
          error: e,
          stackTrace: st,
        );
      }
      return true;
    } on Object catch (e, st) {
      developer.log(
        'failed to enqueue ${event.clientEventId} (${type.wireValue})',
        name: 'habit.recorder',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  /// Builds the event, taking every clock reading it needs exactly once.
  ///
  /// `occurredAt` and `localDay` come from a *single* [DateTime] because
  /// they must agree: two separate `now()` calls either side of midnight
  /// would stamp an instant on one day and a calendar date on another, and
  /// §2.2 would still accept the pair (they are within a day of each other)
  /// — so the bug would not surface as a rejection, it would surface as a
  /// streak that broke for no visible reason.
  ///
  /// A [dedupeKey] is folded in here, against this same reading, for the
  /// same reason: an id that named yesterday on an event stamped today
  /// would dedupe against the wrong day's act — and would do it silently,
  /// because the server has no way to know the two disagree.
  ActivityEvent _stamp(
    ActivityType type, {
    required int quantity,
    required String? sourceRef,
    String? dedupeKey,
  }) {
    final moment = _now().toLocal();
    final localDay = _localDay(moment);
    return ActivityEvent(
      clientEventId: dedupeKey == null
          ? _newId()
          : _uuid.v5(
              _dedupeNamespace,
              '${type.wireValue}|$dedupeKey|$localDay',
            ),
      activityType: type,
      quantity: quantity,
      // The instant, in UTC.
      occurredAt: moment,
      // The day the *user* believes it is: the device's calendar date, from
      // the device's own local components. Never recomputed from
      // `occurredAt` at flush time — that is the whole point of §2.2, and
      // why a batch sent six days late still lands on the right day.
      localDay: localDay,
      timezone: normaliseActivityTimezone(_timezoneName()),
      sourceRef: sourceRef,
    );
  }

  /// `YYYY-MM-DD` from [moment]'s **local** components.
  static String _localDay(DateTime moment) {
    final y = moment.year.toString().padLeft(4, '0');
    final m = moment.month.toString().padLeft(2, '0');
    final d = moment.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

/// The recorder every feature reaches for.
///
/// Synchronously constructible on purpose — call sites do
/// `ref.read(activityRecorderProvider).record(...)` from inside a tap
/// handler, with no `await` before the read and no `AsyncValue` to unwrap.
/// The queue it needs is async, so it is passed in unresolved and awaited
/// inside `record()`, *after* the event has been stamped.
@Riverpod(keepAlive: true)
ActivityRecorder activityRecorder(Ref ref) => ActivityRecorder(
  queue: ref.watch(localEventQueueProvider.future),
  onRecorded: () => ref.read(activityFlushRequestProvider.notifier).poke(),
);
