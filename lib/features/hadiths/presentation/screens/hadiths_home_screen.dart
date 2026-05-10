import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/hadith_book.dart';
import '../controllers/hadiths_home_controller.dart';
import '../widgets/book_card.dart';
import '../widgets/daily_hadith_hero.dart';

/// `/hadiths` — top-level entry: daily hero, search shortcut, books grid.
class HadithsHomeScreen extends ConsumerWidget {
  const HadithsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(hadithBooksProvider);

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
                    context.push('/hadiths/search');
                  },
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sm,
                AppSpacing.screenEdge,
                0,
              ),
              sliver: SliverToBoxAdapter(child: DailyHadithHero()),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.xl,
                AppSpacing.screenEdge,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(child: SectionLabel('Books')),
            ),
            booksAsync.when(
              loading: () => const _BooksShimmer(),
              error: (_, __) => SliverToBoxAdapter(
                child: _ErrorPanel(
                  onRetry: () => ref.invalidate(hadithBooksProvider),
                ),
              ),
              data: (books) {
                if (books.isEmpty) {
                  return const SliverToBoxAdapter(child: _EmptyPanel());
                }
                return _BooksGrid(books: books);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hadiths', style: theme.textTheme.displaySmall),
          const SizedBox(height: 4),
          Text(
            'The traditions of the Prophet ﷺ.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// A read-only search "field" that pushes to the dedicated search screen.
///
/// Cheaper than an inline-debounced field on the home — search matters more
/// than instant filtering, and the dedicated route keeps focus + state clean.
class _SearchTrigger extends StatelessWidget {
  const _SearchTrigger({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            children: [
              Icon(Icons.search, color: cs.onSurfaceVariant, size: 20),
              const Gap.h(AppSpacing.md),
              Expanded(
                child: Text(
                  'Search hadiths',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BooksGrid extends StatelessWidget {
  const _BooksGrid({required this.books});

  final List<HadithBook> books;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 156,
        ),
        itemCount: books.length,
        itemBuilder: (_, i) {
          final book = books[i];
          return BookCard(
            book: book,
            onTap: () => context.push('/hadiths/book/${book.id}'),
          );
        },
      ),
    );
  }
}

class _BooksShimmer extends StatelessWidget {
  const _BooksShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 156,
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
            'We couldn\'t load the books.',
            style: theme.textTheme.titleMedium,
          ),
          const Gap(AppSpacing.lg),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
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
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.md),
          Text(
            'No books yet — check back soon.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
