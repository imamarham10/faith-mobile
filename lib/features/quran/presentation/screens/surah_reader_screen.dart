import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/verse.dart';
import '../controllers/audio_controller.dart';
import '../controllers/bookmarks_controller.dart';
import '../controllers/quran_home_controller.dart';
import '../controllers/surah_controller.dart';
import '../widgets/audio_mini_player.dart';
import '../widgets/ayah_action_sheet.dart';
import '../widgets/ayah_view.dart';
import '../widgets/reader_top_bar.dart';

/// `/quran/surah/:id` — continuous reader with audio + per-ayah actions.
class SurahReaderScreen extends ConsumerStatefulWidget {
  const SurahReaderScreen({super.key, required this.surahId, this.initialAyah});

  final int surahId;
  final int? initialAyah;

  @override
  ConsumerState<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends ConsumerState<SurahReaderScreen> {
  final _scrollCtrl = ScrollController();
  final _ayahKeys = <int, GlobalKey>{};
  Timer? _scrollDebounce;
  int _visibleAyah = 1;
  bool _initialJumpDone = false;

  @override
  void initState() {
    super.initState();
    _visibleAyah = widget.initialAyah ?? 1;
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();
    _scrollDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    _scrollDebounce?.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _persistLastRead();
    });
  }

  void _persistLastRead() {
    final ayah = _topMostVisibleAyah();
    if (ayah == null) return;
    _visibleAyah = ayah;
    ref
        .read(lastReadControllerProvider.notifier)
        .save(surahId: widget.surahId, verseNumber: ayah);
  }

  int? _topMostVisibleAyah() {
    final scrollOffset = _scrollCtrl.hasClients ? _scrollCtrl.offset : 0.0;
    int? best;
    double? bestDelta;
    _ayahKeys.forEach((number, key) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) return;
      final position = box.localToGlobal(Offset.zero).dy;
      // Want positions just below the top bar (~120pt).
      const targetY = 140.0;
      final delta = (position - targetY).abs();
      if (position < -box.size.height) return;
      if (bestDelta == null || delta < bestDelta!) {
        bestDelta = delta;
        best = number;
      }
    });
    if (scrollOffset <= 0 && best == null) return 1;
    return best;
  }

  void _jumpToAyahIfNeeded() {
    if (_initialJumpDone) return;
    final target = widget.initialAyah;
    if (target == null || target <= 1) {
      _initialJumpDone = true;
      return;
    }
    final key = _ayahKeys[target];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    _initialJumpDone = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        alignment: 0.1,
      );
    });
  }

  void _showSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => const _ReaderSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncSurah = ref.watch(surahDetailProvider(widget.surahId));
    final prefs = ref.watch(readerPreferencesControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: asyncSurah.when(
        data: (surah) {
          // Build keys lazily; reset if surah changes.
          for (final v in surah.verses) {
            _ayahKeys.putIfAbsent(v.verseNumber, () => GlobalKey());
          }
          // Initial scroll-to-ayah after first frame.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _jumpToAyahIfNeeded();
          });
          return _ReaderBody(
            surah: surah,
            scrollCtrl: _scrollCtrl,
            ayahKeys: _ayahKeys,
            arabicFontSize: prefs.arabicFontSize,
            showTranslation: prefs.showTranslation,
            visibleAyah: _visibleAyah,
            onSettings: _showSettings,
          );
        },
        loading: () => const _ReaderLoading(),
        error: (e, _) => _ReaderError(
          message: e.toString(),
          onRetry: () => ref.invalidate(surahDetailProvider(widget.surahId)),
        ),
      ),
      bottomNavigationBar: asyncSurah.when(
        data: (surah) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            0,
            AppSpacing.screenEdge,
            AppSpacing.base,
          ),
          child: AudioMiniPlayer(surahName: surah.nameEnglish),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _ReaderBody extends ConsumerWidget {
  const _ReaderBody({
    required this.surah,
    required this.scrollCtrl,
    required this.ayahKeys,
    required this.arabicFontSize,
    required this.showTranslation,
    required this.visibleAyah,
    required this.onSettings,
  });

  final SurahDetail surah;
  final ScrollController scrollCtrl;
  final Map<int, GlobalKey> ayahKeys;
  final double arabicFontSize;
  final bool showTranslation;
  final int visibleAyah;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioControllerProvider);
    final bookmarks =
        ref.watch(bookmarksControllerProvider).valueOrNull ?? const [];

    return CustomScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        ReaderTopBar(
          title: surah.nameEnglish,
          subtitle: 'Verse $visibleAyah of ${surah.verses.length}',
          onBack: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) context.pop();
          },
          onSettings: onSettings,
        ),
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.xxl,
                AppSpacing.screenEdge,
                AppSpacing.lg,
              ),
              child: _SurahHeader(surah: surah),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          sliver: SliverList.separated(
            itemCount: surah.verses.length,
            separatorBuilder: (_, __) => Divider(
              height: AppSpacing.lg,
              color: Theme.of(context).colorScheme.outline,
            ),
            itemBuilder: (context, index) {
              final verse = surah.verses[index];
              final isPlaying =
                  audio.currentSurah == surah.id &&
                  audio.currentAyah == verse.verseNumber;
              final isBookmarked = bookmarks.any(
                (b) =>
                    b.surahId == surah.id && b.verseNumber == verse.verseNumber,
              );
              return KeyedSubtree(
                key: ayahKeys[verse.verseNumber],
                child: AyahView(
                  verse: verse,
                  arabicFontSize: arabicFontSize,
                  showTranslation: showTranslation,
                  isPlaying: isPlaying,
                  isBookmarked: isBookmarked,
                  onTap: () => AyahActionSheet.show(
                    context,
                    verse: verse,
                    surahId: surah.id,
                    surahName: surah.nameEnglish,
                    totalVerses: surah.verses.length,
                  ),
                  onLongPress: () => AyahActionSheet.show(
                    context,
                    verse: verse,
                    surahId: surah.id,
                    surahName: surah.nameEnglish,
                    totalVerses: surah.verses.length,
                  ),
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: Gap(AppSpacing.xxxl)),
      ],
    );
  }
}

