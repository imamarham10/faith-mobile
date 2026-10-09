import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../controllers/panchang_month_controller.dart';

/// 7×6 grid rendering [PanchangDayCell]s. Mirrors `HijriMonthGrid`
/// structurally, minus the Hijri/Gregorian mode split (panchang is
/// Gregorian-native) and minus calendar's "only tap if events" restriction
/// — every in-month day has real panchang data worth opening, not just
/// festival days.
class PanchangMonthGrid extends StatelessWidget {
  const PanchangMonthGrid({
    super.key,
    required this.cells,
    required this.onDayTap,
  });

  final List<PanchangDayCell> cells;
  final ValueChanged<PanchangDayCell> onDayTap;

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
          itemBuilder: (_, i) =>
              _DayCell(cell: cells[i], onTap: () => onDayTap(cells[i])),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.cell, required this.onTap});

  final PanchangDayCell cell;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final today = DateTime.now();
    final isToday =
        cell.date.year == today.year &&
        cell.date.month == today.month &&
        cell.date.day == today.day;

    final mutedText = !cell.inViewMonth;
    final hasFestival = cell.panchangDay?.festivals.isNotEmpty ?? false;

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
        onTap: onTap,
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
                  '${cell.date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (hasFestival)
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
