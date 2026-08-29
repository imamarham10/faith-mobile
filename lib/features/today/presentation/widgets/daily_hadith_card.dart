import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../hadiths/data/dtos/hadith.dart';
import '../../../hadiths/presentation/controllers/daily_hadith_controller.dart';

/// "Hadith of the day" card on the Today screen.
///
/// Rendered as a `PoppyCard`, visually mirroring `VerseCard` so it reads as
/// a peer to "Verse for today". Tap pushes to the hadith detail.
/// Renders all four states; never leaves the user staring at an empty box.
class DailyHadithCard extends ConsumerWidget {
  const DailyHadithCard({super.key});

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

class _Content extends ConsumerWidget {
  const _Content({required this.hadith});

  final Hadith hadith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final bookName = hadith.book?.name ?? 'Hadith';
    final header = '${bookName.toUpperCase()} · #${hadith.hadithNumber}';

    return PoppyCard(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/hadiths/${hadith.id}');
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
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              hadith.textArabic,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: arabicTextStyleOf(
                ref,
                fontSize: 22,
                height: 2.0,
                color: cs.onSurface,
              ),
            ),
          ),
          const Gap(AppSpacing.lg),
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
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<FaithThemeExtension>()!;
    return Shimmer.fromColors(
      baseColor: cs.surface,
      // Matches the fill/outline/radius the loaded PoppyCard uses
      // (surfaceContainer -> FaithPalette.surfaceCard; PoppyCard's default
      // radius is 24, cardOutlineWidth is themed) so the shimmer doesn't
      // flash a visibly different card shape than the one it's replacing.
      highlightColor: cs.primaryContainer.withValues(alpha: 0.4),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.outline, width: ext.cardOutlineWidth),
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
    return PoppyCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, color: cs.onSurfaceVariant),
          const Gap(AppSpacing.sm),
          Text(
            'Couldn\'t load today\'s hadith.',
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
