import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/divine_name.dart';
import '../../domain/names_kind.dart';
import '../controllers/allah_names_controller.dart';
import '../controllers/muhammad_names_controller.dart';
import '../controllers/name_favorites_controller.dart';
import '../controllers/todays_name_controller.dart';
import '../widgets/name_list_tile.dart';
import '../widgets/todays_name_hero.dart';

/// `/practice/names` — top-tabbed home: Allah | Muhammad ﷺ.
///
/// Each tab is a sliver list — name-of-the-day hero pinned at top, then the
/// 99 names below.
class NamesHomeScreen extends ConsumerStatefulWidget {
  const NamesHomeScreen({super.key});

  @override
  ConsumerState<NamesHomeScreen> createState() => _NamesHomeScreenState();
}

class _NamesHomeScreenState extends ConsumerState<NamesHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabChanged);
    _tabs.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabs.indexIsChanging) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Names'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
            ),
            child: TabBar(
              controller: _tabs,
              labelStyle: theme.textTheme.titleMedium,
              unselectedLabelStyle: theme.textTheme.titleMedium,
              labelColor: cs.onSurface,
              unselectedLabelColor: cs.onSurfaceVariant,
              indicatorColor: cs.primary,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Allah'),
                Tab(text: 'Muhammad ﷺ'),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: TabBarView(
          controller: _tabs,
          children: const [
            _NamesTab(kind: NamesKind.allah),
            _NamesTab(kind: NamesKind.muhammad),
          ],
        ),
      ),
    );
  }
}

class _NamesTab extends ConsumerWidget {
  const _NamesTab({required this.kind});

  final NamesKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = kind == NamesKind.allah
        ? ref.watch(allahNamesProvider)
        : ref.watch(muhammadNamesProvider);
    final dailyAsync = ref.watch(todaysNameProvider(kind));
    final favs = ref.watch(nameFavoritesControllerProvider(kind));
    final favsCtrl = ref.read(nameFavoritesControllerProvider(kind).notifier);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.base,
            AppSpacing.screenEdge,
            AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: dailyAsync.when(
              loading: () => const _HeroShimmer(),
              error: (_, __) => const SizedBox.shrink(),
              data: (name) => TodaysNameHero(
                name: name,
                onTap: () =>
                    context.push('/practice/names/${kind.slug}/${name.id}'),
              ),
            ),
          ),
        ),
        namesAsync.when(
          loading: () => const _ListShimmerSliver(),
          error: (_, __) => SliverFillRemaining(
            hasScrollBody: false,
            child: _ErrorPanel(
              onRetry: () {
                if (kind == NamesKind.allah) {
                  ref.invalidate(allahNamesProvider);
                } else {
                  ref.invalidate(muhammadNamesProvider);
                }
              },
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyPanel(),
              );
            }
            return _NamesSliver(
              kind: kind,
              names: list,
              favorites: favs.valueOrNull ?? const <DivineName>[],
              onToggleFavorite: favsCtrl.toggle,
            );
          },
        ),
        const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
      ],
    );
  }
}

class _NamesSliver extends StatelessWidget {
  const _NamesSliver({
    required this.kind,
    required this.names,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final NamesKind kind;
  final List<DivineName> names;
  final List<DivineName> favorites;
  final Future<void> Function(DivineName) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final favIds = {for (final n in favorites) n.id};
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
        0,
      ),
      sliver: SliverList.separated(
        itemCount: names.length,
        separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
        itemBuilder: (_, i) {
          final n = names[i];
          return NameListTile(
            name: n,
            isFavorite: favIds.contains(n.id),
            onTap: () => context.push('/practice/names/${kind.slug}/${n.id}'),
            onToggleFavorite: () => onToggleFavorite(n),
          );
        },
      ),
    );
  }
}

class _HeroShimmer extends StatelessWidget {
  const _HeroShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.surface,
      highlightColor: cs.outline,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
    );
  }
}

class _ListShimmerSliver extends StatelessWidget {
  const _ListShimmerSliver();

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
      sliver: SliverList.separated(
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
              'We couldn\'t load these names.',
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

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text('No names available.', style: theme.textTheme.bodyLarge),
      ),
    );
  }
}
