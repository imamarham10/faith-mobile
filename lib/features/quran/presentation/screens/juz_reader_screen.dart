import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/arabic_script_text.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/habit/activity_event.dart';
import '../../../../shared/habit/activity_recorder.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/juz.dart';
import '../../data/dtos/surah.dart';
import '../../domain/quran_verse_ref.dart';
import '../controllers/juz_reader_controller.dart';
import '../controllers/quran_home_controller.dart';
import '../controllers/surah_controller.dart';

/// `/quran/juz/:number` — one verse at a time, with back and forward.
///
/// ## Why the verse sits on a page, not in a card
///
/// The verse does get its own surface — readers asked for one, and bare
/// text floating on the ground gave a single ayah nothing to be. But in
/// this design system a card *is* a button: thick outline, flat fill, hard
/// offset shadow, inset from the screen edge. [PageMasthead] and [Colophon]
/// exist because removing only the shadow was not enough — users went on
/// tapping surfaces that still shared four of a button's five traits.
///
/// So the verse surface is built from the traits a card cannot have:
///
/// * it **reaches both screen edges**, and nothing tappable in this app
///   ever does — every card is inset by [AppSpacing.screenEdge];
/// * **no outline and no corner radius**, the two loudest parts of the
///   card signature. It is framed by its fill alone (white paper on the
///   cream ground), fenced by hairlines rather than bounded by a border;
/// * **no shadow**, and nothing inside it to press.
///
/// The rule is unchanged — *what you can press sits on the page; what you
/// can only read is the page* — and the only cards here are still the two
/// navigation buttons at the foot. This verse surface **is** page.
class JuzReaderScreen extends ConsumerWidget {
  const JuzReaderScreen({super.key, required this.juzNumber});

  final int juzNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = juzReaderControllerProvider(juzNumber);
    final async = ref.watch(provider);

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
                data: (state) => _ReaderBody(state: state),
                loading: () => const _ReaderLoading(),
                error: (e, _) => _ReaderError(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(provider),
                ),
              ),
            ),
            if (async.hasValue)
              _VerseNavBar(
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
  const _ReaderBody({required this.state});

  final JuzReaderState state;

  @override
  ConsumerState<_ReaderBody> createState() => _ReaderBodyState();
}

class _ReaderBodyState extends ConsumerState<_ReaderBody> {
  /// How long a verse must stay on screen before it counts as read.
  ///
  /// The same 350ms the surah reader hangs its `quran_verse` recording
  /// off, and deliberately the same number rather than a tuned one: the
  /// two readers must not disagree about what reading is. There it is a
  /// scroll debounce, so a verse counts once the reader has come to *rest*
  /// on it and a fling past under-counts. Here the equivalent of coming to
  /// rest is the cursor staying put — so holding Next through forty verses
  /// records the one you stop on, not forty.
  static const Duration _dwell = Duration(milliseconds: 350);

  /// Owned here so a new verse can start where a verse starts.
  ///
  /// The scroll view is one element reused across verses — only its child
  /// is swapped — so without this the offset carries over. 2:282 is the
  /// longest verse in the Qur'an and sits in juz 3, well inside the range
  /// someone reads this way, and the verse after it would otherwise open
  /// scrolled into its middle (or, being shorter, at a clamped offset part
  /// way down).
  final _scrollCtrl = ScrollController();

  /// Runs while the verse on screen is being dwelt on. Cancelled, never
  /// allowed to fire late, the moment the verse under it changes.
  Timer? _dwellTimer;

  /// The verse [_dwellTimer] is counting down for, as its `sourceRef`.
  /// Null while a page is in flight and no verse is rendered.
  String? _dwellingOn;

  /// Verses already handed to the activity engine this session.
  ///
  /// A short-circuit only — stepping back and forward over a verse should
  /// not re-queue it, but the *guarantee* that it is not re-counted is the
  /// deterministic `dedupeKey` below, which survives this screen.
  final _recorded = <String>{};

  @override
  void initState() {
    super.initState();
    // Verse 1 is on screen from the first frame and never arrives through
    // didUpdateWidget, so it would otherwise be the one verse of a juz
    // that never counts.
    _watchForDwell();
  }

