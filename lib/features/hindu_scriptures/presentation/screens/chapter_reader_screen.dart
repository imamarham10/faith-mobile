import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_recorder.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/scripture_chapter.dart';
import '../../domain/chapter_reading_route.dart';
import '../../domain/shloka_action_target.dart';
import '../../domain/shloka_ref.dart';
import '../controllers/chapter_controller.dart';
import '../controllers/scripture_audio_controller.dart';
import '../controllers/scripture_bookmarks_controller.dart';
import '../controllers/hindu_scriptures_home_controller.dart';
import '../widgets/audio_mini_player.dart';
import '../widgets/verse_action_sheet.dart';
import '../widgets/verse_view.dart';
import '../../../quran/presentation/widgets/reader_top_bar.dart';
import '../../../../shared/reader/reading_mode_controller.dart';

/// `/quran/hindu-scripture/:slug/:chapter` — continuous reader for one chapter,
/// mirroring `surah_reader_screen.dart` structurally: scroll-tracked
/// last-read position, optional `?verse=` initial jump, audio mini-player.
class ChapterReaderScreen extends ConsumerStatefulWidget {
  const ChapterReaderScreen({
    super.key,
    required this.textSlug,
    required this.chapterNumber,
    this.initialVerse,
  });

  final String textSlug;
  final int chapterNumber;
  final int? initialVerse;

