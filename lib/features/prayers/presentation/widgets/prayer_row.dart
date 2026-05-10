import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/prayer_log.dart';

/// Logical role of a row relative to "now" — used to drive tinting.
enum PrayerRowState { past, current, future, informational }

/// Single line in the prayer schedule. Tap → log action sheet.
class PrayerRow extends StatelessWidget {
  const PrayerRow({
    super.key,
    required this.displayName,
    required this.time,
    required this.state,
    required this.log,
    required this.onTap,
    required this.canLog,
  });

  final String displayName;
  final DateTime time;
  final PrayerRowState state;
  final PrayerLog? log;
  final VoidCallback onTap;
  final bool canLog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isCurrent = state == PrayerRowState.current;
    final isPast = state == PrayerRowState.past;
    final isInfo = state == PrayerRowState.informational;

    final bg = isCurrent
        ? cs.primaryContainer
        : isPast
        ? cs.surface
        : cs.surface;
    final textColor = isPast || isInfo ? cs.onSurfaceVariant : cs.onSurface;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: canLog
            ? () {
                HapticFeedback.lightImpact();
                onTap();
              }
            : null,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isCurrent ? cs.primary.withValues(alpha: 0.4) : cs.outline,
              width: isCurrent ? 1.2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.base,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 8,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? cs.primary
                        : isPast
                        ? cs.outline
                        : cs.onSurfaceVariant.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const Gap.h(AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: textColor,
                      ),
                    ),
                    if (isInfo) ...[
                      const Gap(2),
                      Text('Informational', style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              _StatusBadge(log: log, isInfo: isInfo, isCurrent: isCurrent),
              const Gap.h(AppSpacing.md),
              Text(
                DateFormat.jm().format(time),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.log,
    required this.isInfo,
    required this.isCurrent,
  });

  final PrayerLog? log;
  final bool isInfo;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    if (isInfo) return const SizedBox.shrink();

    if (log != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: cs.primary),
            const Gap.h(4),
            Text(
              log!.status.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.primary,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      isCurrent ? 'Tap to log' : '—',
      style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
    );
  }
}
