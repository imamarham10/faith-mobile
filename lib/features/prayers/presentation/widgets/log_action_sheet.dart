import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/prayer_log.dart';

/// Modal bottom sheet for choosing how to log a prayer.
///
/// Returns the selected [PrayerStatus] or `null` on dismiss.
Future<PrayerStatus?> showLogActionSheet(
  BuildContext context, {
  required String prayerDisplayName,
}) {
  return showModalBottomSheet<PrayerStatus>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (ctx) =>
        _LogActionSheetContent(prayerDisplayName: prayerDisplayName),
  );
}

class _LogActionSheetContent extends StatelessWidget {
  const _LogActionSheetContent({required this.prayerDisplayName});

  final String prayerDisplayName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log $prayerDisplayName', style: theme.textTheme.headlineMedium),
          const Gap(AppSpacing.xs),
          Text('How did you pray today?', style: theme.textTheme.bodyMedium),
          const Gap(AppSpacing.xl),
          _ActionTile(
            icon: Icons.check_circle_outline,
            title: 'On time',
            subtitle: 'Prayed within its window',
            color: theme.colorScheme.primary,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(PrayerStatus.onTime);
            },
          ),
          const Gap(AppSpacing.sm),
          _ActionTile(
            icon: Icons.schedule_outlined,
            title: 'Late',
            subtitle: 'Prayed but not on time',
            color: accentText,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(PrayerStatus.late);
            },
          ),
          const Gap(AppSpacing.sm),
          _ActionTile(
            icon: Icons.history_toggle_off_outlined,
            title: 'Qaḍāʾ',
            subtitle: 'Missed — make up later',
            color: theme.colorScheme.onSurfaceVariant,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(PrayerStatus.qada);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.base,
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Gap.h(AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const Gap(2),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