class _SurahHeader extends ConsumerWidget {
  const _SurahHeader({required this.surah});

  final SurahDetail surah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // At-Tawbah (9) does not begin with Bismillah.
    final showBismillah = surah.id != 9;

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            surah.nameArabic,
            textAlign: TextAlign.center,
            style: arabicTextStyleOf(
              ref,
              fontSize: 32,
              height: 1.6,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(surah.nameEnglish, style: theme.textTheme.bodyMedium),
        if (showBismillah) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: cs.secondary.withValues(alpha: 0.4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                    style: arabicTextStyleOf(
                      ref,
                      fontSize: 22,
                      height: 1.8,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: cs.secondary.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ReaderSettingsSheet extends ConsumerWidget {
  const _ReaderSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final prefs = ref.watch(readerPreferencesControllerProvider);
    final ctrl = ref.read(readerPreferencesControllerProvider.notifier);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.base,
          AppSpacing.screenEdge,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outline,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Text('Reader settings', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            Text('Arabic font size', style: theme.textTheme.labelLarge),
            Slider(
              value: prefs.arabicFontSize,
              min: 24,
              max: 40,
              divisions: 16,
              label: prefs.arabicFontSize.round().toString(),
              onChanged: (v) {
                HapticFeedback.selectionClick();
                ctrl.setFontSize(v);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: prefs.showTranslation,
              title: Text(
                'Show translation',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                'English translation under each ayah',
                style: theme.textTheme.bodySmall,
              ),
              onChanged: (_) {
                HapticFeedback.selectionClick();
                ctrl.toggleTranslation();
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.translate, color: cs.onSurfaceVariant),
              title: Text(
                'Transliteration',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text('Coming soon', style: theme.textTheme.bodySmall),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderLoading extends StatelessWidget {
  const _ReaderLoading();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
          vertical: AppSpacing.lg,
        ),
        child: Shimmer.fromColors(
          baseColor: cs.surface,
          highlightColor: cs.primaryContainer.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              const Gap(AppSpacing.xl),
              for (var i = 0; i < 6; i++) ...[
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: cs.outline),
                  ),
                ),
                const Gap(AppSpacing.base),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReaderError extends StatelessWidget {
  const _ReaderError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 36,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const Gap(AppSpacing.base),
              Text(
                'We couldn\'t load this surah.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(4),
              Text(
                message,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.base),
              FilledButton.tonal(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  onRetry();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
