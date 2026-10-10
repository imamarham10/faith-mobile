import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/illustrated_header.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/story_collection.dart';
import '../controllers/story_collections_controller.dart';
import '../controllers/story_favorites_controller.dart';
import '../widgets/collection_card.dart';

/// `/hadiths` (Hindu content) — collections grid + search shortcut + a
/// pinned Favorites card. Mirrors `HadithsHomeScreen`, minus the daily-hero
/// (no backend "story of the day" endpoint exists).
class StoriesHomeScreen extends ConsumerWidget {
  const StoriesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(storyCollectionsProvider);
    final favoritesAsync = ref.watch(storyFavoritesControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.base,
              ),
              sliver: SliverToBoxAdapter(
                child: _SearchTrigger(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/hadiths/hindu-stories/search');
                  },
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sm,
                AppSpacing.screenEdge,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(child: SectionLabel('Collections')),
            ),
            collectionsAsync.when(
              loading: () => const _CollectionsShimmer(),
              error: (_, __) => SliverToBoxAdapter(
                child: _ErrorPanel(
                  onRetry: () => ref.invalidate(storyCollectionsProvider),
                ),
              ),
              data: (collections) {
                if (collections.isEmpty) {
                  return const SliverToBoxAdapter(child: _EmptyPanel());
                }
                return _CollectionsGrid(
                  collections: collections,
                  favoritesCount: favoritesAsync.valueOrNull?.length ?? 0,
                );
              },
            ),
            const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.lg,
      ),
      child: IllustratedHeader(
        title: 'Stories',
        subtitle: 'Timeless tales, retold.',
        slot: ArtSlot.narrativeHeader,
        titleStyle: theme.textTheme.displaySmall,
        height: 140,
      ),
    );
  }
}

class _SearchTrigger extends StatelessWidget {
  const _SearchTrigger({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      radius: AppRadius.md,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.onSurfaceVariant, size: 20),
          const Gap.h(AppSpacing.md),
          Expanded(
            child: Text(
              'Search stories',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionsGrid extends StatelessWidget {
  const _CollectionsGrid({
    required this.collections,
    required this.favoritesCount,
  });

  final List<StoryCollection> collections;
  final int favoritesCount;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      for (final c in collections)
        CollectionCard(
          collection: c,
          onTap: () =>
              context.push('/hadiths/hindu-stories/collection/${c.slug}'),
        ),
      _FavoritesCard(
        count: favoritesCount,
        onTap: () => context.push('/hadiths/hindu-stories/favorites'),
      ),
    ];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 172,
        ),
        itemCount: tiles.length,
        itemBuilder: (_, i) => tiles[i],
      ),
    );
  }
}

class _FavoritesCard extends StatelessWidget {
  const _FavoritesCard({required this.onTap, required this.count});

  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;

    return PoppyCard(
      radius: AppRadius.lg,
      color: cs.secondaryContainer,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite, size: 22, color: accentText),
          const Spacer(),
          Text('Favorites', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            count == 0
                ? 'Tap any heart to save'
                : count == 1
                ? '1 saved'
                : '$count saved',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _CollectionsShimmer extends StatelessWidget {
  const _CollectionsShimmer();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 172,
        ),
        itemCount: 4,
        itemBuilder: (_, __) =>
            const PoppySkeleton(height: 172, radius: AppRadius.lg),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.md),
          Text(
            'We couldn\'t load the collections.',
            style: theme.textTheme.titleMedium,
          ),
          const Gap(AppSpacing.lg),
          PoppyButton(label: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    return const IllustratedEmptyState(
      title: 'No stories yet',
      message: 'Check back soon.',
      slot: ArtSlot.emptyCollection,
      mascot: MascotState.sleep,
    );
  }
}
