import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/reader/reading_mode_controller.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/page_masthead.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../domain/chapter_reading_route.dart';
import '../controllers/hindu_scriptures_home_controller.dart';
import '../widgets/text_card.dart';

/// `/quran` (Hindu content) — text index with search + last-read resume +
/// bookmarks shortcut. Structurally mirrors `quran_home_screen.dart`.
class HinduScripturesHomeScreen extends ConsumerStatefulWidget {
  const HinduScripturesHomeScreen({super.key});

  @override
  ConsumerState<HinduScripturesHomeScreen> createState() =>
      _HinduScripturesHomeScreenState();
}

class _HinduScripturesHomeScreenState
    extends ConsumerState<HinduScripturesHomeScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      ref.read(scriptureSearchQueryProvider.notifier).update(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncTexts = ref.watch(scriptureTextListProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                0,
                AppSpacing.screenEdge,
                AppSpacing.base,
              ),
              sliver: SliverToBoxAdapter(
                child: _SearchField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _ContinueReadingCard()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.base,
                AppSpacing.screenEdge,
                AppSpacing.sm,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionLabel('Texts'),
                    TextButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.push('/quran/bookmarks');
                      },
                      icon: const Icon(Icons.bookmark_outline, size: 18),
                      label: Text(
                        'Bookmarks',
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            asyncTexts.when(
              data: (_) => _ResultsList(),
              loading: () => const _LoadingShimmer(),
              error: (e, _) => _ErrorState(message: e.toString()),
            ),
            const SliverToBoxAdapter(child: Gap(AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // No horizontal padding: PageMasthead insets its own text and lets the
    // motif run off the screen edge, which is the signal a card cannot fake.
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, AppSpacing.lg, 0, AppSpacing.lg),
      child: PageMasthead(
        title: 'Scripture',
        subtitle: 'Read, listen, reflect.',
        slot: ArtSlot.scriptureHeader,
        height: 140,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search texts by name',
        prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, v, __) => v.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends ConsumerWidget {
  const _ContinueReadingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final lastRead = ref.watch(scriptureLastReadControllerProvider).valueOrNull;
    final texts = ref.watch(scriptureTextListProvider).valueOrNull;
    if (lastRead == null) return const SizedBox.shrink();

    final text = texts?.where((t) => t.slug == lastRead.textSlug).firstOrNull;
    final name = text?.nameEnglish ?? lastRead.textSlug;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: PoppyCard(
        radius: AppRadius.xl,
        color: cs.primaryContainer,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(
            chapterReadingRoute(
              lastRead.textSlug,
              lastRead.chapterNumber,
              mode: activeReadingMode(ref),
              verse: lastRead.verseNumber,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.play_arrow_rounded,
                color: cs.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTINUE READING',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Chapter ${lastRead.chapterNumber} · Verse ${lastRead.verseNumber}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ResultsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredScriptureTextsProvider);
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(
        child: IllustratedEmptyState(
          title: 'Nothing matched',
          message: 'No texts match that search.',
          slot: ArtSlot.emptySearch,
          mascot: MascotState.encourage,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.separated(
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
        itemBuilder: (context, index) {
          final text = filtered[index];
          return TextCard(
            text: text,
            onTap: () => context.push('/quran/hindu-scripture/${text.slug}'),
          );
        },
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      sliver: SliverList.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
        itemBuilder: (_, __) =>
            const PoppySkeleton(height: 76, radius: AppRadius.lg),
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.xl,
        AppSpacing.screenEdge,
        AppSpacing.xl,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text(
              'We couldn\'t load texts.',
              style: theme.textTheme.titleMedium,
            ),
            const Gap(4),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.base),
            PoppyButton(
              label: 'Retry',
              onPressed: () => ref.invalidate(scriptureTextListProvider),
            ),
          ],
        ),
      ),
    );
  }
}
