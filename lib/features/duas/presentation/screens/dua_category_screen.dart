import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../controllers/dua_categories_controller.dart';
import '../controllers/dua_favorites_controller.dart';
import '../controllers/duas_by_category_controller.dart';
import '../widgets/dua_list_tile.dart';

/// `/practice/duas/category/:id` — list of all duas inside a single category.
class DuaCategoryScreen extends ConsumerWidget {
  const DuaCategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final duasAsync = ref.watch(duasByCategoryProvider(categoryId));
    final categoriesAsync = ref.watch(duaCategoriesProvider);
    final favs = ref.watch(duaFavoritesControllerProvider);
    final favsCtrl = ref.read(duaFavoritesControllerProvider.notifier);

    final categoryName = categoriesAsync.maybeWhen(
      data: (list) {
        for (final c in list) {
          if (c.id == categoryId) return c.name;
        }
        return 'Duas';
      },
      orElse: () => 'Duas',
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
        child: duasAsync.when(
          loading: () => const _CategoryShimmer(),
          error: (_, __) => _ErrorPanel(
            onRetry: () => ref.invalidate(duasByCategoryProvider(categoryId)),
          ),
          data: (duas) {
            if (duas.isEmpty) {
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
                        'No duas in this category yet.',
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
              itemCount: duas.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
              itemBuilder: (_, i) {
                final dua = duas[i];
                final isFav =
                    favs.valueOrNull?.any((d) => d.id == dua.id) ?? false;
                return DuaListTile(
                  dua: dua,
                  isFavorite: isFav,
                  onTap: () => context.push('/practice/duas/${dua.id}'),
                  onToggleFavorite: () => favsCtrl.toggle(dua),
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
    final cs = Theme.of(context).colorScheme;
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
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: cs.surface,
        highlightColor: cs.outline,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
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
              'We couldn\'t load these duas.',
              style: theme.textTheme.bodyLarge,
            ),
            const Gap(AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
