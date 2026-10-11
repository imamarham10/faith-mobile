import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/below_fold_gate.dart';
import '../controllers/today_dashboard_controller.dart';
import 'week_strip.dart';

/// The week strip, wired to the dashboard — and **the sole owner of the
/// below-the-fold gate's release**.
///
/// Built once for both faiths, like the rest of the habit loop: everything
/// faith-specific reaches [WeekStrip] through [TodayDashboard].
///
/// ## Why the gate release lives here and nowhere else
///
/// It used to live in `TodayProgressSection`, when that widget was the
/// whole habit loop — strip, goal card, checklist, tiles — and was the
/// first thing on the screen to render dashboard data. Lifting the strip
/// to the top of Today broke both halves of that: the section is no longer
/// first, and it now sits below continue-reading and a full-width
/// featured collection, far enough down that **whether it is built on the
/// first frame is a question about the sliver's cache extent** rather than
/// a guarantee. A gate owned by a widget that can fall out of the build
/// range is a gate that can only open on its five-second deadline, which
/// would make every cold start pay the backstop.
///
/// This widget cannot have that problem. It is the topmost thing on Today
/// that reads the dashboard and it is pinned above the fold, so it is
/// built on the first frame under any viewport the app supports. It is
/// also no *earlier* a signal than the old one: both widgets read the same
/// memoised provider, so they settle in the same frame — only the
/// reliability changed, not the timing.
///
/// `TodayProgressSection` deliberately no longer touches the gate at all.
/// Two releasers would be two things to keep in step, and the one that
/// fired first would silently make the other dead code.
class WeekStripSection extends ConsumerStatefulWidget {
  const WeekStripSection({super.key});

  @override
  ConsumerState<WeekStripSection> createState() => _WeekStripSectionState();
}

class _WeekStripSectionState extends ConsumerState<WeekStripSection> {
  /// Releases the cards below the habit loop once it has drawn.
  ///
  /// Scheduled rather than called inline: this runs from `build`, and
  /// moving provider state during a build is exactly what Riverpod
  /// forbids. The post-frame callback also makes the signal literally
  /// true — it fires after the frame carrying the loop has been painted,
  /// not merely after its data arrived.
  ///
  /// Both settled states open it. An error is as final as data: the loop
  /// is done asking, so there is no longer anything for the cards below to
  /// yield to, and leaving them deferred because the habit loop failed
  /// would blank the whole screen instead of one card.
  void _releaseBelowFold() {
    if (ref.read(belowFoldGateProvider)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(belowFoldGateProvider.notifier).open();
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(todayDashboardProvider);
    if (!async.isLoading) _releaseBelowFold();
    // `valueOrNull` rather than `when`: an error that still carries the
    // last good response — a failed refresh over a warm cache — keeps
    // showing the real week. Only a genuine absence falls back to the
    // unknown strip, and the error itself is reported once, by the card
    // below. Two error affordances for one failed read, one of them at the
    // top of the screen, is worse than the failure.
    final week = async.valueOrNull?.week;
    return week == null
        ? const WeekStrip.unknown()
        : WeekStrip(week: week);
  }
}
