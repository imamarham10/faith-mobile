import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../controllers/daily_verse_controller.dart';
import 'verse_card.dart';

/// "Verse for today" — the rotating replacement for what was, until now, a
/// single Arabic string literal baked into `today_screen.dart`.
///
/// Renders all four states, mirroring [DailyHadithCard].
class DailyVerseCard extends ConsumerWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dailyVerseProvider);
    return async.when(
      loading: () => const PoppySkeleton(height: 200),
      error: (_, __) => _ErrorCard(
        onRetry: () {
          HapticFeedback.heavyImpact();
          ref.invalidate(dailyVerseProvider);
        },
      ),
      data: (verse) => VerseCard(
        arabic: verse.arabic,
        translation: verse.translation,
        reference: verse.reference,
        onTap: () => context.push(
          '/quran/surah/${verse.ref.surahId}?ayah=${verse.ref.verseNumber}',
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
    return PoppyCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.sm),
          Text(
            "Couldn't load today's verse.",
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
