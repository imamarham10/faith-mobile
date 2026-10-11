import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/milestone_ring.dart';
import '../../domain/today_dashboard.dart';

/// Seven rings — one per day, today last — each filled by how much of that
/// day's goal was met.
///
/// Rings rather than checkboxes: a half-filled ring says "three of five",
/// which is the thing the user actually did, where a checkbox can only say
/// yes or no and so has to call a day with four prayers a failure.
///
/// ## Why it knows how to draw itself before the data arrives
///
/// This strip now sits at the top of Today, above the fold, and the
/// dashboard behind it is a cold network read: `activitySnapshotCache` is
/// in memory only, so on a cold start [WeekStrip] has nothing for the
/// 1–3.5s the two activity reads take. A skeleton pill there would be a
/// shimmering bar directly under the greeting, and it would be replaced by
/// something of a different shape — a flash and a reflow in the first
/// thing the user looks at.
///
/// So the strip draws its own structure instead. **Which seven days they
/// are is local knowledge** — a rolling window ending today needs no
/// server — so [WeekStrip.unknown] renders the real dates, the real
/// weekday letters and the real today-dot at the real size, and only the
/// *progress* is missing. When the dashboard lands, nothing moves: the
/// rings fill from 0 through [MilestoneRing]'s own tween and the strip
/// fades up to full strength.
///
/// ## Why "unknown" is dimmed rather than simply empty
///
/// [MilestoneRing] paints no arc at all for `progress <= 0`, so an unknown
/// ring and a genuine zero-day ring are pixel-identical. Left at full
/// opacity this would tell a user who practised all week that they had
/// done nothing, for as long as the read takes — on the first screen of
/// the app. [_unknownOpacity] is what separates "not yet" from "nothing",
/// and the [Semantics] label says so outright for anyone not reading
/// pixels.
class WeekStrip extends StatelessWidget {
  /// The strip with the week's real progress.
  const WeekStrip({super.key, required List<DayProgress> week})
    : _week = week,
      _today = null;

  /// The strip before the dashboard has answered — or after it has failed
  /// with nothing cached to fall back on.
  ///
  /// Draws the same seven cells at the same size, so swapping to the
  /// loaded strip moves no pixel. [today] exists so a golden can pin the
  /// window; production always wants the default.
  ///
  /// These dates come from device midnight, where the loaded week is walked
  /// back from the server's `localDay` — and
  /// `today_dashboard_controller.dart` tolerates a day of drift between the
  /// two without refetching. So near midnight on a skewed clock the
  /// weekday letters can shift by one cell when the data lands. Accepted:
  /// the cell count, the geometry and the scroll position are unaffected,
  /// and the alternative is holding the strip blank until the server has
  /// said what day it is, which is the flash this constructor exists to
  /// avoid.
  const WeekStrip.unknown({super.key, DateTime? today})
    : _week = null,
      _today = today;

  /// The week's progress, or null when it is not known yet.
  final List<DayProgress>? _week;

  /// Test seam for [WeekStrip.unknown]'s rolling window. Null in the
  /// loaded case, where the dates come from the data.
  final DateTime? _today;

  /// Days shown. Matches `_weekDays` in `today_dashboard_controller.dart`.
  static const int _days = 7;

  /// Diameter at the narrowest supported width. 320 − 2×20 screen edge
  /// leaves 280 logical pixels for seven cells, so the ring has to stay
  /// under 40 including its gap.
  static const double _ringSize = 32;

  /// How faint the strip is while its progress is unknown. Low enough to
  /// read as pending, high enough that the weekday letters stay legible.
  static const double _unknownOpacity = 0.38;

  /// Matches [MilestoneRing]'s own fill tween, so the strip arriving is
  /// one gesture rather than two.
  static const Duration _settle = Duration(milliseconds: 220);

  /// The rolling window ending today, as local midnights.
  ///
  /// Built by calendar arithmetic rather than `subtract(Duration(days: 1))`
  /// so a DST boundary cannot land a cell on 23:00 of the previous day and
  /// shift every weekday letter by one.
  static List<DateTime> _rollingWeek(DateTime now) => [
    for (var i = _days - 1; i >= 0; i--)
      DateTime(now.year, now.month, now.day - i),
  ];

  @override
  Widget build(BuildContext context) {
    final week = _week;
    final days =
        week?.map((d) => d.day).toList() ??
        _rollingWeek(_today ?? DateTime.now());

    return AnimatedOpacity(
      opacity: week == null ? _unknownOpacity : 1,
      duration: _settle,
      curve: Curves.easeOutCubic,
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs / 2,
                ),
                child: _DayRing(
                  day: days[i],
                  progress: week?[i],
                  isToday: i == days.length - 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayRing extends StatelessWidget {
  const _DayRing({
    required this.day,
    required this.progress,
    required this.isToday,
  });

  /// The calendar day this cell stands for. Known with or without the
  /// dashboard, which is the whole reason the unknown strip can be drawn.
  final DateTime day;

  /// How the day went, or null while that is not known. Null is rendered
  /// as an empty ring and said out loud in the semantics label — it is
  /// never rendered as a zero.
  final DayProgress? progress;

  final bool isToday;

  /// Single-letter weekday, derived from the date itself rather than from a
  /// fixed M–S list, because the strip is a rolling window and so starts on
  /// a different weekday every day.
  static const _initials = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final letter = _initials[day.weekday - 1];
    final progress = this.progress;

    final label = isToday ? 'Today' : letter;

    return Semantics(
      label: progress == null
          ? '$label, progress not loaded yet'
          : '$label, ${progress.done} of ${progress.target}'
                '${progress.isComplete ? ', complete' : ''}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MilestoneRing(
            progress: progress?.fraction ?? 0,
            size: WeekStrip._ringSize,
            strokeWidth: 3,
            child: progress != null && progress.isComplete
                ? Icon(Icons.check, size: 15, color: palette.primary)
                : Text(
                    letter,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: (progress?.done ?? 0) > 0
                          ? palette.ink
                          : palette.inkMuted,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // A dot under today rather than a ring of a different colour: the
          // ring's colour already encodes progress and must not also encode
          // which day it is.
          SizedBox(
            height: 4,
            child: isToday
                ? Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.ink,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
