import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/stotra.dart';
import '../../data/dtos/stotra_category.dart';
import '../controllers/stotra_categories_controller.dart';
import '../controllers/stotra_favorites_controller.dart';
import '../controllers/stotras_by_category_controller.dart';
import '../widgets/stotra_category_card.dart';

/// `/practice/stotras` — categorical entry point with a search field across
/// all stotras and a pinned Favorites card. Mirrors `DuasHomeScreen`.
class StotrasHomeScreen extends ConsumerStatefulWidget {
  const StotrasHomeScreen({super.key});

  @override
  ConsumerState<StotrasHomeScreen> createState() => _StotrasHomeScreenState();
}

class _StotrasHomeScreenState extends ConsumerState<StotrasHomeScreen> {
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
    final categoriesAsync = ref.watch(stotraCategoriesProvider);
    final favoritesAsync = ref.watch(stotraFavoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stotras'),
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
                    hintText: 'Search stotras',
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
                onRetry: () => ref.invalidate(stotraCategoriesProvider),
              ),
            const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _CategoriesGridSliver extends StatelessWidget {
  const _CategoriesGridSliver({
    required this.categoriesAsync,
    required this.favoritesCount,
    required this.onRetry,
  });

  final AsyncValue<List<StotraCategory>> categoriesAsync;
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
        final tiles = <Widget>[
          for (final c in categories)
            StotraCategoryCard(
              name: c.name,
              count: c.stotraCount,
              onTap: () => context.push('/practice/stotras/category/${c.slug}'),
            ),
          StotraFavoritesCard(
            count: favoritesCount,
            onTap: () => context.push('/practice/stotras/favorites'),
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
              mainAxisExtent: 164,
            ),
            itemCount: tiles.length,
            itemBuilder: (_, i) => tiles[i],
          ),
        );
      },
    );
  }
}

class _CategoriesShimmer extends StatelessWidget {
  const _CategoriesShimmer();

  @override
  Widget build(BuildContext context) {
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
          mainAxisExtent: 164,
        ),
        itemCount: 6,
        itemBuilder: (_, __) =>
            const PoppySkeleton(height: 164, radius: AppRadius.lg),
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
    final favs = ref.watch(stotraFavoritesControllerProvider);
    final favsCtrl = ref.read(stotraFavoritesControllerProvider.notifier);
    final results = ref.watch(stotrasSearchProvider(query));

    return results.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: _ErrorPanel(
          onRetry: () => ref.invalidate(stotrasSearchProvider(query)),
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
                    'No stotras matched that.',
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
              final stotra = list[i];
              final isFav =
                  favs.valueOrNull?.any((s) => s.id == stotra.id) ?? false;
              return _SearchResultRow(
                stotra: stotra,
                isFavorite: isFav,
                onTap: () => context.push('/practice/stotras/${stotra.slug}'),
                onToggleFavorite: () => favsCtrl.toggle(stotra),
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.stotra,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Stotra stotra;
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
    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.sm,
        AppSpacing.base,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stotra.titleEnglish,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  stotra.titleSanskrit,
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
            'We couldn\'t reach the stotras server.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.lg),
          PoppyButton(label: 'Try again', onPressed: onRetry),
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
            Icons.temple_hindu,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.md),
          Text(
            'No stotras yet — check back soon.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
