import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/hadith.dart';
import '../controllers/daily_hadith_controller.dart';
import 'hadith_arabic_block.dart';
import 'hadith_list_tile.dart';

/// Hero card surfaced on both the Today screen and the Hadiths home top.
///
/// All four states are handled in one widget so the layout is consistent
/// wherever it appears: shimmer, error retry, no-data fallback, content.
class DailyHadithHero extends ConsumerWidget {
  const DailyHadithHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dailyHadithProvider);
    return async.when(
      loading: () => const _Skeleton(),
      error: (_, __) => _ErrorCard(
        onRetry: () {
          HapticFeedback.heavyImpact();
          ref.invalidate(dailyHadithProvider);
        },
      ),
      data: (hadith) {
        if (hadith == null) return const SizedBox.shrink();
        return _Content(hadith: hadith);
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.hadith});

  final Hadith hadith;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bookName = hadith.book?.name ?? 'Hadith';

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/hadiths/${hadith.id}');
        },
        child: Ink(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${bookName.toUpperCase()} · #${hadith.hadithNumber}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if ((hadith.grade ?? '').isNotEmpty) ...[
                    const Gap.h(AppSpacing.sm),
                    GradeChip(grade: hadith.grade!),
                  ],
                ],
              ),
              const Gap(AppSpacing.base),
              HadithArabicBlock(
                text: hadith.textArabic,
                fontSize: 22,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(AppSpacing.base),
              Container(
                width: 40,
                height: 1,
                color: cs.secondary.withValues(alpha: 0.4),
              ),
              const Gap(AppSpacing.base),
              Text(
                hadith.textEnglish,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  height: 1.55,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.surface,
      highlightColor: cs.primaryContainer.withValues(alpha: 0.4),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: cs.outline),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outline),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cloud_off_outlined, color: cs.onSurfaceVariant),
          const Gap(AppSpacing.sm),
          Text(
            'Couldn\'t load today\'s hadith.',
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
