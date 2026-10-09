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
class WeekStrip extends StatelessWidget {
  const WeekStrip({super.key, required this.week});

  final List<DayProgress> week;

  /// Diameter at the narrowest supported width. 320 − 2×20 screen edge
  /// leaves 280 logical pixels for seven cells, so the ring has to stay
  /// under 40 including its gap.
  static const double _ringSize = 32;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final day in week)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
              child: _DayRing(day: day, isToday: day == week.last),
            ),
          ),
      ],
    );
  }
}

class _DayRing extends StatelessWidget {
  const _DayRing({required this.day, required this.isToday});

  final DayProgress day;
  final bool isToday;

  /// Single-letter weekday, derived from the date itself rather than from a
  /// fixed M–S list, because the strip is a rolling window and so starts on
  /// a different weekday every day.
  static const _initials = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final letter = _initials[day.day.weekday - 1];

    final label = isToday ? 'Today' : letter;

    return Semantics(
      label:
          '$label, ${day.done} of ${day.target}'
          '${day.isComplete ? ', complete' : ''}',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MilestoneRing(
            progress: day.fraction,
            size: WeekStrip._ringSize,
            strokeWidth: 3,
            child: day.isComplete
                ? Icon(Icons.check, size: 15, color: palette.primary)
                : Text(
                    letter,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: day.done > 0 ? palette.ink : palette.inkMuted,
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
