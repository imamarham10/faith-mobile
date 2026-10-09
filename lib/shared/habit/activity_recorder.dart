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
/// The actual upload and the calls from Qur'an, prayers and dhikr are both
/// Task 1.12. Neither is here. (Task 1.10 is the local streak engine in
/// `streak_engine.dart`, not the flush — this comment said otherwise.)
library;

import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/time/device_timezone.dart';
import '../../core/time/timezone_names.dart';
import 'activity_event.dart';
import 'local_event_queue.dart';

part 'activity_recorder.g.dart';

/// Mints, stamps and durably enqueues one act of worship.
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
  }) : _queue = queue,
       _now = now,
       _newId = newId,
       _timezoneName = timezoneName;

  static const Uuid _uuid = Uuid();
  static String _uuidV4() => _uuid.v4();

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
  Future<bool> record(
    ActivityType type, {
    int quantity = 1,
    String? sourceRef,
  }) async {
    final ActivityEvent event;
    try {
      // Stamped BEFORE the queue is awaited, deliberately. `_queue` opens a
      // database on first use, and that await can take long enough to cross
      // midnight on an unlucky night; stamping afterwards would file the
      // act under the wrong day and break the streak it was meant to feed.
      event = _stamp(type, quantity: quantity, sourceRef: sourceRef);
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
  ActivityEvent _stamp(
    ActivityType type, {
    required int quantity,
    required String? sourceRef,
  }) {
    final moment = _now().toLocal();
    return ActivityEvent(
      clientEventId: _newId(),
      activityType: type,
      quantity: quantity,
      // The instant, in UTC.
      occurredAt: moment,
      // The day the *user* believes it is: the device's calendar date, from
      // the device's own local components. Never recomputed from
      // `occurredAt` at flush time — that is the whole point of §2.2, and
      // why a batch sent six days late still lands on the right day.
      localDay: _localDay(moment),
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
ActivityRecorder activityRecorder(Ref ref) =>
    ActivityRecorder(queue: ref.watch(localEventQueueProvider.future));
