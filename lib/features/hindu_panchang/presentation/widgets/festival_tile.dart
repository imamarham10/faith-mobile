import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/festival_occurrence.dart';

/// Compact upcoming-festival entry — shows the resolved Gregorian date and
/// the festival name. Mirrors `EventTile`, but the date is already resolved
/// (no local ephemeris probe needed the way calendar derives a Hijri
/// event's Gregorian date from a throwaway `HijriCalendar`).
class FestivalTile extends StatelessWidget {
  const FestivalTile({
    super.key,
    required this.occurrence,
    required this.onTap,
  });

  final FestivalOccurrence occurrence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final festival = occurrence.festival;

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
                  '${occurrence.date.day}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: accentText,
                  ),
                ),
                Text(
                  DateFormat.MMM().format(occurrence.date),
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
                Text(festival.nameEnglish, style: theme.textTheme.titleMedium),
                if ((festival.nameSanskrit ?? '').isNotEmpty) ...[
                  const Gap(2),
                  Text(
                    festival.nameSanskrit!,
                    style: sanskritTextStyle(
                      fontSize: 15,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
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
