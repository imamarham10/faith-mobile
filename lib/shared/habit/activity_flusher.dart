/// The one thing that sends queued acts of worship to the server.
///
/// Task 1.12. `614cde4` built the durable queue and `e4ad28f` the recorder;
/// neither sends anything, by design — the recorder must never touch the
/// network, because reading Qur'an in a basement has to count. This file is
/// where the network finally appears, behind a `flush()` that is safe to
/// call from anywhere and that cannot throw into its caller.
///
/// ## The queue rules, which are not negotiable
///
/// Contract §4.8 is normative about what the queue does for each outcome,
/// and every one of them is implemented literally:
///
/// | Outcome | Queue |
/// |---|---|
/// | `200` | delete **every** id in the batch — accepted, duplicate and rejected alike |
/// | `400 batch_too_large` | re-chunk smaller and retry |
/// | other `400` | drop the batch; retrying a client bug cannot help |
/// | `401` | keep the batch, stop |
/// | `5xx`, timeout, socket error, unparseable body | keep the **whole** batch, stop |
///
/// The last row is the one worth being careful about: a request that
/// succeeded server-side but whose response never arrived is
/// indistinguishable from one that never landed, and §4.8 says never to try
/// to tell them apart. Always resend; `clientEventId` makes the resend free
/// (§4.3). That is also why there is no lease, no in-flight flag and no
/// status column on the queue — [LocalEventQueue.peek] hands out rows
/// without marking them and [LocalEventQueue.acknowledge] removes only what
/// settled, so a crash mid-flush strands nothing and costs at most a
/// duplicate.
///
/// ## Acknowledging on `200`: what the response does and does not tell us
///
/// `accepted` and `duplicates` are **integers, not id lists** (§4.4) — only
/// `rejected[]` carries ids. So "acknowledge what the server accepted or
/// called a duplicate" cannot be done by reading the response; it is done
/// by knowing what was sent. `accepted + duplicates + rejected.length`
/// always equals the batch size, so a `200` settles the entire batch and
/// every id in it is deleted.
///
/// Rejected rows are deleted too, and that is deliberate rather than
/// sloppy: every code in §4.5 is **permanent**, so a retained rejection is
/// a row that can never leave the queue, and once it is at the head it
/// blocks every event behind it forever. That is exactly the poison pill
/// §4.2 made the server's batch partial-not-atomic to avoid, and it
/// deserves the same answer here. They are logged on the way out.
///
/// ## No backoff of its own
///
/// `DioClient` already installs `_RetryInterceptor`, which retries 5xx and
/// connection failures twice with exponential delay. A second backoff layer
/// here would multiply, not add — a flush of ten batches against a dead
/// server would sit for minutes. So a kept batch simply ends the flush, and
/// the next trigger (resume, connectivity, the debounce after a record)
/// tries again.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers.dart';
import 'activity_event.dart';
import 'local_event_queue.dart';

part 'activity_flusher.g.dart';

/// What one call to [ActivityFlusher.flush] did.
///
/// Returned rather than thrown so a caller that cares — a test, a pull to
/// refresh — can see what happened, while the overwhelmingly common caller
/// (a lifecycle hook) can ignore it entirely.
class FlushOutcome {
  /// Builds an outcome.
  const FlushOutcome({
    this.accepted = 0,
    this.duplicates = 0,
    this.rejected = 0,
    this.dropped = 0,
    this.batches = 0,
    this.retained = false,
    this.skipped = false,
  });

  /// Events the server wrote on this flush.
  final int accepted;

  /// Events the server already had. Nothing wrong; §4.3 makes resends free.
  final int duplicates;

  /// Events the server refused permanently (§4.5). Deleted and logged.
  final int rejected;

  /// Events dropped without the server ruling on them, because the whole
  /// request was a client bug (a non-`batch_too_large` `400`, §4.8).
  final int dropped;

  /// Requests made.
  final int batches;

