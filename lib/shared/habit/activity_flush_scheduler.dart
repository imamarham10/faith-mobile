/// When the queue gets sent.
///
/// Task 1.12. [ActivityFlusher] knows *how* to send; this knows *when*, and
/// the two are separate so the sending logic can be tested headlessly
/// without a widget tree, a lifecycle or a platform channel in sight.
///
/// ## Three triggers, and why each exists
///
/// 1. **App resume.** The cheapest reliable moment: the user is present,
///    the OS has just given the process CPU, and anything recorded while the
///    app was backgrounded is waiting. Also covers the common offline case
///    — the user walks back into signal with the app in the background and
///    the flush lands on the next open.
/// 2. **Connectivity return.** Resume alone leaves a user who never
///    backgrounds the app with a queue that never drains: they turn
///    aeroplane mode off, keep reading, and nothing syncs for an hour. The
///    transition from "no connectivity" to "some connectivity" is the exact
///    moment to retry.
/// 3. **Shortly after a record.** The first two together still miss the
///    plain case of a long foreground session on good wifi — read fifty
///    verses, never background the app, and none of it reaches the server.
///    [debounce] collapses a burst of taps into one request, so a dhikr
///    counter tapped a hundred times sends one batch and not a hundred.
///
/// All three go through [ActivityFlusher.flush], which is single-flight, so
/// a resume that coincides with connectivity returning makes one request.
///
/// ## Nothing here reports failure to the user
///
/// A flush failing is the normal state of an offline app, not an error. The
/// queue is durable and the events are not lost, so a message would be both
/// alarming and useless. Failures are logged; the UI shows queued events as
/// progress regardless, which is the whole point of recording locally.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity_flusher.dart';

/// Mounts near the app root and drives [ActivityFlusher] from app lifecycle
/// and connectivity. Renders [child] verbatim — a side-effect carrier, not
/// a layout widget.
class ActivityFlushScope extends ConsumerStatefulWidget {
  /// Wraps [child].
  const ActivityFlushScope({super.key, required this.child});

  /// How long a burst of records is collapsed before sending. Long enough
  /// that a counter being tapped repeatedly produces one request, short
  /// enough that a single verse reaches the server while the user is still
  /// looking at the screen.
  static const Duration debounce = Duration(seconds: 3);

  /// The subtree.
  final Widget child;

  @override
  ConsumerState<ActivityFlushScope> createState() => _ActivityFlushScopeState();
}

class _ActivityFlushScopeState extends ConsumerState<ActivityFlushScope>
    with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  Timer? _debounce;

  /// Whether the last connectivity report had a usable transport. Only the
  /// *transition* into connectivity triggers a flush: Android emits
  /// connectivity events generously (a wifi scan, a cell handover), and
  /// flushing on every one would hammer the endpoint while already online.
  bool _wasOnline = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenToConnectivity();
    // A queue can survive a kill, so there may be rows waiting from a
    // previous run before any lifecycle event fires.
    _flush('startup');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    unawaited(_connectivity?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _flush('resume');
  }

  void _listenToConnectivity() {
    try {
      _connectivity = Connectivity().onConnectivityChanged.listen(
        _onConnectivity,
        // A plugin that throws on its stream must not take the app with it;
        // resume and the post-record debounce still cover the queue.
        onError: (Object e, StackTrace st) => developer.log(
          'connectivity stream failed',
          name: 'habit.flush',
          error: e,
          stackTrace: st,
        ),
      );
    } on Object catch (e, st) {
      developer.log(
        'could not subscribe to connectivity',
        name: 'habit.flush',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _onConnectivity(List<ConnectivityResult> results) {
    final online =
        results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
    final returned = online && !_wasOnline;
    _wasOnline = online;
    if (returned) _flush('connectivity');
  }

  /// Requests a flush [ActivityFlushScope.debounce] from now, restarting the
  /// timer if one is already pending.
  void requestDebouncedFlush() {
    _debounce?.cancel();
    _debounce = Timer(ActivityFlushScope.debounce, () => _flush('record'));
  }

  void _flush(String reason) {
    if (!mounted) return;
    // Fire-and-forget: `flush()` never throws and nothing on screen waits
    // for it. The queue is the durable part.
    unawaited(
      ref.read(activityFlusherProvider).flush().then((outcome) {
        if (outcome.batches > 0) {
          developer.log('flush ($reason): $outcome', name: 'habit.flush');
        }
        // The server now knows something it did not before, so whatever is
        // rendering from a cached `/today` is out of date — and, worse,
        // the queue rows that were covering for it have just been deleted.
        // Without this the Today screen can drop a number it was already
        // showing: the local overlay disappears with the rows while the
        // cached snapshot still predates them, and the user watches their
        // dhikr count fall back to zero a second after it synced.
        if (outcome.accepted > 0 && mounted) {
          ref.read(activityFlushCompletedProvider.notifier).bump();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilt whenever a record lands so the debounce timer restarts. The
    // notifier is an int counter, so this is one rebuild of a widget that
    // renders its child verbatim — no subtree work.
    ref.listen(activityFlushRequestProvider, (_, __) {
      requestDebouncedFlush();
    });
    return widget.child;
  }
}

/// Bumped by [ActivityRecorder] every time an event is durably queued.
///
/// An integer counter rather than a callback handed to the recorder: the
/// recorder is constructed synchronously from a provider and must keep
/// knowing nothing about the network, and a counter keeps the dependency
/// pointing the right way — the scheduler watches the recorder's output
/// rather than the recorder reaching for the scheduler.
class ActivityFlushRequest extends Notifier<int> {
  @override
  int build() => 0;

  /// Signals that something was recorded and a flush is worth scheduling.
  void poke() => state = state + 1;
}

/// The counter the scheduler listens to.
final activityFlushRequestProvider =
    NotifierProvider<ActivityFlushRequest, int>(ActivityFlushRequest.new);

/// Bumped after a flush in which the server **accepted** something.
///
/// Watched by whatever holds a cached `/today`, which must re-read: the
/// queue rows that were being overlaid are gone, so a snapshot older than
/// the flush now under-reports by exactly the amount that just synced.
///
/// Only `accepted` counts. A flush that was all duplicates told the server
/// nothing new and a refetch would return what is already on screen.
class ActivityFlushCompleted extends Notifier<int> {
  @override
  int build() => 0;

  /// Signals that the server's projection has moved.
  void bump() => state = state + 1;
}

/// The counter a cached snapshot watches.
final activityFlushCompletedProvider =
    NotifierProvider<ActivityFlushCompleted, int>(ActivityFlushCompleted.new);
