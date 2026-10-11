import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../core/theme/sanskrit_text.dart';
import '../../../../shared/reader/reading_mode_controller.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../hindu_scriptures/data/dtos/scripture_verse.dart';
import '../../../hindu_scriptures/domain/chapter_reading_route.dart';
import '../../../hindu_scriptures/presentation/controllers/daily_shloka_controller.dart';

/// "Shloka for today" card on the Hindu Today screen. Mirrors
/// `DailyHadithCard`'s shape and all-four-states handling; visually a
/// Sanskrit/LTR (`sanskritTextStyle()`, no RTL wrapper) peer to
/// `VerseCard`, the way "Shloka for today" reads as a peer to "Verse for
/// today" on the Islam side.
class DailyShlokaCard extends ConsumerWidget {
  const DailyShlokaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dailyShlokaProvider);
    return async.when(
      loading: () => const _Skeleton(),
      error: (_, __) => _ErrorCard(
        onRetry: () {
          HapticFeedback.heavyImpact();
          ref.invalidate(dailyShlokaProvider);
        },
      ),
      data: (verse) {
        if (verse == null) return const SizedBox.shrink();
        return _Content(verse: verse);
      },
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.verse});

  final ScriptureVerse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final translation = verse.translations.isNotEmpty
        ? verse.translations.first.text
        : '';
    final textName = verse.text?.nameEnglish ?? 'Bhagavad Gita';
    final chapterNumber = verse.chapter?.chapterNumber;
    final reference = chapterNumber == null
        ? textName
        : '$textName $chapterNumber.${verse.verseNumber}';

    return PoppyCard(
      onTap: verse.text == null || verse.chapter == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              context.push(
                chapterReadingRoute(
                  verse.text!.slug,
                  verse.chapter!.chapterNumber,
                  mode: activeReadingMode(ref),
                  verse: verse.verseNumber,
                ),
              );
            },
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            verse.sanskritText,
            style: sanskritTextStyle(
              fontSize: 20,
              height: 1.7,
              color: cs.onSurface,
            ),
          ),
          const Gap(20),
          Container(
            width: 40,
            height: 1,
            color: cs.secondary.withValues(alpha: 0.4),
          ),
          const Gap(16),
          Text(translation, style: theme.textTheme.bodyLarge),
          const Gap(12),
          Text(
            reference.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(color: accentText),
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
    return const PoppySkeleton(height: 200);
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
            'Couldn\'t load today\'s shloka.',
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
