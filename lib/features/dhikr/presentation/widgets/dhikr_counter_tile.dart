import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../data/dtos/dhikr_counter.dart';
import 'milestone_ring.dart';

/// A counter row on the Dhikr home screen.
///
/// Shows the Arabic phrase right-aligned, transliteration + meaning below,
/// a count/target pill on the left, and a milestone ring trailing.
class DhikrCounterTile extends ConsumerWidget {
  const DhikrCounterTile({
    super.key,
    required this.counter,
    required this.onTap,
  });

  final DhikrCounter counter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final target = counter.targetCount > 0 ? counter.targetCount : 33;
    final progress = (counter.count / target).clamp(0.0, 1.0).toDouble();

    final transliteration =
        counter.phraseTransliteration ?? counter.phraseEnglish ?? counter.name;
    final meaning = counter.meaning;
    final arabic = counter.phraseArabic;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.base,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (arabic != null && arabic.isNotEmpty)
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          arabic,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: arabicTextStyleOf(
                            ref,
                            fontSize: 22,
                            height: 1.4,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      transliteration,
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
                      target: counter.targetCount,
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
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
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
