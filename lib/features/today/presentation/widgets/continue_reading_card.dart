import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/reader/reading_mode_controller.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../hindu_scriptures/presentation/controllers/hindu_scriptures_home_controller.dart';
import '../../../quran/presentation/controllers/quran_home_controller.dart';
import '../../domain/continue_reading.dart';

/// Today's primary element: where the reader left off, and one tap back to
/// it.
///
/// ## Why it is the first thing on the screen
///
/// Reading is the act the whole app exists to support, and the single
/// highest-value thing a returning user can do is resume it. Every other
/// block on Today reports on a practice; this one *is* the practice. It
/// therefore sits above the habit loop — above the week strip, the goal
/// card and the checklist — which is the one piece of the reference
/// hierarchy worth taking literally.
///
/// ## Why it costs nothing to put there
///
/// Everything it renders comes out of `shared_preferences`: the pointer and
/// the display context the readers persist beside it (see [LastRead]). It
/// watches no network provider, so being above the habit loop does not put
/// a request ahead of the two activity reads the loop waits on. That is
/// load-bearing, not incidental — `below_fold_deferral_test.dart` asserts
/// the surah index, the scripture-text index and the juz index are all
/// still untouched while the loop is in flight.
///
/// ## Why the whole card is the target
///
/// A card in this design system is a button. The large call to action
/// inside it is painted, not pressable: an inner [PoppyButton] would make
/// the card a button-shaped thing whose only live region is the pill in its
/// lower third, which is precisely the anatomy behind this project's
/// repeated dead-click reports. One `onTap`, on the card.
class ContinueReadingCard extends ConsumerWidget {
  const ContinueReadingCard({super.key, required this.faith});

  final FaithId faith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The remembered reader preference, resolved exactly as every other
    // entry point resolves it. The Qur'an tab's own continue-reading card
    // predates this helper and hardcodes the continuous reader's path;
    // that bug is deliberately not carried over here.
    final mode = activeReadingMode(ref);

    // Branching on the whole AsyncValue, not `valueOrNull`: for this
    // pointer `null` means *either* "prefs not read yet" or "nothing stored
    // yet", and conflating them would paint "Start reading · Al-Fatihah"
    // for a frame on every cold start before flipping to the real
    // position — a visible rewrite on the biggest card on the screen.
    // Loading draws nothing, which on a prefs read is a frame or two.
    final ContinueReading? model = switch (faith) {
      FaithId.islam => ref
          .watch(lastReadControllerProvider)
          .maybeWhen(
            data: (lastRead) =>
                islamContinueReading(lastRead: lastRead, mode: mode),
            orElse: () => null,
          ),
      FaithId.hindu => ref
          .watch(scriptureLastReadControllerProvider)
          .maybeWhen(
            data: (lastRead) =>
                hinduContinueReading(lastRead: lastRead, mode: mode),
            orElse: () => null,
          ),
    };

    if (model == null) return const SizedBox.shrink();
    // The trailing gap belongs to the card, not to the screen: a gap left
    // on the list would be 24 orphaned pixels in the frames before prefs
    // resolve, which is exactly the "skeleton that resolves to nothing"
    // this screen refuses everywhere else.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_Card(model: model), const Gap(AppSpacing.xl)],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.model});

  final ContinueReading model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      button: true,
      label: model.semanticLabel,
      // One sentence replaces the subtree: eyebrow, title, chapter,
      // position, juz and CTA read in sequence is six fragments between a
      // screen-reader user and the one action on the card.
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.xl,
        color: cs.primaryContainer,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.base,
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(model.route);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              model.eyebrow.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              model.title,
              style: theme.textTheme.headlineSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (model.subtitle != null) ...[
              const Gap(AppSpacing.xs),
              Text(model.subtitle!, style: theme.textTheme.titleSmall),
            ],
            const Gap(AppSpacing.md),
            _PositionLine(model: model),
            if (model.progress != null) ...[
              const Gap(AppSpacing.sm),
              _PositionTrack(fraction: model.progress!),
            ],
            const Gap(AppSpacing.lg),
            _CtaPill(label: model.ctaLabel),
          ],
        ),
      ),
    );
  }
}

/// "Verse 151 of 286 · Juz 2" — position first, place second.
///
/// Deliberately a sentence about *this passage* and never about the book:
/// see [ContinueReading] for why no percentage appears anywhere on this
/// card.
class _PositionLine extends StatelessWidget {
  const _PositionLine({required this.model});

  final ContinueReading model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = model.locatorLine == null
        ? model.positionLine
        : '${model.positionLine}  ·  ${model.locatorLine}';
    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// How far into the current surah or chapter the pointer sits.
///
/// Scoped to the passage on purpose. A bar spanning the whole book would
/// claim everything behind the marker had been read, which a pointer does
/// not say — people arrive mid-text from collections, bookmarks, search and
/// mood remedies every day.
class _PositionTrack extends StatelessWidget {
  const _PositionTrack({required this.fraction});

  final double fraction;

  static const double _height = 10;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;

    return SizedBox(
      height: _height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: palette.outline, width: 1.5),
        ),
        // Clipped to the same pill so the fill can never square off the
        // left cap at small fractions.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: fraction,
              heightFactor: 1,
              child: ColoredBox(color: palette.primary),
            ),
          ),
        ),
      ),
    );
  }
}

/// The call to action, painted rather than wired.
///
/// It looks like the biggest button on the screen because it is the
/// screen's biggest action — but the tap belongs to the card around it. See
/// the class doc on [ContinueReadingCard].
class _CtaPill extends StatelessWidget {
  const _CtaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow_rounded,
            size: 20,
            color: theme.colorScheme.onPrimary,
          ),
          const Gap.h(AppSpacing.sm),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
