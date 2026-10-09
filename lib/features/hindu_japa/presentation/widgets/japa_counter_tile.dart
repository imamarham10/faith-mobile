import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/milestone_ring.dart';
import '../../data/dtos/japa_counter.dart';

/// A counter row on the Japa home screen. Mirrors `DhikrCounterTile`
/// structurally, swapping RTL Arabic for LTR Devanagari.
class JapaCounterTile extends StatelessWidget {
  const JapaCounterTile({
    super.key,
    required this.counter,
    required this.onTap,
  });

  final JapaCounter counter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final target = (counter.targetCount ?? 0) > 0 ? counter.targetCount! : 108;
    final progress = (counter.count / target).clamp(0.0, 1.0).toDouble();

    final label = counter.name;
    final meaning = counter.mantraEnglish;
    final sanskrit = counter.mantraSanskrit;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.base,
        AppSpacing.base,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sanskrit != null && sanskrit.isNotEmpty)
                  Text(
                    sanskrit,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sanskritTextStyle(
                      fontSize: 22,
                      height: 1.4,
                      color: cs.onSurface,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (meaning != null && meaning.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    meaning,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                _CountPill(
                  count: counter.count,
                  target: counter.targetCount ?? 0,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          MilestoneRing(
            progress: progress,
            size: 56,
            child: Text(
              '${(progress * 100).round()}%',
              style: theme.textTheme.labelSmall?.copyWith(color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count, required this.target});

  final int count;
  final int target;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: cs.outline),
      ),
      child: Text(
        target > 0 ? '$count / $target' : '$count',
        style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
      ),
    );
  }
}
