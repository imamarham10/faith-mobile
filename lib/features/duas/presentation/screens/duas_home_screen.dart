import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/dua.dart';
import '../../data/dtos/dua_category.dart';
import '../controllers/dua_categories_controller.dart';
import '../controllers/dua_favorites_controller.dart';
import '../controllers/duas_by_category_controller.dart';
import '../widgets/category_card.dart';

/// `/practice/duas` — categorical entry point with a search field across all
/// duas and a pinned Favorites card.
class DuasHomeScreen extends ConsumerStatefulWidget {
  const DuasHomeScreen({super.key});

  @override
  ConsumerState<DuasHomeScreen> createState() => _DuasHomeScreenState();
}

class _DuasHomeScreenState extends ConsumerState<DuasHomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final categoriesAsync = ref.watch(duaCategoriesProvider);
    final favoritesAsync = ref.watch(duaFavoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sm,
                AppSpacing.screenEdge,
                AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search duas',
                    prefixIcon: Icon(
                      Icons.search,
                      color: cs.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 18,
                              color: cs.onSurfaceVariant,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              _onSearchChanged('');
                            },
                          ),
                  ),
                ),
              ),
            ),
            if (_query.length >= 2)
              _SearchResultsSliver(query: _query)
            else
              _CategoriesGridSliver(
                categoriesAsync: categoriesAsync,
                favoritesCount: favoritesAsync.valueOrNull?.length ?? 0,
                onRetry: () => ref.invalidate(duaCategoriesProvider),
              ),
            const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

/// Displays the `categories` grid plus the pinned Favorites card. Handles
/// loading, error, and content states. Empty is defensive (server should
/// always return ≥1 category).
class _CategoriesGridSliver extends StatelessWidget {
  const _CategoriesGridSliver({
    required this.categoriesAsync,
    required this.favoritesCount,
    required this.onRetry,
  });

  final AsyncValue<List<DuaCategory>> categoriesAsync;
  final int favoritesCount;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return categoriesAsync.when(
      loading: () => const _CategoriesShimmer(),
      error: (_, __) => SliverFillRemaining(
        hasScrollBody: false,
        child: _ErrorPanel(onRetry: onRetry),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyPanel(),
          );
        }
        // categories first, then a "Favorites" tile pinned at the end of the grid.
        final tiles = <Widget>[
          for (final c in categories)
            CategoryCard(
              name: c.name,
              count: c.count,
              description: c.description,
              icon: _iconFor(c.name),
              onTap: () => context.push('/practice/duas/category/${c.id}'),
            ),
          FavoritesCard(
            count: favoritesCount,
            onTap: () => context.push('/practice/duas/favorites'),
          ),
        ];
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            0,
            AppSpacing.screenEdge,
            0,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              mainAxisExtent: 148,
            ),
            itemCount: tiles.length,
            itemBuilder: (_, i) => tiles[i],
          ),
        );
      },
    );
  }

  IconData _iconFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('morning') || lower.contains('evening')) {
      return Icons.wb_twilight_outlined;
    }
    if (lower.contains('travel')) return Icons.flight_takeoff;
    if (lower.contains('eat') || lower.contains('food')) {
      return Icons.restaurant_outlined;
    }
    if (lower.contains('sleep') || lower.contains('night')) {
      return Icons.nightlight_outlined;
    }
    if (lower.contains('home') || lower.contains('house')) {
      return Icons.home_outlined;
    }
    if (lower.contains('protection') || lower.contains('safety')) {
      return Icons.shield_outlined;
    }
    if (lower.contains('forgive')) return Icons.spa_outlined;
    if (lower.contains('worry') || lower.contains('anx')) {
      return Icons.air_outlined;
    }
    return Icons.menu_book_outlined;
  }
}

class _CategoriesShimmer extends StatelessWidget {
  const _CategoriesShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
        0,
      ),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 148,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: cs.surface,
          highlightColor: cs.outline,
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultsSliver extends ConsumerWidget {
  const _SearchResultsSliver({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favs = ref.watch(duaFavoritesControllerProvider);
    final favsCtrl = ref.read(duaFavoritesControllerProvider.notifier);
    final results = ref.watch(duasSearchProvider(query));

    return results.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: _ErrorPanel(
          onRetry: () => ref.invalidate(duasSearchProvider(query)),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_outlined,
                    size: 36,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const Gap(AppSpacing.md),
                  Text(
                    'No duas matched that.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            0,
            AppSpacing.screenEdge,
            0,
          ),
          sliver: SliverList.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
            itemBuilder: (_, i) {
              final dua = list[i];
              final isFav =
                  favs.valueOrNull?.any((d) => d.id == dua.id) ?? false;
              return _SearchResultRow(
                dua: dua,
                isFavorite: isFav,
                onTap: () => context.push('/practice/duas/${dua.id}'),
                onToggleFavorite: () => favsCtrl.toggle(dua),
              );
            },
          ),
        );
      },
    );
  }
}

/// Compact search result row that mirrors `DuaListTile` styling without
/// importing the per-category list widget.
class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.dua,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Dua dua;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.base,
            AppSpacing.sm,
            AppSpacing.base,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dua.titleEnglish,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dua.textEnglish,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? accentText : cs.onSurfaceVariant,
                  size: 22,
                ),
              ),
            ],
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.md),
          Text(
            'We couldn\'t reach the duas server.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.lg),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.md),
          Text(
            'No duas yet — check back soon.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
