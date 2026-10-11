import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/reader/reading_mode_controller.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/collection_item.dart';
import '../../data/dtos/curated_collection.dart';
import '../../domain/collection_destination.dart';
import '../controllers/collections_controller.dart';
import '../widgets/collection_card.dart';

/// `/quran/collection/:slug` — a curated set, listed in the order it is read.
///
/// ## Both faiths, one screen
///
/// The faith comes from `selectedFaithProvider`, the same way the whole
/// `/quran` tab is switched between the Qur'an index and the scripture
/// index. A collection is only ever reached from inside its own vertical,
/// so there is no faith in the path; a stale link to the other vertical's
/// slug 404s and lands on the error state, which is the honest outcome.
///
/// The items differ by faith — a surah, an ayah span, a Gita chapter range
/// — and none of that reaches this screen. Each row asks
/// `collectionItemRoute` where it goes and renders the same way regardless
/// of the answer's shape.
///
/// ## What "finishing" means here
///
/// Nothing, deliberately. Each item opens a reader, and the readers already
/// record every verse the reader settles on — so a night's recitation lands
/// in the same activity stream as any other reading and needs no second
/// ledger. A per-collection completion state would be a streak in all but
/// name.
class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    final async = ref.watch(collectionDetailProvider(faith, slug));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => const _Loading(),
          error: (e, __) => _Failed(
            message: e.toString(),
            onRetry: () {
              HapticFeedback.heavyImpact();
              ref.invalidate(collectionDetailProvider(faith, slug));
            },
          ),
          data: (collection) => _Content(collection: collection),
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.collection});

  final CuratedCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final items = collection.items;
    final mode = activeReadingMode(ref);
    final beginRoute = collectionBeginRoute(items, mode: mode);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(child: _TopBar(title: collection.title)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.sm,
            AppSpacing.screenEdge,
            AppSpacing.xxl,
          ),
          sliver: SliverList.list(
            children: [
              Text(
                collectionMeta(collection),
                style: theme.textTheme.bodyMedium,
              ),
              if (collection.description != null) ...[
                const Gap(AppSpacing.md),
                Text(
                  collection.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.inkMuted,
                  ),
                ),
              ],
              // Hidden rather than inert when no item in the set leads
              // anywhere — a Begin button that did nothing would be the
              // worst dead click on the screen.
              if (beginRoute != null) ...[
                const Gap(AppSpacing.lg),
                PoppyButton(
                  label: 'Begin',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push(beginRoute);
                  },
                ),
              ],
              const Gap(AppSpacing.xl),
              for (var i = 0; i < items.length; i++) ...[
                _ItemRow(
                  ordinal: i + 1,
                  item: items[i],
                  route: collectionItemRoute(items[i], mode: mode),
                ),
                if (i != items.length - 1) const Gap(AppSpacing.sm),
              ],
              if (collection.provenance != null) ...[
                const Gap(AppSpacing.xxl),
                _Provenance(provenance: collection.provenance!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One item.
///
/// A card **only** when it leads somewhere. An item with no destination —
/// a prose instruction, or a reference the server could not resolve —
/// renders as plain text on the page with no card, no outline and nothing
/// in its subtree that could take a tap. In this design system a card is a
/// button, and the rule the dead-click reports came down to is that what
/// you can only read *is* the page rather than sitting on it.
///
/// Such items are still listed, never skipped: the row count has to match
/// the "6 readings" the card promised, and an item the server could not
/// resolve is a data problem worth seeing rather than hiding.
class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.ordinal,
    required this.item,
    required this.route,
  });

  final int ordinal;
  final CollectionItem item;
  final String? route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final tappable = route != null;

    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '$ordinal',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: palette.inkMuted,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(item.label, style: theme.textTheme.titleSmall),
                  ),
                  // The ×3 on each of the three Quls — real content the
                  // old hand-written constant had no field for.
                  if (item.repeatCount > 1) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '×${item.repeatCount}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: cs.primary,
                      ),
                    ),
                  ],
                ],
              ),
              if (_subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  _subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.inkMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (tappable)
          Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      ],
    );

    if (!tappable) {
      // No card, no gesture detector, and inset to the same text column as
      // the cards above and below so it reads as a line of the list rather
      // than a broken tile.
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        child: body,
      );
    }

    return Semantics(
      button: true,
      label: _semanticLabel,
      excludeSemantics: true,
      child: PoppyCard(radius: AppRadius.lg, onTap: () {
        HapticFeedback.lightImpact();
        context.push(route!);
      }, child: body),
    );
  }

  /// The reference as the tradition spells it ("Bukhari 5017", "Bhagavad
  /// Gita 12.1–20"), plus the two disclosures that belong on the row rather
  /// than buried: a weak grading, and whether the item may be skipped.
  String? get _subtitle {
    final parts = <String>[
      if (item.citation != null && item.citation!.isNotEmpty) item.citation!,
      // Only `daif` is surfaced. A sound grading is the expectation, so
      // printing it on every row would make the one that matters invisible.
      if (item.grading == 'daif') 'daʻif',
      if (item.isOptional) 'optional',
      if (item.unresolved != null) 'unavailable',
    ];
    return parts.isEmpty ? null : parts.join('  ·  ');
  }

  String get _semanticLabel {
    final sub = _subtitle;
    return sub == null ? item.label : '${item.label}, $sub';
  }
}

/// Who assembled the set and who signed it off.
///
/// Plain text at the foot, not a card — it is the page talking about
/// itself, and there is nothing here to press.
class _Provenance extends StatelessWidget {
  const _Provenance({required this.provenance});

  final CollectionProvenance provenance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    final line = switch (provenance.provenanceClass) {
      // The server's §5.2 rule: an assembled set must read as a selection,
      // never as "the" prescribed reading.
      'assembled' => 'A selection assembled for this app.',
      'transmitted' => 'The set as it is narrated.',
      'thematic' => 'Gathered around a theme.',
      _ => null,
    };
    final reviewer = provenance.reviewedBy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (line != null)
          Text(
            line,
            style: theme.textTheme.bodySmall?.copyWith(
              color: palette.inkMuted,
            ),
          ),
        if (reviewer != null && reviewer.isNotEmpty) ...[
          const Gap(2),
          Text(
            'Reviewed by $reviewer.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: palette.inkMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TopBar(title: 'Collection'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.lg,
            AppSpacing.screenEdge,
            0,
          ),
          child: Column(
            children: [
              for (var i = 0; i < 4; i++) ...[
                const PoppySkeleton(height: 64, radius: AppRadius.lg),
                const Gap(AppSpacing.sm),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A collection that would not load — a bad slug, a slug belonging to the
/// other faith, or a network that is not there.
class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const _TopBar(title: 'Collection'),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(AppSpacing.base),
                  PoppyButton(label: 'Try again', onPressed: onRetry),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            tooltip: 'Back',
            onPressed: () {
              HapticFeedback.lightImpact();
              if (context.canPop()) context.pop();
            },
          ),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
