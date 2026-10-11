import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../data/dtos/juz.dart';
import '../../data/dtos/surah.dart';
import '../../domain/ayah_action_target.dart';
import '../../domain/quran_verse_ref.dart';
import '../controllers/juz_reader_controller.dart';
import '../controllers/quran_home_controller.dart';
import '../widgets/ayah_actions.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/reader/verse_page.dart';
import '../widgets/quran_verse_surface.dart';

/// `/quran/juz/:number` — one verse at a time, back and forward.
///
/// Everything this screen is made of — the verse surface, the progress
/// rule, the Back/Next pair, the dwell recorder — lives in `shared/reader/verse_page.dart`
/// and is shared with `/quran/surah/:id/verses`. See that file for why the
/// verse sits on a page rather than in a card, and `AyahActionBar` for why
/// the per-verse actions are visible here where the continuous reader hides
/// them behind a long-press.
class JuzReaderScreen extends ConsumerWidget {
  const JuzReaderScreen({super.key, required this.juzNumber});

  final int juzNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = juzReaderControllerProvider(juzNumber);
    final async = ref.watch(provider);
    final verse = async.valueOrNull?.currentVerse;

    // The juz payload names the surah but does not say how long it is, and
    // both "148/286" and the point at which recitation stops advancing need
    // the 286. It comes from the 114-surah index, which the Qur'an tab has
    // already loaded by the time anyone reaches this screen. If it somehow
    // has not, the position degrades to "148" rather than holding the verse
    // back for it.
    final surahs = ref.watch(surahListProvider).valueOrNull;
    final surahVerseCount = verse == null
        ? null
        : _verseCountFor(surahs, verse.surahId);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _JuzTopBar(
              juzNumber: juzNumber,
              onBack: () {
                HapticFeedback.lightImpact();
                if (context.canPop()) context.pop();
              },
            ),
            Expanded(
              child: async.when(
                data: (state) =>
                    _ReaderBody(state: state, surahVerseCount: surahVerseCount),
                loading: () => const _ReaderLoading(),
                error: (e, _) => _ReaderError(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(provider),
                ),
              ),
            ),
            // Pinned, not scrolled with the verse. 2:282 is 1,500 words and
            // the longest ayah in the Qur'an; a row that sat under it would
            // take three screens of scrolling to reach, which is no more
            // discoverable than the long-press this replaced. Above the
            // Back/Next pair the two make one bottom control stack, in the
            // same place on every verse.
            if (verse != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: AyahActionBar(
                  target: AyahActionTarget.fromJuzVerse(
                    verse,
                    totalVerses: surahVerseCount,
                  ),
                ),
              ),
            if (async.hasValue)
              VerseNavBar(
                canGoBack: async.requireValue.canGoBack,
                canGoForward: async.requireValue.canGoForward,
                onBack: ref.read(provider.notifier).previous,
                onForward: ref.read(provider.notifier).next,
              ),
          ],
        ),
      ),
    );
  }

  static int? _verseCountFor(List<Surah>? surahs, int surahId) {
    if (surahs == null) return null;
    for (final s in surahs) {
      if (s.id == surahId) return s.verseCount;
    }
    return null;
  }
}

class _JuzTopBar extends StatelessWidget {
  const _JuzTopBar({required this.juzNumber, required this.onBack});

  final int juzNumber;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
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
            onPressed: onBack,
            tooltip: 'Back',
          ),
          Expanded(
            child: Text(
              'Juz $juzNumber',
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ReaderBody extends ConsumerStatefulWidget {
  const _ReaderBody({required this.state, required this.surahVerseCount});

  final JuzReaderState state;

  /// Length of the surah the verse on screen belongs to, resolved by the
  /// screen above (which also needs it for the action bar). Null only while
  /// the 114-surah index has not loaded.
  final int? surahVerseCount;

  @override
  ConsumerState<_ReaderBody> createState() => _ReaderBodyState();
}

class _ReaderBodyState extends ConsumerState<_ReaderBody> {
  /// Owned here so a new verse can start where a verse starts.
  ///
  /// The scroll view is one element reused across verses — only its child
  /// is swapped — so without this the offset carries over. 2:282 is the
  /// longest verse in the Qur'an and sits in juz 3, well inside the range
  /// someone reads this way, and the verse after it would otherwise open
  /// scrolled into its middle (or, being shorter, at a clamped offset part
  /// way down).
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ReaderBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.cursor == widget.state.cursor) return;
    // After the frame, not during it: jumping mid-build can rebuild the
    // Scrollable that is already building. One frame at the old offset is
    // invisible under the 180ms cross-fade.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      _scrollCtrl.jumpTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final verse = state.currentVerse;
    final sourceRef = verse == null
        ? null
        : quranVerseRef(surahId: verse.surahId, verseNumber: verse.verseNumber);

    return VerseReadRecorder(
      activityType: ActivityType.quranVerse,
      dedupeKey: sourceRef,
      sourceRef: sourceRef,
      logName: 'quran.juz',
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        // No horizontal padding: the verse surface below bleeds to both
        // screen edges, which is the one thing a card never does, and
        // wrapping it in page padding would defeat that. Everything else
        // insets itself — the same device PageMasthead uses.
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
                label: _progressLabel(state),
                value: state.verseCount == 0
                    ? 0
                    : state.cursor / state.verseCount,
              ),
            ),
            const Gap(AppSpacing.lg),
            // Keyed on the cursor so each step cross-fades rather than
            // swapping text under the reader's eye. 180ms matches the app's
            // screen-transition tempo; anything longer reads as lag when the
            // same button is pressed many times in a row.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeOutCubic,
              child: verse == null
                  ? const Padding(
                      key: ValueKey('loading'),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenEdge,
                      ),
                      child: VerseSkeleton(),
                    )
                  : QuranVerseSurface(
                      key: ValueKey(state.cursor),
                      positionLine: _positionLine(
                        verse,
                        widget.surahVerseCount,
                      ),
                      textArabic: verse.textArabic,
                      textUthmani: verse.textUthmani,
                      textIndopak: verse.textIndopak,
                      translation: verse.translation,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static String _progressLabel(JuzReaderState state) => state.versesLeft == 0
      ? 'Juz ${state.juzNumber}  ·  Last verse'
      : 'Juz ${state.juzNumber}  ·  ${state.versesLeft} '
            '${state.versesLeft == 1 ? 'verse' : 'verses'} left';

  static String _positionLine(JuzVerse verse, int? surahVerseCount) {
    final position = surahVerseCount == null
        ? 'Verse ${verse.verseNumber}'
        : '${verse.verseNumber}/$surahVerseCount';
    return '${verse.surahId}. ${verse.surahName}  ·  $position';
  }
}

class _ReaderLoading extends StatelessWidget {
  const _ReaderLoading();

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

class _ReaderError extends StatelessWidget {
  const _ReaderError({required this.message, required this.onRetry});

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
            "We couldn't load this juz.",
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
