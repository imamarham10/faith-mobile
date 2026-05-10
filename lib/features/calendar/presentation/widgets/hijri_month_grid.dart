import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../controllers/calendar_controller.dart';

/// 7×6 grid rendering [HijriDayCell]s in the active calendar mode.
///
/// Each cell shows the day-number for the active mode (Hijri-day in Hijri
/// mode, Gregorian-day in Gregorian mode) and a small gold dot if events fall
/// on that day.
class HijriMonthGrid extends StatelessWidget {
  const HijriMonthGrid({
    super.key,
    required this.cells,
    required this.mode,
    required this.onDayTap,
  });

  final List<HijriDayCell> cells;
  final CalendarMode mode;
  final ValueChanged<HijriDayCell> onDayTap;

  static const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      children: [
        Row(
          children: _weekdayLabels
              .map(
                (l) => Expanded(
                  child: SizedBox(
                    height: 28,
                    child: Center(
                      child: Text(
                        l,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (_, i) => _DayCell(
            cell: cells[i],
            mode: mode,
            onTap: () => onDayTap(cells[i]),
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.cell, required this.mode, required this.onTap});

  final HijriDayCell cell;
  final CalendarMode mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final today = DateTime.now();
    final isToday =
        cell.gregorianDate.year == today.year &&
        cell.gregorianDate.month == today.month &&
        cell.gregorianDate.day == today.day;

    final dayLabel = mode == CalendarMode.hijri
        ? '${cell.hijriDay}'
        : '${cell.gregorianDate.day}';

    final mutedText = !cell.inViewMonth;

    final color = isToday
        ? cs.onPrimary
        : mutedText
        ? cs.onSurfaceVariant.withValues(alpha: 0.55)
        : cs.onSurface;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: cell.events.isNotEmpty ? onTap : null,
        child: Ink(
          decoration: BoxDecoration(
            color: isToday ? cs.primary : Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  dayLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (cell.events.isNotEmpty)
                Positioned(
                  bottom: 6,
                  child: SizedBox(
                    width: 4,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isToday ? cs.onPrimary : cs.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
