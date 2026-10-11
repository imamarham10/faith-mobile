import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../data/dtos/verse.dart';
import '../../domain/ayah_action_target.dart';
import '../../domain/quran_verse_ref.dart';
import '../../domain/reading_mode.dart';
import '../controllers/quran_home_controller.dart';
import '../controllers/reading_mode_controller.dart';
import '../controllers/surah_controller.dart';
import '../widgets/ayah_actions.dart';
import '../widgets/verse_page.dart';

/// `/quran/surah/:id/verses` — one verse of a surah at a time.
///
/// ## Why this is not the juz reader with a different argument
///
/// The two readers look identical and share every pixel of their
/// presentation (`verse_page.dart`), but they fetch nothing alike.
/// `JuzReaderController` pages `GET /juz/:n?page=` by an index that spans
/// surahs, keeps a sparse page map, and prefetches a page ahead; this
/// screen's verses all arrive in the single `GET /surah/:id` the scrolling
/// reader already loads and caches `keepAlive`. There is no paging to do,
/// no cursor translation, and no boundary to cross — so there is no state
/// machine here at all, only an index into a list.
///
/// Forcing one controller over both would mean inventing pages for a
/// payload that has none. The honest shared thing is the *view*, and that
/// is what is shared.
///
/// ## Query parameters
///
/// * `?from=<n>` — open on verse n. The surah stays whole; Next runs to its
///   end.
/// * `?from=<a>&to=<b>` — fence the reader to a span, for a curated passage
///   like Al-Baqarah 285–286. Back and Next stop at the ends, and the
///   progress line counts the span rather than the surah.
///
/// Both are clamped to what the surah actually contains, so a stale link
/// opens the surah rather than an error.
class SurahVerseReaderScreen extends ConsumerStatefulWidget {
  const SurahVerseReaderScreen({
    super.key,
    required this.surahId,
    this.from,
    this.to,
  });

  final int surahId;
  final int? from;
  final int? to;

  @override
  ConsumerState<SurahVerseReaderScreen> createState() =>
      _SurahVerseReaderScreenState();
}

class _SurahVerseReaderScreenState
    extends ConsumerState<SurahVerseReaderScreen> {
  /// Index into the window of verses this reader is showing — which is the
  /// whole surah unless `to` fenced it.
  int _cursor = 0;

  /// Set once the surah has arrived and the opening verse has been located.
  /// Without it, every rebuild would drag the cursor back to `from`.
  bool _positioned = false;

  final _scrollCtrl = ScrollController();

  /// Mirrors the scrolling reader's 350ms settle before writing the
  /// last-read pointer, so holding Next through a surah writes once rather
  /// than once per verse.
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
    // element reused across verses, so without this a long verse leaves the
    // next one opening part way down.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      _scrollCtrl.jumpTo(0);
    });
  }

  void _rememberLastRead(int verseNumber) {
    _lastReadDebounce?.cancel();
    _lastReadDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      ref
          .read(lastReadControllerProvider.notifier)
          .save(surahId: widget.surahId, verseNumber: verseNumber);
    });
  }

  /// Reopens this surah in the scrolling reader at the verse on screen, and
  /// makes that the remembered default.
  void _switchToContinuous(int verseNumber) {
    HapticFeedback.selectionClick();
    ref
        .read(readingModeControllerProvider.notifier)
        .set(ReadingMode.continuous);
    context.pushReplacement(
      surahReadingRoute(
        widget.surahId,
        mode: ReadingMode.continuous,
        ayah: verseNumber > 1 ? verseNumber : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(surahDetailProvider(widget.surahId));

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const _Chrome(title: 'Loading', body: _Loading()),
          error: (e, _) => _Chrome(
            title: 'Surah ${widget.surahId}',
            body: _Error(
              message: e.toString(),
              onRetry: () =>
                  ref.invalidate(surahDetailProvider(widget.surahId)),
            ),
          ),
          data: (surah) {
            final window = _window(surah.verses);
            if (window.isEmpty) {
              return _Chrome(
                title: surah.nameEnglish,
                body: _Error(
                  message: 'This surah has no verses to show.',
                  onRetry: () =>
                      ref.invalidate(surahDetailProvider(widget.surahId)),
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
              title: surah.nameEnglish,
              onSwitchMode: () => _switchToContinuous(verse.verseNumber),
              navBar: VerseNavBar(
                canGoBack: cursor > 0,
                canGoForward: cursor < window.length - 1,
                onBack: () => _move(-1, window.length),
                onForward: () => _move(1, window.length),
              ),
              body: VerseReadRecorder(
                sourceRef: quranVerseRef(
                  surahId: widget.surahId,
                  verseNumber: verse.verseNumber,
                ),
                logName: 'quran.surahVerses',
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
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
                            surahName: surah.nameEnglish,
                            cursor: cursor,
                            length: window.length,
                          ),
                          value: (cursor + 1) / window.length,
                        ),
                      ),
                      const Gap(AppSpacing.lg),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        child: VerseSurface(
                          key: ValueKey(verse.verseNumber),
                          positionLine:
                              '${widget.surahId}. ${surah.nameEnglish}  ·  '
                              '${verse.verseNumber}/${surah.verses.length}',
                          textArabic: verse.textArabic,
                          textIndopak: verse.textIndopak,
                          translation: verse.translations.isNotEmpty
                              ? verse.translations.first.text
                              : null,
                        ),
                      ),
                      const Gap(AppSpacing.lg),
                      AyahActionBar(
                        target: AyahActionTarget.fromVerse(
                          verse,
                          surahId: widget.surahId,
                          surahName: surah.nameEnglish,
                          totalVerses: surah.verses.length,
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

  /// The verses this reader may show: the whole surah, or the fenced span.
  List<Verse> _window(List<Verse> verses) {
    final to = widget.to;
    if (to == null) return verses;
    final from = widget.from ?? 1;
    final fenced = verses
        .where((v) => v.verseNumber >= from && v.verseNumber <= to)
        .toList(growable: false);
    // A span that matched nothing — a bad link, or a surah shorter than the
    // numbers claimed — falls back to the whole surah rather than to an
    // empty reader.
    return fenced.isEmpty ? verses : fenced;
  }

  /// Where the cursor starts. `from` with no `to` points *into* a whole
  /// surah; with a `to` the window already begins there.
  int _openingIndex(List<Verse> window) {
    final from = widget.from;
    if (from == null) return 0;
    final index = window.indexWhere((v) => v.verseNumber == from);
    return index < 0 ? 0 : index;
  }

  String _progressLabel({
    required String surahName,
    required int cursor,
    required int length,
  }) {
    final left = length - cursor - 1;
    final from = widget.from ?? 1;
    // "285–286" for a span, but plainly "255" for a span of one — a range
    // whose ends are the same number reads as a typo, and the single-verse
    // collection items (Ayat al-Kursi) all arrive that way.
    final span = from == widget.to ? '$from' : '$from–${widget.to}';
    final head = widget.to == null ? surahName : '$surahName  ·  $span';
    if (left == 0) return '$head  ·  Last verse';
    return '$head  ·  $left ${left == 1 ? 'verse' : 'verses'} left';
  }
}

/// Top bar, body, optional nav bar — the one column shape all three states
/// of this screen share, so the back button never moves between them.
class _Chrome extends StatelessWidget {
  const _Chrome({
    required this.title,
    required this.body,
    this.navBar,
    this.onSwitchMode,
  });

  final String title;
  final Widget body;
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
            "We couldn't load this surah.",
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