  @override
  void dispose() {
    _dwellTimer?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ReaderBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Runs on every update, not only on a cursor change: a page can arrive
    // under a cursor that has not moved, which is the moment the skeleton
    // becomes a verse and the only moment that verse can start dwelling.
    _watchForDwell();
    if (oldWidget.state.cursor == widget.state.cursor) return;
    // After the frame, not during it: jumping mid-build can rebuild the
    // Scrollable that is already building. One frame at the old offset is
    // invisible under the 180ms cross-fade.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollCtrl.hasClients) return;
      _scrollCtrl.jumpTo(0);
    });
  }

  /// Starts [_dwell] running against whatever verse is now on screen.
  ///
  /// Idempotent per verse: called on every rebuild, and does nothing at all
  /// while the verse under the cursor is unchanged, so a rebuild for an
  /// unrelated reason (a font-size change, a page merging into state) can
  /// neither restart nor duplicate the countdown.
  void _watchForDwell() {
    final verse = widget.state.currentVerse;
    final sourceRef = verse == null
        ? null
        : quranVerseRef(
            surahId: verse.surahId,
            verseNumber: verse.verseNumber,
          );
    if (sourceRef == _dwellingOn) return;

    // The verse changed, so whatever was counting down belongs to a verse
    // the user has already left. It does not get to land.
    _dwellTimer?.cancel();
    _dwellingOn = sourceRef;
    if (sourceRef == null || _recorded.contains(sourceRef)) return;

    _dwellTimer = Timer(_dwell, () {
      if (!mounted || !_recorded.add(sourceRef)) return;
      unawaited(_record(sourceRef));
    });
  }

  /// One verse, one event — fire-and-forget, and swallowing everything.
  ///
  /// Reading is the user's act; logging it is this screen's bookkeeping.
  /// Nothing that goes wrong in the bookkeeping may reach the reader, so
  /// the `ref.read` (which can throw) and the future (which is documented
  /// not to, but is not this screen's to trust) are both inside the catch.
  ///
  /// There is no loop here and cannot be one: a step is one verse, and the
  /// pages the controller prefetches are never enumerated into events —
  /// prefetching fifty verses is not reading them.
  Future<void> _record(String sourceRef) async {
    try {
      await ref
          .read(activityRecorderProvider)
          .record(
            ActivityType.quranVerse,
            sourceRef: sourceRef,
            // Identical to the key the surah reader derives for the same
            // verse. Read 2:142 here and again there on the same day and
            // it is one event, because it is one verse read.
            dedupeKey: sourceRef,
          );
    } on Object catch (e, st) {
      developer.log(
        'failed to record $sourceRef from the juz reader',
        name: 'quran.juz',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final verse = state.currentVerse;

    return SingleChildScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      // No horizontal padding: the verse surface below bleeds to both
      // screen edges, which is the one thing a card never does, and
      // wrapping it in page padding would defeat that. Everything else
      // insets itself — the same device [PageMasthead] uses.
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
            child: _JuzProgress(
              juzNumber: state.juzNumber,
              versesLeft: state.versesLeft,
              cursor: state.cursor,
              verseCount: state.verseCount,
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
                    child: _VerseSkeleton(),
                  )
                : _VersePage(key: ValueKey(state.cursor), verse: verse),
          ),
        ],
      ),
    );
  }
}

/// "Juz 2 · 105 verses left", over a hairline rule that fills as the juz
/// does. Reading matter, so: no fill, no outline, no corner, nothing to tap.
class _JuzProgress extends StatelessWidget {
  const _JuzProgress({
    required this.juzNumber,
    required this.versesLeft,
    required this.cursor,
    required this.verseCount,
  });