  @override
  ConsumerState<ChapterReaderScreen> createState() =>
      _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends ConsumerState<ChapterReaderScreen> {
  final _scrollCtrl = ScrollController();
  final _verseKeys = <int, GlobalKey>{};
  Timer? _scrollDebounce;
  int _visibleVerse = 1;
  bool _initialJumpDone = false;

  /// Verses already told to the activity engine this session.
  final _recordedVerses = <int>{};

  @override
  void initState() {
    super.initState();
    _visibleVerse = widget.initialVerse ?? 1;
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
    final verse = _topMostVisibleVerse();
    if (verse == null) return;
    _visibleVerse = verse;
    // The Islam reader's twin, for the reason given there: the book's name
    // and the chapter's length travel with the pointer so Today's
    // continue-reading card needs no network read above the habit loop.
    // Both providers are already watched by the body this scroll came
    // from, so these are reads of resolved state, not fetches.
    final text = ref
        .read(scriptureTextDetailProvider(widget.textSlug))
        .valueOrNull;
    final chapter = ref
        .read(chapterDetailProvider(widget.textSlug, widget.chapterNumber))
        .valueOrNull;
    ref
        .read(scriptureLastReadControllerProvider.notifier)
        .save(
          textSlug: widget.textSlug,
          chapterNumber: widget.chapterNumber,
          verseNumber: verse,
          textName: text?.nameEnglish,
          chapterVerseCount: chapter?.verses.length,
        );
    _recordVerse(verse);
  }

  /// Records one `gita_shloka` the first time [verse] settles at the top.
  ///
  /// The Islam reader's twin — same debounce, same once-per-session set,
  /// same deliberate under-count on a fling, and since the pager landed,
  /// the same **deterministic dedupe key**. Parity in the *definition* of
  /// what counts is what makes the two faiths' streaks comparable, and no
  /// test catches a parity break in a definition.
  ///
  /// Both strings come from `shloka_ref.dart` and are never assembled here,
  /// for the reason that file gives: this screen and the pager must name
  /// 2:47 identically or a verse read in both on one day counts twice.
  /// Note they are two different strings — the dedupe key always exists,
  /// the §1.6 `sourceRef` only for the Gita.
  void _recordVerse(int verse) {
    if (!_recordedVerses.add(verse)) return;
    unawaited(
      ref
          .read(activityRecorderProvider)
          .record(
            ActivityType.gitaShloka,
            sourceRef: shlokaSourceRef(
              textSlug: widget.textSlug,
              chapterNumber: widget.chapterNumber,
              verseNumber: verse,
            ),
            dedupeKey: shlokaDedupeKey(
              textSlug: widget.textSlug,
              chapterNumber: widget.chapterNumber,
              verseNumber: verse,
            ),
          ),
    );
  }

  int? _topMostVisibleVerse() {
    final scrollOffset = _scrollCtrl.hasClients ? _scrollCtrl.offset : 0.0;
    int? best;
    double? bestDelta;
    _verseKeys.forEach((number, key) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) return;
      final position = box.localToGlobal(Offset.zero).dy;
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

  void _jumpToVerseIfNeeded() {
    if (_initialJumpDone) return;
    final target = widget.initialVerse;
    if (target == null || target <= 1) {
      _initialJumpDone = true;
      return;
    }
    final key = _verseKeys[target];
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

  /// Reopens this chapter in the pager at the verse on screen, and makes
  /// that the remembered default — for both verticals, since the preference
  /// is about how you read and not what you are reading.
  void _switchToVerseMode() {
    HapticFeedback.selectionClick();
    ref
        .read(readingModeControllerProvider.notifier)
        .set(ReadingMode.verseByVerse);
    context.pushReplacement(
      chapterReadingRoute(
        widget.textSlug,
        widget.chapterNumber,
        mode: ReadingMode.verseByVerse,
        verse: _visibleVerse,
      ),
    );
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
    final asyncChapter = ref.watch(
      chapterDetailProvider(widget.textSlug, widget.chapterNumber),
    );
    final prefs = ref.watch(scriptureReaderPreferencesControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: asyncChapter.when(
        data: (chapter) {
          for (final v in chapter.verses) {
            _verseKeys.putIfAbsent(v.verseNumber, () => GlobalKey());
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _jumpToVerseIfNeeded();
          });
          return _ReaderBody(
            textSlug: widget.textSlug,
            chapter: chapter,
            scrollCtrl: _scrollCtrl,
            verseKeys: _verseKeys,
            sanskritFontSize: prefs.sanskritFontSize,
            showTranslation: prefs.showTranslation,
            visibleVerse: _visibleVerse,
            onSettings: _showSettings,
            onSwitchMode: _switchToVerseMode,
          );
        },
        loading: () => const _ReaderLoading(),
        error: (e, _) => _ReaderError(
          message: e.toString(),
          onRetry: () => ref.invalidate(
            chapterDetailProvider(widget.textSlug, widget.chapterNumber),
          ),
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          0,
          AppSpacing.screenEdge,
          AppSpacing.base,
        ),
        child: AudioMiniPlayer(),
      ),
    );
  }
}

class _ReaderBody extends ConsumerWidget {
  const _ReaderBody({
    required this.textSlug,
    required this.chapter,
    required this.scrollCtrl,
    required this.verseKeys,
    required this.sanskritFontSize,
    required this.showTranslation,
    required this.visibleVerse,
    required this.onSettings,
    required this.onSwitchMode,
  });

  final String textSlug;
  final ChapterDetail chapter;
  final ScrollController scrollCtrl;
  final Map<int, GlobalKey> verseKeys;
  final double sanskritFontSize;
  final bool showTranslation;
  final int visibleVerse;
  final VoidCallback onSettings;
  final VoidCallback onSwitchMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(scriptureAudioControllerProvider);
    final bookmarks =
        ref.watch(scriptureBookmarksControllerProvider).valueOrNull ?? const [];
    final chapterTitle =
        chapter.nameEnglish ?? 'Chapter ${chapter.chapterNumber}';
    // The book's name, for the sheet's label and the share attribution —
    // the chapter payload does not carry it. Resolved the same way, and
    // with the same fallback, as the pager does.
    final textName =
        ref.watch(scriptureTextDetailProvider(textSlug)).valueOrNull
            ?.nameEnglish ??
        chapterTitle;
    final isChapterPlaying =
        audio.currentTextSlug == textSlug &&
        audio.currentChapterNumber == chapter.chapterNumber;

    return CustomScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        ReaderTopBar(
          title: chapterTitle,
          subtitle: 'Verse $visibleVerse of ${chapter.verses.length}',
          onBack: () {
            HapticFeedback.lightImpact();
            if (context.canPop()) context.pop();
          },
          onSettings: onSettings,
          onSwitchMode: onSwitchMode,
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
              child: _ChapterHeader(
                chapter: chapter,
                isPlaying: isChapterPlaying && audio.isPlaying,
                onPlay: () {
                  HapticFeedback.lightImpact();
                  ref
                      .read(scriptureAudioControllerProvider.notifier)
                      .playChapter(
                        textSlug: textSlug,
                        chapterNumber: chapter.chapterNumber,
                        chapterTitle: chapterTitle,
                      );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          sliver: SliverList.separated(
            itemCount: chapter.verses.length,
            separatorBuilder: (_, __) => Divider(
              height: AppSpacing.lg,
              color: Theme.of(context).colorScheme.outline,
            ),
            itemBuilder: (context, index) {
              final verse = chapter.verses[index];
              final isPlaying = isChapterPlaying && audio.isPlaying;
              final isBookmarked = bookmarks.any((b) => b.verseId == verse.id);
              return KeyedSubtree(
                key: verseKeys[verse.verseNumber],
                child: VerseView(
                  verse: verse,
                  sanskritFontSize: sanskritFontSize,
                  showTranslation: showTranslation,
                  isPlaying: isPlaying,
                  isBookmarked: isBookmarked,
                  onTap: () => VerseActionSheet.show(
                    context,
                    target: ShlokaActionTarget.fromVerse(
                      verse,
                      textSlug: textSlug,
                      textName: textName,
                      chapterNumber: chapter.chapterNumber,
                      chapterTitle: chapterTitle,
                    ),
                  ),
                  onLongPress: () => VerseActionSheet.show(
                    context,
                    target: ShlokaActionTarget.fromVerse(
                      verse,
                      textSlug: textSlug,
                      textName: textName,
                      chapterNumber: chapter.chapterNumber,
                      chapterTitle: chapterTitle,
                    ),
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

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({
    required this.chapter,
    required this.isPlaying,
    required this.onPlay,
  });

  final ChapterDetail chapter;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        if ((chapter.nameSanskrit ?? '').isNotEmpty)
          Text(
            chapter.nameSanskrit!,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
        const SizedBox(height: 4),
        Text(
          chapter.nameEnglish ?? 'Chapter ${chapter.chapterNumber}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        IconButton.filledTonal(
          onPressed: onPlay,
          icon: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: cs.primary,
          ),
        ),
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
    final prefs = ref.watch(scriptureReaderPreferencesControllerProvider);
    final ctrl = ref.read(
      scriptureReaderPreferencesControllerProvider.notifier,
    );

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
            Text('Sanskrit font size', style: theme.textTheme.labelLarge),
            Slider(
              value: prefs.sanskritFontSize,
              min: 20,
              max: 36,
              divisions: 16,
              label: prefs.sanskritFontSize.round().toString(),
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
                'English translation under each verse',
                style: theme.textTheme.bodySmall,
              ),
              onChanged: (_) {
                HapticFeedback.selectionClick();
                ctrl.toggleTranslation();
              },
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: PoppySkeleton(height: 28, radius: AppRadius.sm),
            ),
            const Gap(AppSpacing.xl),
            for (var i = 0; i < 6; i++) ...[
              const PoppySkeleton(height: 80, radius: AppRadius.md),
              const Gap(AppSpacing.base),
            ],
          ],
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
                'We couldn\'t load this chapter.',
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
              PoppyButton(label: 'Retry', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
