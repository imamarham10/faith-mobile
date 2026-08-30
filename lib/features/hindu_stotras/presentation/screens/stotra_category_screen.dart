import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../controllers/stotra_categories_controller.dart';
import '../controllers/stotra_favorites_controller.dart';
import '../controllers/stotras_by_category_controller.dart';
import '../widgets/stotra_list_tile.dart';

/// `/practice/stotras/category/:slug` — list of all stotras inside a single
/// category. Mirrors `DuaCategoryScreen`.
class StotraCategoryScreen extends ConsumerWidget {
  const StotraCategoryScreen({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stotrasAsync = ref.watch(stotrasByCategoryProvider(categorySlug));
    final categoriesAsync = ref.watch(stotraCategoriesProvider);
    final favs = ref.watch(stotraFavoritesControllerProvider);
    final favsCtrl = ref.read(stotraFavoritesControllerProvider.notifier);

    final categoryName = categoriesAsync.maybeWhen(
      data: (list) {
        for (final c in list) {
          if (c.slug == categorySlug) return c.name;
        }
        return 'Stotras';
      },
      orElse: () => 'Stotras',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: stotrasAsync.when(
          loading: () => const _CategoryShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () =>
                ref.invalidate(stotrasByCategoryProvider(categorySlug)),
          ),
          data: (stotras) {
            if (stotras.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 36,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const Gap(AppSpacing.md),
                      Text(
                        'No stotras in this category yet.',
                        style: theme.textTheme.bodyLarge,
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
              itemCount: stotras.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
              itemBuilder: (_, i) {
                final stotra = stotras[i];
                final isFav =
                    favs.valueOrNull?.any((s) => s.id == stotra.id) ?? false;
                return StotraListTile(
                  stotra: stotra,
                  isFavorite: isFav,
                  onTap: () =>
                      context.push('/practice/stotras/${stotra.slug}'),
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

class _CategoryShimmer extends StatelessWidget {
  const _CategoryShimmer();

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
      itemCount: 8,
      separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
      itemBuilder: (_, __) =>
          const PoppySkeleton(height: 72, radius: AppRadius.lg),
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
              'We couldn\'t load these stotras.',
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