  final int juzNumber;
  final int versesLeft;
  final int cursor;
  final int verseCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final label = versesLeft == 0
        ? 'Juz $juzNumber  ·  Last verse'
        : 'Juz $juzNumber  ·  $versesLeft '
              '${versesLeft == 1 ? 'verse' : 'verses'} left';

    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: palette.inkMuted,
            ),
          ),
          const Gap(AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(
                end: verseCount == 0 ? 0 : cursor / verseCount,
              ),
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 4,
                backgroundColor: palette.outline.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation<Color>(palette.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The verse itself — position, Arabic, translation — on a page of its own.
///
/// See the class doc on [JuzReaderScreen] for why this surface is built the
/// way it is. In short: it is a reading surface, so it is made of the traits
/// a button in this design system cannot wear — it bleeds to both screen
/// edges, has no outline, no corner and no shadow, and holds nothing to
/// press.
class _VersePage extends ConsumerWidget {
  const _VersePage({super.key, required this.verse});

  /// How much larger the Arabic is here than in the continuous reader.
  ///
  /// Applied to the reader's own font-size preference rather than replacing
  /// it, so the settings slider still means what it says — this reader is
  /// a constant multiple louder, not a second opinion.
  ///
  /// It earns the multiple by showing one verse: the surah reader has to
  /// fit a whole surah into a scroll, where display-size Arabic would mean
  /// three lines a screen, while here the verse *is* the screen and should
  /// fill it the way an open mushaf does.
  static const double _displayScale = 1.45;

  /// Ceiling on the scaled size. The preference tops out at 40, which would
  /// otherwise scale to 58 — and that is before [MediaQuery.textScaler],
  /// which multiplies again for anyone reading at large system text.
  static const double _maxArabicSize = 48;

  final JuzVerse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final prefs = ref.watch(readerPreferencesControllerProvider);
    final script = activeArabicScript(ref);

    // The juz payload names the surah but does not say how long it is, and
    // "148/286" needs the 286. It comes from the 114-surah index, which the
    // Qur'an tab has already loaded by the time anyone reaches this screen.
    // If it somehow has not, the position degrades to "148" rather than
    // holding the verse back for it.
    final surahs = ref.watch(surahListProvider).valueOrNull;
    final surahVerseCount = _verseCountFor(surahs, verse.surahId);
    final position = surahVerseCount == null
        ? 'Verse ${verse.verseNumber}'
        : '${verse.verseNumber}/$surahVerseCount';

    final hairline = BorderSide(
      color: palette.outline.withValues(alpha: 0.12),
      width: 1,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        // Fill alone does the framing: white paper on the cream ground
        // (and the lighter of the two greys in dark mode). An outline here
        // would be the card signature, which is this app's button.
        color: palette.surfaceCard,
        // Fences, not a border. They close the page top and bottom where
        // the fill contrast is slight, and leave the sides open to the
        // screen edge — which is what says "page" rather than "object".
        border: Border(top: hairline, bottom: hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.xl,
          AppSpacing.screenEdge,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${verse.surahId}. ${verse.surahName}  ·  $position',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: palette.inkMuted,
                letterSpacing: 0.4,
              ),
            ),
            const Gap(AppSpacing.xl),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                arabicTextForScript(
                  script,
                  textArabic: verse.textArabic,
                  textIndopak: verse.textIndopak,
                  textUthmani: verse.textUthmani,
                ),
                // Centred, not right-aligned: a single ayah held alone on
                // a page is a plate, and a mushaf sets those centred. The
                // continuous reader stays right-aligned, where a ragged
                // right edge between consecutive verses would read as a
                // mistake.
                textAlign: TextAlign.center,
                style: arabicTextStyle(
                  script,
                  fontSize: (prefs.arabicFontSize * _displayScale).clamp(
                    prefs.arabicFontSize,
                    _maxArabicSize,
                  ),
                  // Leading comes from the script — Indo-Pak's stacked
                  // sukuns and Uthmani's superscript alef need different
                  // amounts of air, and at this size the difference is no
                  // longer academic.
                  color: cs.onSurface,
                ),
              ),
            ),
            if (prefs.showTranslation &&
                (verse.translation?.isNotEmpty ?? false)) ...[
              const Gap(AppSpacing.xl),
              Divider(
                color: palette.outline.withValues(alpha: 0.12),
                height: 1,
              ),
              const Gap(AppSpacing.xl),
              Text(
                verse.translation!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ],
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

/// Shown only if a page somehow is not resident when the cursor lands on it
/// — the controller prefetches the next page a full page ahead, so in normal
/// reading this never appears.
class _VerseSkeleton extends StatelessWidget {
  const _VerseSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PoppySkeleton(height: 18, radius: AppRadius.sm),
        Gap(AppSpacing.lg),
        PoppySkeleton(height: 120, radius: AppRadius.md),
        Gap(AppSpacing.lg),
        PoppySkeleton(height: 72, radius: AppRadius.md),
      ],
    );
  }
}