  /// True when at least one batch was kept for a later attempt — a 5xx,
  /// a timeout, a 401 or a response that could not be parsed.
  final bool retained;

  /// True when another flush was already running and this call did nothing.
  final bool skipped;

  /// Whether the queue was fully drained and nothing is waiting.
  bool get isComplete => !retained && !skipped;

  @override
  String toString() =>
      'FlushOutcome(accepted: $accepted, duplicates: $duplicates, '
      'rejected: $rejected, dropped: $dropped, batches: $batches, '
      'retained: $retained, skipped: $skipped)';
}

/// Sends queued events to `POST /api/v1/activity/events`.
class ActivityFlusher {
  /// Builds a flusher over [queue], sending through [dio].
  ActivityFlusher({required Dio dio, required Future<LocalEventQueue> queue})
    : _dio = dio,
      _queue = queue;

  /// The write path. The only one — everything else in the engine is a
  /// projection over what this endpoint stores.
  static const String path = '/api/v1/activity/events';

  /// §4.7 — at most 100 events per request, sent sequentially.
  static const int maxBatch = LocalEventQueue.batchSize;

  /// A ceiling on batches per flush, so a queue that somehow fails to
  /// shrink cannot spin the loop forever. 50 × 100 drains the 5000-row cap
  /// in one pass.
  static const int _maxBatchesPerFlush = 50;

  final Dio _dio;
  final Future<LocalEventQueue> _queue;

  /// The in-flight flush, if any. Resume, connectivity return and the
  /// post-record debounce can all fire within the same second; without this
  /// they would each peek the same rows and send them three times. The
  /// server would absorb it — that is what idempotency is for — but it is
  /// three times the bytes on a connection that has just come back.
  Future<FlushOutcome>? _inFlight;

  /// Sends everything waiting, in batches of at most [maxBatch].
  ///
  /// Never throws. Returns what happened. A flush already in progress is
  /// joined rather than duplicated — the caller gets that flush's outcome
  /// marked [FlushOutcome.skipped].
  Future<FlushOutcome> flush() {
    final running = _inFlight;
    if (running != null) {
      return running.then(
        (outcome) => FlushOutcome(
          accepted: outcome.accepted,
          duplicates: outcome.duplicates,
          rejected: outcome.rejected,
          dropped: outcome.dropped,
          batches: outcome.batches,
          retained: outcome.retained,
          skipped: true,
        ),
      );
    }
    final future = _flush();
    _inFlight = future;
    return future.whenComplete(() => _inFlight = null);
  }

