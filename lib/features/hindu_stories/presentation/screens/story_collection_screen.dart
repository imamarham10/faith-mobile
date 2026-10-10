import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../controllers/stories_by_collection_controller.dart';
import '../controllers/story_collections_controller.dart';
import '../widgets/story_list_tile.dart';

/// `/hadiths/hindu-stories/collection/:slug` — list of all stories inside
/// a single collection. Mirrors `HadithBookScreen`, minus infinite-scroll
/// pagination — the backend returns the full collection in one response.
class StoryCollectionScreen extends ConsumerWidget {
  const StoryCollectionScreen({super.key, required this.collectionSlug});

  final String collectionSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesByCollectionProvider(collectionSlug));
    final collectionsAsync = ref.watch(storyCollectionsProvider);

    final collectionName = collectionsAsync.maybeWhen(
      data: (list) {
        for (final c in list) {
          if (c.slug == collectionSlug) return c.name;
        }
        return 'Stories';
      },
      orElse: () => 'Stories',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(collectionName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: storiesAsync.when(
          loading: () => const _Shimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () =>
                ref.invalidate(storiesByCollectionProvider(collectionSlug)),
          ),
          data: (stories) {
            if (stories.isEmpty) {
              return const Center(
                child: IllustratedEmptyState(
                  title: 'Nothing here yet',
                  message: 'No stories in this collection yet.',
                  slot: ArtSlot.emptyCollection,
                  mascot: MascotState.sleep,
                ),
              );
            }
            return ListView.separated(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sm,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              itemCount: stories.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
              itemBuilder: (_, i) {
                final story = stories[i];
                return StoryListTile(
                  story: story,
                  onTap: () =>
                      context.push('/hadiths/hindu-stories/${story.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        AppSpacing.xxl,
      ),
      itemCount: 6,
      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
      itemBuilder: (_, __) =>
          const PoppySkeleton(height: 88, radius: AppRadius.lg),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.md),
            Text(
              'We couldn\'t load these stories.',
              style: theme.textTheme.bodyLarge,
            ),
            const Gap(AppSpacing.lg),
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
