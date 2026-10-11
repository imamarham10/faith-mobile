import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../domain/recitation_collection.dart';
import '../../../../shared/reader/reading_mode_controller.dart';

/// `/quran/collection/:id` — a curated set, listed in the order it is read.
///
/// ## What "finishing" means here
///
/// Nothing, deliberately. Each item opens a reader, and the readers already
/// record a `quran_verse` for every verse the reader settles on — so a
/// night's recitation lands in the same activity stream as any other
/// reading, counts towards the same day, and needs no second ledger. A
/// per-collection completion state would be a streak in all but name, which
/// is a feature with its own design and not something to smuggle in behind
/// a list of six surahs.
///
/// So the list stays a list: open what you want, in the order given or not.
class RecitationCollectionScreen extends ConsumerWidget {
  const RecitationCollectionScreen({super.key, required this.collectionId});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = kRecitationCollections[collectionId];
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: collection == null
            ? _Missing(id: collectionId)
            : CustomScrollView(
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
                          '${collection.items.length} readings  ·  '
                          '${collection.blurb}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Gap(AppSpacing.lg),
                        PoppyButton(
                          label: 'Begin',
                          onPressed: () =>
                              _open(context, ref, collection.items.first),
                        ),
                        const Gap(AppSpacing.xl),
                        for (var i = 0; i < collection.items.length; i++) ...[
                          _ItemRow(
                            ordinal: i + 1,
                            item: collection.items[i],
                            onTap: () =>
                                _open(context, ref, collection.items[i]),
                          ),
                          if (i != collection.items.length - 1)
                            const Gap(AppSpacing.sm),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref, RecitationItem item) {
    HapticFeedback.lightImpact();
    context.push(item.route(activeReadingMode(ref)));
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

/// One item. A card, because it is a button — the one thing on this screen
/// you press.
class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.ordinal,
    required this.item,
    required this.onTap,
  });

  final int ordinal;
  final RecitationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Semantics(
      button: true,
      label: '${item.title}, ${item.subtitle}',
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.lg,
        onTap: onTap,
        child: Row(
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
                  Text(item.title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Only reachable from a hand-typed or stale link, since every in-app route
/// to this screen comes from [kRecitationCollections] itself.
class _Missing extends StatelessWidget {
  const _Missing({required this.id});

  final String id;

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
                    "We don't have a collection called \"$id\".",
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(AppSpacing.base),
                  PoppyButton(
                    label: 'Back to the Qur\'an',
                    onPressed: () => context.go('/quran'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
