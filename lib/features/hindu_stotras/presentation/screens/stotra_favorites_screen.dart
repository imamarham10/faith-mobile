import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../controllers/stotra_favorites_controller.dart';
import '../widgets/stotra_list_tile.dart';

/// `/practice/stotras/favorites` — the user's saved stotras. Local-first,
/// instant. Mirrors `DuaFavoritesScreen`.
class StotraFavoritesScreen extends ConsumerWidget {
  const StotraFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favs = ref.watch(stotraFavoritesControllerProvider);
    final favsCtrl = ref.read(stotraFavoritesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: favs.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'We couldn\'t load your favorites.',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 36,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const Gap(AppSpacing.md),
                      Text('No favorites yet', style: theme.textTheme.titleLarge),
                      const Gap(AppSpacing.xs),
                      Text(
                        'Tap the heart on any stotra to save it here.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
              itemCount: list.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
              itemBuilder: (_, i) {
                final stotra = list[i];
                return StotraListTile(
                  stotra: stotra,
                  isFavorite: true,
                  onTap: () => context.push('/practice/stotras/${stotra.slug}'),
                  onToggleFavorite: () => favsCtrl.toggle(stotra),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