  Future<FlushOutcome> _flush() async {
    final LocalEventQueue queue;
    try {
      queue = await _queue;
    } on Object catch (e, st) {
      developer.log(
        'flush aborted: queue unavailable',
        name: 'habit.flush',
        error: e,
        stackTrace: st,
      );
      return const FlushOutcome(retained: true);
    }

    var accepted = 0;
    var duplicates = 0;
    var rejected = 0;
    var dropped = 0;
    var batches = 0;
    var limit = maxBatch;

    for (var i = 0; i < _maxBatchesPerFlush; i++) {
      final List<ActivityEvent> events;
      try {
        events = await queue.peek(limit: limit);
      } on Object catch (e, st) {
        developer.log(
          'flush aborted: could not read the queue',
          name: 'habit.flush',
          error: e,
          stackTrace: st,
        );
        return FlushOutcome(
          accepted: accepted,
          duplicates: duplicates,
          rejected: rejected,
          dropped: dropped,
          batches: batches,
          retained: true,
        );
      }

      // §4.6 — an empty `events` array is `400 empty_batch`. Never send one.
      if (events.isEmpty) {
        return FlushOutcome(
          accepted: accepted,
          duplicates: duplicates,
          rejected: rejected,
          dropped: dropped,
          batches: batches,
        );
      }

      batches += 1;
      final result = await _send(events);

      switch (result) {
        case _Settled(:final body):
          accepted += body.accepted;
          duplicates += body.duplicates;
          rejected += body.rejected.length;
          _logRejections(body.rejected);
          // Every id sent, not only the ones named in the response: a
          // `200` settles the whole batch (§4.8), and `accepted` and
          // `duplicates` are counts that name nothing.
          await _acknowledge(queue, events);
          // The server may legitimately have fewer rows than we asked for;
          // restore the full batch size after a successful smaller send.
          limit = maxBatch;

        case _TooLarge():
          // Should be unreachable — we never send more than 100 — but a
          // server that disagrees about the cap must not deadlock the
          // queue. Halve and try again; nothing was written.
          limit = limit <= 1 ? 1 : limit ~/ 2;
          developer.log(
            'server refused a batch of ${events.length}; retrying at $limit',
            name: 'habit.flush',
          );
          if (limit <= 1 && events.length <= 1) {
            // One event the server calls too large is not a size problem.
            // Drop it rather than loop.
            dropped += await _acknowledge(queue, events);
          }

        case _ClientBug(:final code, :final status):
          // §4.8 — nothing was written and retrying will not help. Drop the
          // batch so it cannot block the queue, and log it loudly.
          developer.log(
            'dropping ${events.length} events: $status $code is permanent',
            name: 'habit.flush',
          );
          dropped += await _acknowledge(queue, events);

        case _Retainable(:final reason):
          developer.log(
            'keeping ${events.length} events queued: $reason',
            name: 'habit.flush',
          );
          return FlushOutcome(
            accepted: accepted,
            duplicates: duplicates,
            rejected: rejected,
            dropped: dropped,
            batches: batches,
            retained: true,
          );
      }
    }

    // Hit the per-flush ceiling with rows still waiting.
    return FlushOutcome(
      accepted: accepted,
      duplicates: duplicates,
      rejected: rejected,
      dropped: dropped,
      batches: batches,
      retained: true,
    );
  }

  /// POSTs one batch and classifies the outcome.
  Future<_SendResult> _send(List<ActivityEvent> events) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: <String, Object?>{
          'events': [for (final event in events) event.toJson()],
        },
      );
      final body = _EventsResponse.tryParse(response.data, events.length);
      if (body == null) {
        // A 2xx whose body makes no sense is the ambiguous case §4.8 names
        // explicitly: the write may or may not have happened. Keep it.
        return const _Retainable('unparseable 200 body');
      }
      return _Settled(body);
    } on DioException catch (e) {
      return _classify(e);
    } on Object catch (e, st) {
      developer.log(
        'flush failed outside dio',
        name: 'habit.flush',
        error: e,
        stackTrace: st,
      );
      return const _Retainable('unexpected error');
    }
  }

  /// §4.6 and §3 — which failures are permanent and which are worth keeping.
  _SendResult _classify(DioException e) {
    final status = e.response?.statusCode;

    // No response at all: timeout, DNS, socket, cancelled. Unknown whether
    // the server wrote it. Keep.
    if (status == null) return _Retainable('${e.type.name}: ${e.message}');

    // §3 — the interceptor has already refreshed and retried once by the
    // time this surfaces, so a 401 here is terminal for now. The events are
    // still valid; keep them for after the user signs in again.
    if (status == 401) return const _Retainable('401 after refresh');

    // §4.6 — retry the whole batch with backoff. Safe: idempotency makes it
    // free. The retry interceptor has already spent its two attempts.
    if (status >= 500) return _Retainable('$status');

    if (status == 400) {
      final code = _codeOf(e.response?.data);
      if (code == 'batch_too_large') return const _TooLarge();
      return _ClientBug(code: code ?? 'unknown', status: status);
    }

    // 403, 404, 429 and anything else unforeseen. Not a client bug we can
    // fix by dropping data, and not something a resend makes worse.
    return _Retainable('$status');
  }

  Future<int> _acknowledge(
    LocalEventQueue queue,
    List<ActivityEvent> events,
  ) async {
    try {
      return await queue.acknowledge([
        for (final event in events) event.clientEventId,
      ]);
    } on Object catch (e, st) {
      // The rows stay. They will be re-sent and the server will call them
      // duplicates, which costs bytes and nothing else.
      developer.log(
        'could not acknowledge ${events.length} settled events',
        name: 'habit.flush',
        error: e,
        stackTrace: st,
      );
      return 0;
    }
  }

  /// §4.5 — every rejection is permanent and preventable, so each one is a
  /// client bug. Logged individually; Task 1.14 sends them to analytics.
  void _logRejections(List<_Rejection> rejections) {
    for (final rejection in rejections) {
      developer.log(
        'event ${rejection.clientEventId} rejected permanently: '
        '${rejection.code} — ${rejection.message}',
        name: 'habit.flush',
      );
    }
  }

  static String? _codeOf(Object? data) {
    if (data is Map && data['code'] is String) return data['code'] as String;
    return null;
  }
}

