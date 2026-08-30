import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/puja_log.dart';

/// Modal bottom sheet for choosing how to log a sandhya. Mirrors
/// `showLogActionSheet` (prayers), but 3 statuses map 1:1 to this backend's
/// `on_time`/`late`/`missed` enum — no qaḍāʾ/make-up-later framing needed.
Future<PujaStatus?> showPujaLogActionSheet(
  BuildContext context, {
  required String sandhyaDisplayName,
}) {
  return showModalBottomSheet<PujaStatus>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _LogActionSheetContent(sandhyaDisplayName: sandhyaDisplayName),
  );
}

class _LogActionSheetContent extends StatelessWidget {
  const _LogActionSheetContent({required this.sandhyaDisplayName});

  final String sandhyaDisplayName;

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
          Text(
            'Log $sandhyaDisplayName',
            style: theme.textTheme.headlineMedium,
          ),
          const Gap(AppSpacing.xs),
          Text('How did your puja go today?', style: theme.textTheme.bodyMedium),
          const Gap(AppSpacing.xl),
          _ActionTile(
            icon: Icons.check_circle_outline,
            title: 'On time',
            subtitle: 'Performed within the window',
            color: theme.colorScheme.primary,
            mascot: const MascotView(
              faith: FaithId.hindu,
              state: MascotState.celebrate,
              size: 40,
            ),
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(PujaStatus.onTime);
            },
          ),
          const Gap(AppSpacing.sm),
          _ActionTile(
            icon: Icons.schedule_outlined,
            title: 'Late',
            subtitle: 'Performed but not on time',
            color: accentText,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(PujaStatus.late_);
            },
          ),
          const Gap(AppSpacing.sm),
          _ActionTile(
            icon: Icons.remove_circle_outline,
            title: 'Missed',
            subtitle: 'Didn\'t perform today',
            color: theme.colorScheme.onSurfaceVariant,
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop(PujaStatus.missed);
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
    this.mascot,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final Widget? mascot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PoppyCard(
      radius: AppRadius.lg,
      onTap: onTap,
      child: Row(
        children: [
          mascot ?? Icon(icon, color: color, size: 24),
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
    );
  }
}
