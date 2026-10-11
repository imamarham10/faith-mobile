import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/reader/reading_mode_controller.dart';
import '../../../../shared/reader/verse_page.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../data/dtos/scripture_verse.dart';
import '../../domain/chapter_reading_route.dart';
import '../../domain/shloka_action_target.dart';
import '../../domain/shloka_ref.dart';
import '../controllers/chapter_controller.dart';
import '../controllers/hindu_scriptures_home_controller.dart';
import '../widgets/audio_mini_player.dart';
import '../widgets/shloka_actions.dart';
import '../widgets/shloka_verse_surface.dart';

/// `/quran/hindu-scripture/:slug/:chapter/verses` — one śloka at a time.
///
/// ## Why this is not the Qur'an reader with a different argument
///
/// It is the same *view* — `shared/reader/verse_page.dart` draws every
/// pixel of it, exactly as it draws the juz and surah pagers — and a
/// different everything else. A Gita chapter arrives whole from one
/// `GET /texts/:slug/chapters/:n`, so there is no paging, no sparse page
/// map, no prefetch and no cursor translation: the state here is an index
/// into a list, which is less machinery than the juz reader has and not
/// more. The honest shared thing is the view, and that is what is shared.
///
/// ## Where it stops
///
/// At the ends of the chapter, both of them. Next does not roll into
/// chapter 3 any more than the surah pager rolls into the next surah — the
/// chapter is the unit a reader chose to open, and silently leaving it
/// would make "I read chapter 2 today" untrue. The chapter picker is one
/// Back away.
///
/// ## Query parameters
///
/// * `?from=<n>` — open on verse n. The chapter stays whole; Next runs to
///   its end.
/// * `?from=<a>&to=<b>` — fence the reader to a span, for a curated passage.
///
/// Both are clamped to what the chapter actually contains, so a stale link
/// opens the chapter rather than an error.
class ChapterVerseReaderScreen extends ConsumerStatefulWidget {
  const ChapterVerseReaderScreen({
    super.key,
    required this.textSlug,
    required this.chapterNumber,
    this.from,
    this.to,
  });

  final String textSlug;
  final int chapterNumber;
  final int? from;
  final int? to;

  @override
  ConsumerState<ChapterVerseReaderScreen> createState() =>
      _ChapterVerseReaderScreenState();
}

