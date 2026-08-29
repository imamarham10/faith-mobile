import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/islamic_event.dart';

/// Compact event entry — shows the Hijri date and the event name.
class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event, required this.onTap});

  final IslamicEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    final probe = HijriCalendar()
      ..hYear = HijriCalendar.now().hYear
      ..hMonth = event.hijriMonth
      ..hDay = event.hijriDay;
    final monthName = probe.getLongMonthName();

    return PoppyCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Text(
                  '${event.hijriDay}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: accentText,
                  ),
                ),
                Text(
                  monthName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          const Gap.h(AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: theme.textTheme.titleMedium),
                if (event.nameArabic != null &&
                    event.nameArabic!.isNotEmpty) ...[
                  const Gap(2),
                  Text(event.nameArabic!, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 22),
        ],
      ),
    );
  }
}
