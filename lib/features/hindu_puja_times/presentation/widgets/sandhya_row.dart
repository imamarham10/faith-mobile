import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/puja_log.dart';
import '../../data/dtos/puja_times.dart';

enum SandhyaRowState { past, current, future }

/// One sandhya row — displayed name, its window, and log status. Mirrors
/// `PrayerRow`, minus the `informational` state (puja has no Sunrise-style
/// non-loggable row; all three sandhyas are loggable).
class SandhyaRow extends StatelessWidget {
  const SandhyaRow({
    super.key,
    required this.sandhya,
    required this.state,
    required this.log,
    required this.onTap,
  });

  final SandhyaInfo sandhya;
  final SandhyaRowState state;
  final PujaLog? log;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final muted = state == SandhyaRowState.past;

    return PoppyCard(
      radius: AppRadius.lg,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sandhya.nameSanskrit,
                  style: sanskritTextStyle(
                    fontSize: 18,
                    color: muted ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormat.jm().format(sandhya.band.start)} – '
                  '${DateFormat.jm().format(sandhya.band.end)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _StatusBadge(state: state, log: log),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.state, required this.log});

  final SandhyaRowState state;
  final PujaLog? log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    if (log != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: cs.primary),
            const SizedBox(width: 4),
            Text(
              log!.status.label,
              style: theme.textTheme.labelSmall?.copyWith(color: cs.primary),
            ),
          ],
        ),
      );
    }

    if (state == SandhyaRowState.current) {
      return Text(
        'Tap to log',
        style: theme.textTheme.labelMedium?.copyWith(color: accentText),
      );
    }

    return Text(
      '—',
      style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant),
    );
  }
}