/// ← and → at the foot. The two cards on this screen, because they are the
/// two things you press.
class _VerseNavBar extends StatelessWidget {
  const _VerseNavBar({
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
  });

  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onBack;
  final VoidCallback onForward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.md,
        AppSpacing.screenEdge,
        AppSpacing.base,
      ),
      child: Row(
        children: [
          Expanded(
            child: _VerseNavButton(
              label: 'Back',
              icon: Icons.arrow_back_rounded,
              iconLeading: true,
              variant: PoppyButtonVariant.secondary,
              onPressed: canGoBack ? onBack : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _VerseNavButton(
              label: 'Next',
              icon: Icons.arrow_forward_rounded,
              iconLeading: false,
              variant: PoppyButtonVariant.primary,
              onPressed: canGoForward ? onForward : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// A [PoppyButton] in everything but two details, both of which matter only
/// because this button is pressed hundreds of times in one sitting:
///
/// * the arrow sits on the side it points to, so the pair reads as a
///   direction rather than as two labels with decorations;
/// * it fires [HapticFeedback.selectionClick] rather than `mediumImpact`.
///   Stepping through verses is selection, not confirmation, and a medium
///   impact per verse turns a half-hour of reading into a buzzing phone.
class _VerseNavButton extends StatefulWidget {
  const _VerseNavButton({
    required this.label,
    required this.icon,
    required this.iconLeading,
    required this.variant,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool iconLeading;
  final PoppyButtonVariant variant;
  final VoidCallback? onPressed;

  @override
  State<_VerseNavButton> createState() => _VerseNavButtonState();
}

class _VerseNavButtonState extends State<_VerseNavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final enabled = widget.onPressed != null;
    final offset = _pressed ? 0.0 : ext.pressOffset;

    final (fill, onColor) = switch (widget.variant) {
      PoppyButtonVariant.secondary => (
        _pressed ? palette.secondaryPressed : palette.secondary,
        theme.colorScheme.onSecondary,
      ),
      _ => (
        _pressed ? palette.primaryPressed : palette.primary,
        theme.colorScheme.onPrimary,
      ),
    };

    final icon = Icon(widget.icon, color: onColor, size: 20);
    final label = Text(
      widget.label,
      style: theme.textTheme.titleMedium?.copyWith(color: onColor),
    );

    final body = AnimatedContainer(
      duration: ext.pressDuration,
      curve: Curves.easeOut,
      // Paint-only shift, as on PoppyCard/PoppyButton: `margin` would be
      // layout and would reflow the sibling button on every press.
      transform: Matrix4.translationValues(0, ext.pressOffset - offset, 0),
      transformAlignment: Alignment.center,
      height: 56,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.outline, width: ext.cardOutlineWidth),
        boxShadow: offset == 0
            ? const []
            : [BoxShadow(color: palette.shadow, offset: Offset(0, offset))],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.iconLeading) ...[icon, const SizedBox(width: 8)],
          label,
          if (!widget.iconLeading) ...[const SizedBox(width: 8), icon],
        ],
      ),
    );

    void handleTap() {
      HapticFeedback.selectionClick();
      widget.onPressed!();
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      onTap: enabled ? handleTap : null,
      excludeSemantics: true,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: enabled
            ? GestureDetector(
                onTapDown: (_) => setState(() => _pressed = true),
                onTapCancel: () => setState(() => _pressed = false),
                onTapUp: (_) => setState(() => _pressed = false),
                onTap: handleTap,
                child: body,
              )
            : body,
      ),
    );
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
      child: _VerseSkeleton(),
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
