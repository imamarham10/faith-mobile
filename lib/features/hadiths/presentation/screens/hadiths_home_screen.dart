import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/illustrated_header.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
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
      child: IllustratedHeader(
        title: 'Hadiths',
        subtitle: 'The traditions of the Prophet ﷺ.',
        slot: ArtSlot.narrativeHeader,
        titleStyle: theme.textTheme.displaySmall,
        // The ﷺ glyph is tall and forces an early wrap, so this subtitle
        // needs more of the width than the default split gives it.
        height: 148,
        textFlex: 66,
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
              'Search hadiths',
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
          mainAxisExtent: 172,
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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 172,
        ),
        itemCount: 6,
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
            'We couldn\'t load the books.',
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
      title: 'No books yet',
      message: 'Check back soon.',
      slot: ArtSlot.emptyCollection,
      mascot: MascotState.sleep,
    );
  }
}
