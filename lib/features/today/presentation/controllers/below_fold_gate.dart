import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'below_fold_gate.g.dart';

/// How long the gate waits for the habit loop before opening regardless.
///
/// This is a safety net, not a tuning knob. The gate's real trigger is the
/// habit loop painting; this exists so that a habit loop which never
/// settles — a hung socket, a provider that errors in a way nobody
/// anticipated — cannot leave the cards below it permanently blank. A card
/// that never populates because its fetch was deferred and never
/// retriggered is a worse bug than a slow card, and the deferral must not
/// be able to create one.
///
/// Five seconds: comfortably past the worst habit-loop settle measured
/// against production under contention (~3.4s), and well short of dio's
/// 20s receive timeout, so the net catches the case where the normal error
/// path is still minutes away.
const Duration kBelowFoldDeadline = Duration(seconds: 5);

/// Whether the Today screen's below-the-fold cards may start fetching yet.
///
/// Half of the Today screen's cold-start requests are for content nobody
/// has scrolled to — the verse and hadith on Islam, the shloka and katha on
/// Hindu. They were going out in the same burst as `activity/today` and
/// `activity/history`, which gate the habit loop, and on a `max: 10`
/// serverless pool everything in that burst degrades together: measured
/// against production, eight concurrent requests turned a 0.99s read into
/// 3.49s and a 0.76s read into 6.21s.
///
/// So the below-the-fold reads wait for the thing the user is actually
/// waiting for. [open] is called once the habit loop has painted; the
/// deadline above is the backstop.
///
/// **Session-scoped and one-way.** Once open it stays open, so this costs
/// nothing on a tab switch back to Today or any later rebuild — it is a
/// cold-start measure and only a cold start pays it. `keepAlive` is what
/// makes that true: an auto-disposed gate would slam shut every time the
/// Today branch was torn down and re-defer content the user has already
/// seen.
@Riverpod(keepAlive: true)
class BelowFoldGate extends _$BelowFoldGate {
  /// Live only while the gate is shut. See [open].
  Timer? _deadline;

  @override
  bool build() {
    // Starts on first read, which is the Today screen's first build — the
    // same frame the deferral begins.
    _deadline = Timer(kBelowFoldDeadline, open);
    ref.onDispose(() => _deadline?.cancel());
    return false;
  }

  /// Lets the below-the-fold cards start fetching. Idempotent, and never
  /// reversed — see the note on one-wayness above.
  void open() {
    if (state) return;
    // The deadline has nothing left to do once the gate is open, and a
    // timer that can no longer have an effect is still a timer: it keeps
    // the widget tree's test binding reporting pending work for five
    // seconds after every Today-screen test, and holds a reference to this
    // notifier for five seconds in the app.
    _deadline?.cancel();
    _deadline = null;
    state = true;
  }
}
