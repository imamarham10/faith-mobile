import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../hadiths/data/dtos/hadith.dart';
import '../../../hadiths/presentation/controllers/daily_hadith_controller.dart';

/// "Hadith of the day" card on the Today screen.
///
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

/// Splits a Bukhari-style English narration into its attribution clause and
/// the teaching itself.
///
/// The corpus renders these as `Narrated \`Aisha:Sa\`d was wounded…` — one
/// short clause, then the matn, frequently with no space after the colon.
/// Returns `(null, whole)` whenever the shape is not recognised, so an entry
/// that does not follow the convention degrades to simply showing all of it.
@visibleForTesting
({String? narrator, String matn}) splitNarration(String english) {
  const maxAttributionLength = 80;
  final text = english.trim();
  if (!text.startsWith('Narrated')) return (narrator: null, matn: text);

  final colon = text.indexOf(':');
  if (colon < 0 || colon > maxAttributionLength) {
    return (narrator: null, matn: text);
  }

  final matn = text.substring(colon + 1).trim();
  if (matn.isEmpty) return (narrator: null, matn: text);

  return (narrator: text.substring(0, colon).trim(), matn: matn);
}

class _Content extends ConsumerStatefulWidget {
  const _Content({required this.hadith});

  final Hadith hadith;

  @override
  ConsumerState<_Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_Content> {
  bool _showSource = false;

  void _toggleSource() {
    HapticFeedback.selectionClick();
    setState(() => _showSource = !_showSource);
  }

  @override
  Widget build(BuildContext context) {
    final hadith = widget.hadith;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    final bookName = hadith.book?.name ?? 'Hadith';
    final header = '${bookName.toUpperCase()} · #${hadith.hadithNumber}';
    final narration = splitNarration(hadith.textEnglish);

    return PoppyCard(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/hadiths/${hadith.id}');
      },
      padding: const EdgeInsets.all(AppSpacing.xl),
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

          // The teaching leads. "Scripture leads, translation collapses" is
          // the right rule for Qur'an and Gita, where the Arabic/Sanskrit is
          // itself the revealed text. It is the wrong rule here: the raw
          // Bukhari corpus bakes the isnad — the chain of transmission —
          // into `textArabic`, so leading with it put six narrators' names
          // above the fold and the actual teaching below it. Confirmed on
          // device. The isnad is scholarly provenance and stays one tap
          // away; it is not the headline.
          if (narration.narrator != null) ...[
            Text(
              narration.narrator!.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(AppSpacing.sm),
          ],
          Text(
            narration.matn,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurface,
              height: 1.5,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),

          const Gap(AppSpacing.base),
          _SourceToggle(expanded: _showSource, onTap: _toggleSource),

          AnimatedSize(
            duration: AppMotion.cardSpringBack,
            curve: AppMotion.enterCurve,
            alignment: Alignment.topCenter,
            child: _showSource
                ? _SourceText(hadith: hadith)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// The disclosure control. Sits inside the card's own tap target, so it
/// carries its own recogniser — the innermost wins the gesture arena, which
/// is what keeps "show the chain" from navigating away to the detail screen.
class _SourceToggle extends StatelessWidget {
  const _SourceToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Semantics(
      button: true,
      expanded: expanded,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          // Lifts the row to a 44pt-tall target without moving the text.
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                expanded ? 'Hide Arabic & chain' : 'Arabic & chain',
                style: theme.textTheme.labelMedium?.copyWith(color: muted),
              ),
              const Gap.h(AppSpacing.xs),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: AppMotion.cardSpringBack,
                curve: AppMotion.enterCurve,
                child: Icon(Icons.expand_more, size: 18, color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceText extends ConsumerWidget {
  const _SourceText({required this.hadith});

  final Hadith hadith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // `narratorChain` is a separate column in the schema but is null across
    // the imported Bukhari corpus — the chain only exists inside
    // `textArabic`. Rendered when present rather than assumed absent.
    final chain = hadith.narratorChainArabic ?? hadith.narratorChain;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 1,
          color: cs.secondary.withValues(alpha: 0.4),
        ),
        const Gap(AppSpacing.base),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            hadith.textArabic,
            textAlign: TextAlign.right,
            style: arabicTextStyleOf(
              ref,
              fontSize: 20,
              height: 2.0,
              color: cs.onSurface,
            ),
          ),
        ),
        if (chain != null && chain.trim().isNotEmpty) ...[
          const Gap(AppSpacing.md),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              chain,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
        if (hadith.grade != null) ...[
          const Gap(AppSpacing.md),
          Text(
            hadith.grade!.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    // PoppySkeleton matches PoppyCard's shape at its own default radius (24)
    // — same as the loaded _Content card — so the loading state never
    // flashes a visibly different silhouette than what replaces it.
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
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, color: cs.onSurfaceVariant),
          const Gap(AppSpacing.sm),
          Text(
            "Couldn't load today's hadith.",
            style: theme.textTheme.bodyLarge,
          ),
          const Gap(AppSpacing.md),
          PoppyButton(label: 'Try again', onPressed: onRetry),
        ],
      ),
    );
  }
}