class _ChapterVerseReaderScreenState
    extends ConsumerState<ChapterVerseReaderScreen> {
  /// Index into the window of verses this reader is showing — which is the
  /// whole chapter unless `to` fenced it.
  int _cursor = 0;

  /// Set once the chapter has arrived and the opening verse has been
  /// located. Without it, every rebuild would drag the cursor back to
  /// `from`.
  bool _positioned = false;

  final _scrollCtrl = ScrollController();

  /// Mirrors the scrolling reader's 350ms settle before writing the
  /// last-read pointer, so holding Next through a chapter writes once
  /// rather than once per verse.
  Timer? _lastReadDebounce;

  @override
  void dispose() {
    _lastReadDebounce?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _move(int delta, int windowLength) {
    final next = _cursor + delta;
    if (next < 0 || next >= windowLength) return;
    setState(() => _cursor = next);
    // A new verse starts where a verse starts — the scroll view is one
    // element reused across verses, so without this a long śloka with
    // commentary leaves the next one opening part way down.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      _scrollCtrl.jumpTo(0);
    });
  }

  void _rememberLastRead(int verseNumber) {
    _lastReadDebounce?.cancel();
    _lastReadDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      // Already watched by this screen's `build` — see the twin comment in
      // `chapter_reader_screen.dart`.
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
            verseNumber: verseNumber,
            textName: text?.nameEnglish,
            chapterVerseCount: chapter?.verses.length,
          );
    });
  }

  /// Reopens this chapter in the scrolling reader at the verse on screen,
  /// and makes that the remembered default — for both verticals, since the
  /// preference is about how you read and not what you are reading.
  void _switchToContinuous(int verseNumber) {
    HapticFeedback.selectionClick();
    ref
        .read(readingModeControllerProvider.notifier)
        .set(ReadingMode.continuous);
    context.pushReplacement(
      chapterReadingRoute(
        widget.textSlug,
        widget.chapterNumber,
        mode: ReadingMode.continuous,
        verse: verseNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      chapterDetailProvider(widget.textSlug, widget.chapterNumber),
    );
    // The chapter payload names the chapter but not the book it is in, and
    // "Bhagavad Gita · 2:47" is what a share card and a bookmark should
    // say. `keepAlive` and already warm whenever the chapter picker was the
    // way in; `valueOrNull` because a deep link straight here must not wait
    // on it, and the chapter title is a usable stand-in until it lands.
    final textName = ref
        .watch(scriptureTextDetailProvider(widget.textSlug))
        .valueOrNull
        ?.nameEnglish;

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const _Chrome(title: 'Loading', body: _Loading()),
          error: (e, _) => _Chrome(
            title: 'Chapter ${widget.chapterNumber}',
            body: _Error(
              message: e.toString(),
              onRetry: () => ref.invalidate(
                chapterDetailProvider(widget.textSlug, widget.chapterNumber),
              ),
            ),
          ),
          data: (chapter) {
            final chapterTitle =
                chapter.nameEnglish ?? 'Chapter ${chapter.chapterNumber}';
            final window = _window(chapter.verses);
            if (window.isEmpty) {
              return _Chrome(
                title: chapterTitle,
                body: _Error(
                  message: 'This chapter has no verses to show.',
                  onRetry: () => ref.invalidate(
                    chapterDetailProvider(
                      widget.textSlug,
                      widget.chapterNumber,
                    ),
                  ),
                ),
              );
            }
            if (!_positioned) {
              _positioned = true;
              _cursor = _openingIndex(window);
            }
            final cursor = _cursor.clamp(0, window.length - 1);
            final verse = window[cursor];
            _rememberLastRead(verse.verseNumber);

            return _Chrome(
              title: chapterTitle,
              onSwitchMode: () => _switchToContinuous(verse.verseNumber),
              // Pinned above Back/Next rather than scrolled with the verse.
              // A śloka plus its commentary runs long, and a row under it
              // took three swipes to reach on device in the Qur'an reader
              // before it was pinned there for the same reason.
              actionBar: ShlokaActionBar(
                target: ShlokaActionTarget.fromVerse(
                  verse,
                  textSlug: widget.textSlug,
                  textName: textName ?? chapterTitle,
                  chapterNumber: widget.chapterNumber,
                  chapterTitle: chapterTitle,
                ),
              ),
              navBar: VerseNavBar(
                canGoBack: cursor > 0,
                canGoForward: cursor < window.length - 1,
                onBack: () => _move(-1, window.length),
                onForward: () => _move(1, window.length),
              ),
              body: VerseReadRecorder(
                activityType: ActivityType.gitaShloka,
                dedupeKey: shlokaDedupeKey(
                  textSlug: widget.textSlug,
                  chapterNumber: widget.chapterNumber,
                  verseNumber: verse.verseNumber,
                ),
                sourceRef: shlokaSourceRef(
                  textSlug: widget.textSlug,
                  chapterNumber: widget.chapterNumber,
                  verseNumber: verse.verseNumber,
                ),
                logName: 'hindu.chapterVerses',
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  // No horizontal padding: the verse surface below bleeds to
                  // both screen edges, which is the one thing a card never
                  // does, and wrapping it in page padding would defeat that.
                  padding: const EdgeInsets.only(
                    top: AppSpacing.base,
                    bottom: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenEdge,
                        ),
                        child: VerseProgress(
                          label: _progressLabel(
                            chapterTitle: chapterTitle,
                            cursor: cursor,
                            length: window.length,
                          ),
                          value: (cursor + 1) / window.length,
                        ),
                      ),
                      const Gap(AppSpacing.lg),
                      // Keyed on the verse so each step cross-fades rather
                      // than swapping text under the reader's eye.
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        child: ShlokaVerseSurface(
                          key: ValueKey(verse.verseNumber),
                          positionLine:
                              '$chapterTitle  ·  '
                              '${verse.verseNumber}/${chapter.verses.length}',
                          sanskritText: verse.sanskritText,
                          transliteration: verse.transliteration,
                          translation: verse.translations.isNotEmpty
                              ? verse.translations.first.text
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// The verses this reader may show: the whole chapter, or the fenced span.
  List<ScriptureVerse> _window(List<ScriptureVerse> verses) {
    final to = widget.to;
    if (to == null) return verses;
    final from = widget.from ?? 1;
    final fenced = verses
        .where((v) => v.verseNumber >= from && v.verseNumber <= to)
        .toList(growable: false);
    // A span that matched nothing — a bad link, or a chapter shorter than
    // the numbers claimed — falls back to the whole chapter rather than to
    // an empty reader.
    return fenced.isEmpty ? verses : fenced;
  }

  /// Where the cursor starts. `from` with no `to` points *into* a whole
  /// chapter; with a `to` the window already begins there.
  int _openingIndex(List<ScriptureVerse> window) {
    final from = widget.from;
    if (from == null) return 0;
    final index = window.indexWhere((v) => v.verseNumber == from);
    return index < 0 ? 0 : index;
  }

  String _progressLabel({
    required String chapterTitle,
    required int cursor,
    required int length,
  }) {
    final left = length - cursor - 1;
    final from = widget.from ?? 1;
    // "20–22" for a span, but plainly "47" for a span of one — a range
    // whose ends are the same number reads as a typo.
    final span = from == widget.to ? '$from' : '$from–${widget.to}';
    final head = widget.to == null ? chapterTitle : '$chapterTitle  ·  $span';
    if (left == 0) return '$head  ·  Last verse';
    return '$head  ·  $left ${left == 1 ? 'verse' : 'verses'} left';
  }
}

/// Top bar, body, optional bars — the one column shape all three states of
/// this screen share, so the back button never moves between them.
class _Chrome extends StatelessWidget {
  const _Chrome({
    required this.title,
    required this.body,
    this.actionBar,
    this.navBar,
    this.onSwitchMode,
  });

  final String title;
  final Widget body;
  final Widget? actionBar;
  final Widget? navBar;
  final VoidCallback? onSwitchMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                tooltip: 'Back',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (context.canPop()) context.pop();
                },
              ),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onSwitchMode != null)
                IconButton(
                  icon: const Icon(Icons.notes_rounded, size: 22),
                  tooltip: 'Read as one scroll',
                  onPressed: onSwitchMode,
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(child: body),
        // Renders nothing until a narration is loaded, so the reader keeps
        // its full height until the moment there is something to control.
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.sm,
            AppSpacing.screenEdge,
            0,
          ),
          child: AudioMiniPlayer(),
        ),
        if (actionBar != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: actionBar,
          ),
        if (navBar != null) navBar!,
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.base,
        AppSpacing.screenEdge,
        AppSpacing.xl,
      ),
      child: VerseSkeleton(),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});

  final String message;
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
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.base),
          Text(
            "We couldn't load this chapter.",
            style: theme.textTheme.titleMedium,
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
    );
  }
}