// ---------------------------------------------------------------------------
// Response parsing and outcome classification.
// ---------------------------------------------------------------------------

/// §4.4's success body.
class _EventsResponse {
  const _EventsResponse({
    required this.accepted,
    required this.duplicates,
    required this.rejected,
  });

  /// Parses, or returns null if the body is not §4.4's shape.
  ///
  /// Strict on purpose. A body we cannot read is the ambiguous case, and
  /// §4.8 says keep the batch rather than guess — a lenient parse that
  /// defaulted the counts to zero would acknowledge rows on the strength of
  /// a response it did not understand.
  static _EventsResponse? tryParse(Object? data, int sent) {
    if (data is! Map) return null;
    final accepted = data['accepted'];
    final duplicates = data['duplicates'];
    final rejected = data['rejected'];
    if (accepted is! int || duplicates is! int || rejected is! List) {
      return null;
    }
    final parsed = <_Rejection>[];
    for (final entry in rejected) {
      if (entry is! Map) return null;
      parsed.add(
        _Rejection(
          clientEventId: entry['clientEventId']?.toString() ?? '?',
          code: entry['code']?.toString() ?? 'unknown',
          message: entry['message']?.toString() ?? '',
        ),
      );
    }
    // §4.4 — `accepted + duplicates + rejected.length` always equals what
    // was sent. If it does not, this is not the response to our request and
    // deleting rows on the strength of it would lose events.
    if (accepted + duplicates + parsed.length != sent) return null;
    return _EventsResponse(
      accepted: accepted,
      duplicates: duplicates,
      rejected: parsed,
    );
  }

  final int accepted;
  final int duplicates;
  final List<_Rejection> rejected;
}

class _Rejection {
  const _Rejection({
    required this.clientEventId,
    required this.code,
    required this.message,
  });

  final String clientEventId;
  final String code;
  final String message;
}

sealed class _SendResult {
  const _SendResult();
}

/// `200` — the batch is settled and every id in it leaves the queue.
class _Settled extends _SendResult {
  const _Settled(this.body);
  final _EventsResponse body;
}

/// `400 batch_too_large` — nothing written, re-chunk and retry.
class _TooLarge extends _SendResult {
  const _TooLarge();
}

/// A permanent whole-request failure. Nothing written, retrying cannot help.
class _ClientBug extends _SendResult {
  const _ClientBug({required this.code, required this.status});
  final String code;
  final int status;
}

/// Unknown or transient. The batch stays exactly where it is.
class _Retainable extends _SendResult {
  const _Retainable(this.reason);
  final String reason;
}

/// The app's flusher.
@Riverpod(keepAlive: true)
ActivityFlusher activityFlusher(Ref ref) => ActivityFlusher(
  dio: ref.watch(dioProvider),
  queue: ref.watch(localEventQueueProvider.future),
);
