import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../hindu_stories/data/dtos/hindu_story.dart';
import '../../../hindu_stories/presentation/controllers/daily_katha_controller.dart';

/// "Katha for today" card on the Hindu Today screen. Mirrors
/// `DailyHadithCard`'s shape and all-four-states handling so it reads as
/// a peer to "Shloka for today", the way "Hadith of the day" reads as a
/// peer to "Verse for today" on the Islam side.
class DailyKathaCard extends ConsumerWidget {
  const DailyKathaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dailyKathaProvider);
    return async.when(
      loading: () => const _Skeleton(),
      error: (_, __) => _ErrorCard(
        onRetry: () {
          HapticFeedback.heavyImpact();
          ref.invalidate(dailyKathaProvider);
        },
      ),
      data: (story) {
        if (story == null) return const SizedBox.shrink();
        return _Content(story: story);
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.story});

  final HinduStory story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final header = (story.collection?.name ?? 'Katha').toUpperCase();

    return PoppyCard(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/hadiths/hindu-stories/${story.id}');
      },
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: theme.textTheme.labelSmall?.copyWith(color: accentText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(AppSpacing.md),
          Text(story.title, style: theme.textTheme.titleLarge),
          const Gap(AppSpacing.sm),
          Text(
            story.summary,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return const PoppySkeleton(height: 160);
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, color: cs.onSurfaceVariant),
          const Gap(AppSpacing.sm),
          Text(
            'Couldn\'t load today\'s katha.',
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
