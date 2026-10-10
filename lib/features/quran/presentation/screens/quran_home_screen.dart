import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/page_masthead.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/surah.dart';
import '../../domain/often_read.dart';
import '../controllers/juz_controller.dart';
import '../controllers/quran_home_controller.dart';
import '../widgets/juz_list_tile.dart';
import '../widgets/surah_list_tile.dart';

/// `/quran` — surah index with search + last-read resume + bookmarks shortcut.
class QuranHomeScreen extends ConsumerStatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  ConsumerState<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends ConsumerState<QuranHomeScreen> {
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
      ref.read(surahSearchQueryProvider.notifier).update(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(quranBrowseModeControllerProvider);
    final searching = ref.watch(surahSearchQueryProvider).trim().isNotEmpty;

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
                  mode: mode,
                ),
              ),
            ),
            // Hidden while searching: the shortcuts answer "what do I read
            // today", and someone who is typing has already answered it.
            if (!searching) const SliverToBoxAdapter(child: _OftenReadRow()),
            const SliverToBoxAdapter(child: _ContinueReadingCard()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.lg,
                AppSpacing.screenEdge,
                0,
              ),
              sliver: SliverToBoxAdapter(child: _ModeSwitch(mode: mode)),
            ),
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
                    SectionLabel(
                      mode == QuranBrowseMode.surah ? 'Surahs' : 'Juz 1–30',
                    ),
                    TextButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.push('/quran/bookmarks');
                      },
                      icon: const Icon(Icons.bookmark_outline, size: 18),
                      label: Text(
                        'Bookmarks',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (mode == QuranBrowseMode.surah)
              const _SurahSection()
            else
              const _JuzSection(),
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
        title: 'Quran',
        subtitle: 'Read, listen, reflect.',
        slot: ArtSlot.scriptureHeader,
        height: 140,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.mode,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Only changes the hint. One query drives both indexes, so switching
  /// segments mid-search shows the other index's answer instead of
  /// throwing away what was typed.
  final QuranBrowseMode mode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: mode == QuranBrowseMode.surah
            ? 'Search surahs by name or number'
            : 'Search juz by number or surah',
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
    final lastRead = ref.watch(lastReadControllerProvider).valueOrNull;
    final surahs = ref.watch(surahListProvider).valueOrNull;
    if (lastRead == null) return const SizedBox.shrink();

    final surah = surahs?.firstWhere(
      (s) => s.id == lastRead.surahId,
      orElse: () => const Surah(
        id: 0,
        nameArabic: '',
        nameEnglish: '',
        nameTransliteration: '',
        revelationPlace: '',
        verseCount: 0,
      ),
    );
    final name = (surah == null || surah.id == 0)
        ? 'Surah ${lastRead.surahId}'
        : surah.nameTransliteration;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: PoppyCard(
        radius: AppRadius.xl,
        color: cs.primaryContainer,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(
            '/quran/surah/${lastRead.surahId}?ayah=${lastRead.verseNumber}',
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
                    'Verse ${lastRead.verseNumber}',
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
    final filtered = ref.watch(filteredSurahsProvider);
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(
        child: IllustratedEmptyState(
          title: 'Nothing matched',
          message: 'No surahs match that search.',
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
          final surah = filtered[index];
          return SurahListTile(
            surah: surah,
            onTap: () => context.push('/quran/surah/${surah.id}'),
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.title,
  });

  final String message;
  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            Text(title, style: theme.textTheme.titleMedium),
            const Gap(4),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.base),
            PoppyButton(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

/// Shortcut chips for the surahs people open on a schedule — see
/// [kOftenReadSurahs] for which, and why those.
///
/// Scrolls horizontally rather than wrapping, so it occupies one row no
/// matter how many entries it holds and never pushes the index below the
/// fold. Names come from a constant, so the row is painted on the tab's
/// first frame instead of waiting on `GET /surahs`.
class _OftenReadRow extends StatelessWidget {
  const _OftenReadRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              0,
              AppSpacing.screenEdge,
              AppSpacing.sm,
            ),
            child: SectionLabel('Often read'),
          ),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdge,
              ),
              itemCount: kOftenReadSurahs.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _OftenReadChip(surah: kOftenReadSurahs[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _OftenReadChip extends StatelessWidget {
  const _OftenReadChip({required this.surah});

  final OftenReadSurah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

    return Semantics(
      button: true,
      label: '${surah.name}, read ${surah.occasion.toLowerCase()}',
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.pill,
        // 14 + text + occasion + 10 clears the 44pt minimum tap target by
        // the height of the row itself.
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/quran/surah/${surah.id}');
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(surah.name, style: theme.textTheme.titleSmall),
            const SizedBox(height: 2),
            Text(
              surah.occasion,
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Surah | Juz. A [SegmentedButton] because that is already this app's
/// segmented control (dhikr and japa goals both use one) — a bespoke one
/// here would be a second answer to a solved question.
class _ModeSwitch extends ConsumerWidget {
  const _ModeSwitch({required this.mode});

  final QuranBrowseMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<QuranBrowseMode>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: QuranBrowseMode.surah,
          label: Text('Surah'),
          icon: Icon(Icons.menu_book_outlined, size: 18),
        ),
        ButtonSegment(
          value: QuranBrowseMode.juz,
          label: Text('Juz'),
          icon: Icon(Icons.auto_stories_outlined, size: 18),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) {
        HapticFeedback.selectionClick();
        ref
            .read(quranBrowseModeControllerProvider.notifier)
            .select(selection.first);
      },
    );
  }
}

/// The surah index — unchanged behaviour, lifted into its own widget so the
/// segment switch does not rebuild the whole screen.
class _SurahSection extends ConsumerWidget {
  const _SurahSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(surahListProvider)
        .when(
          data: (_) => _ResultsList(),
          loading: () => const _LoadingShimmer(),
          error: (e, _) => _ErrorState(
            title: "We couldn't load surahs.",
            message: e.toString(),
            onRetry: () => ref.invalidate(surahListProvider),
          ),
        );
  }
}

/// The juz index.
///
/// `juzIndexProvider` is first watched *here*, which is the point: nothing
/// requests `GET /juz` until someone selects the Juz segment, so the tab's
/// cold open and the app's launch are untouched by this feature.
class _JuzSection extends ConsumerWidget {
  const _JuzSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(juzIndexProvider)
        .when(
          data: (_) => const _JuzResultsList(),
          loading: () => const _LoadingShimmer(),
          error: (e, _) => _ErrorState(
            title: "We couldn't load the juz list.",
            message: e.toString(),
            onRetry: () => ref.invalidate(juzIndexProvider),
          ),
        );
  }
}

class _JuzResultsList extends ConsumerWidget {
  const _JuzResultsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredJuzProvider);
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(
        child: IllustratedEmptyState(
          title: 'Nothing matched',
          message: 'No juz match that search.',
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
          final juz = filtered[index];
          return JuzListTile(
            juz: juz,
            onTap: () => context.push('/quran/juz/${juz.number}'),
          );
        },
      ),
    );
  }
}
