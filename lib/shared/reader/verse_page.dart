import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/faith_theme_extension.dart';
import '../habit/activity_event.dart';
import '../habit/activity_recorder.dart';
import '../widgets/gap.dart';
import '../widgets/poppy_button.dart';
import '../widgets/poppy_skeleton.dart';

// The parts a verse-at-a-time reader is built from.
//
// Three screens read this way — `/quran/juz/:number` across a juz,
// `/quran/surah/:id/verses` within one surah, and
// `/quran/hindu-scripture/:slug/:chapter/verses` within one chapter of a
// Hindu text — and they differ only in where the verses come from. The juz
// reader pages a server endpoint by an index that spans surahs; the other
// two already hold every verse from a single call. That difference is real
// and lives in three separate controllers; *everything a verse reader looks
// like* lives here, so they can never drift into three slightly different
// ways of showing one verse.
//
// This file is faith-neutral and must stay so. It knows about verses,
// pages, leading and progress — never about surahs, chapters, scripts or
// which preferences controller the caller reads its font size from. Every
// one of those is resolved by a thin per-vertical adapter
// (`QuranVerseSurface`, `ShlokaVerseSurface`) that hands the results in.

/// The verse surface — position line, scripture, transliteration,
/// translation — on a page.
///
/// ## Why this is a page and not a card
///
/// In this design system a card *is* a button: thick outline, flat fill,
/// hard offset shadow, inset from the screen edge. `PageMasthead` and
/// `Colophon` exist because removing only the shadow was not enough —
/// users went on tapping surfaces that still shared four of a button's five
/// traits.
///
/// So this surface is built from the traits a card cannot have:
///
/// * it **reaches both screen edges**, and nothing tappable in this app
///   ever does — every card is inset by [AppSpacing.screenEdge];
/// * **no outline and no corner radius**, the two loudest parts of the card
///   signature. It is framed by its fill alone (white paper on the cream
///   ground), fenced by hairlines rather than bounded by a border;
/// * **no shadow, and nothing inside it to press.**
///
/// What you can press sits *on* the page: the action bar and the Back/Next
/// buttons are siblings of this widget, never children of it.
///
/// ## Why it takes a resolved style and not a preference
///
/// It used to be a [ConsumerWidget] that read the Qur'an reader's own
/// preferences provider and resolved the Arabic script itself. Both of
/// those are per-vertical — the Hindu reader has a different preferences
/// controller and no script choice at all — so a shared widget that reached
/// for either would have been shared in name only. The caller resolves
/// them; this draws what it is given. [displayFontSize] is the one piece of
/// that arithmetic kept here, because it is the piece the two readers must
/// agree on.
class VerseSurface extends StatelessWidget {
  const VerseSurface({
    super.key,
    required this.positionLine,
    required this.scripture,
    required this.scriptureStyle,
    this.scriptureDirection = TextDirection.ltr,
    this.transliteration,
    this.translation,
    this.showTranslation = true,
  });

  /// How much larger the scripture is here than in the continuous reader.
  ///
  /// Applied to the reader's own font-size preference rather than replacing
  /// it, so the settings slider still means what it says — this reader is a
  /// constant multiple louder, not a second opinion.
  ///
  /// It earns the multiple by showing one verse: a continuous reader has to
  /// fit a whole surah or chapter into a scroll, where display-size script
  /// would mean three lines a screen, while here the verse *is* the screen
  /// and should fill it the way an open mushaf or pothi does.
  static const double displayScale = 1.45;

  /// Ceiling on the scaled size. The Qur'an preference tops out at 40, which
  /// would otherwise scale to 58 — and that is before
  /// [MediaQuery.textScaler], which multiplies again for anyone reading at
  /// large system text.
  static const double maxDisplayFontSize = 48;

  /// The scaled size for a reader whose continuous-mode preference is
  /// [base]. Never smaller than [base]: a ceiling that bit below the
  /// preference would make the pager *quieter* than the scroll it magnifies.
  static double displayFontSize(double base) =>
      (base * displayScale).clamp(base, maxDisplayFontSize);

  /// "2. Al-Baqarah  ·  253/286" — built by the caller, because the readers
  /// know different amounts about where they are.
  final String positionLine;

  /// The verse in its own script, already resolved. For the Qur'an that
  /// means the orthography the reader prefers; for a Hindu text, the
  /// Devanagari the payload carries.
  final String scripture;

  /// The face and leading [scripture] is set in — from `arabicTextStyle` or
  /// `sanskritTextStyle`, never built here. Scripts whose marks sit above
  /// the line need `leadingDistribution: even`, and both of those helpers
  /// apply it; a style assembled locally would not.
  final TextStyle scriptureStyle;

  /// RTL for Arabic, LTR for Devanagari. A parameter rather than a branch on
  /// faith, so a third script is a new call site and not a new `if`.
  final TextDirection scriptureDirection;

  /// Romanisation under the scripture, where the payload carries one. The
  /// Qur'an payload does not; Hindu verses usually do.
  final String? transliteration;

  final String? translation;

  /// The reader's "show translation" preference, resolved by the caller for
  /// the same reason [scriptureStyle] is.
  final bool showTranslation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

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
              positionLine,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: palette.inkMuted,
                letterSpacing: 0.4,
              ),
            ),
            const Gap(AppSpacing.xl),
            Directionality(
              textDirection: scriptureDirection,
              child: Text(
                scripture,
                // Centred, not edge-aligned: a single verse held alone on a
                // page is a plate, and both a mushaf and a printed pothi set
                // those centred. The continuous readers stay edge-aligned,
                // where a ragged edge between consecutive verses would read
                // as a mistake.
                textAlign: TextAlign.center,
                style: scriptureStyle,
              ),
            ),
            if (transliteration?.isNotEmpty ?? false) ...[
              const Gap(AppSpacing.lg),
              Text(
                transliteration!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: palette.inkMuted,
                  height: 1.5,
                ),
              ),
            ],
            if (showTranslation && (translation?.isNotEmpty ?? false)) ...[
              const Gap(AppSpacing.xl),
              Divider(
                color: palette.outline.withValues(alpha: 0.12),
                height: 1,
              ),
              const Gap(AppSpacing.xl),
              Text(
                translation!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Juz 2 · 105 verses left", over a hairline rule that fills as the
/// reading does. Reading matter, so: no fill, no outline, no corner,
/// nothing to tap.
class VerseProgress extends StatelessWidget {
  const VerseProgress({super.key, required this.label, required this.value});

  final String label;

  /// 0–1. Animated, so holding Next sweeps the rule rather than stepping it.
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;

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
              tween: Tween<double>(end: value),
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
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

/// Shown only if a verse is not resident when the cursor lands on it — the
/// juz controller prefetches a full page ahead and the surah and chapter
/// readers hold every verse, so in normal reading this never appears.
class VerseSkeleton extends StatelessWidget {
  const VerseSkeleton({super.key});

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

/// Back and Next at the foot. The two cards on these screens, because they
/// are the two things you press.
class VerseNavBar extends StatelessWidget {
  const VerseNavBar({
    super.key,
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

/// Records one activity once the reader has *stayed* on a verse.
///
/// Renders [child] verbatim; it is a side-effect carrier, not a layout.
///
/// ## Why a dwell and why this number
///
/// The continuous readers hang their recording off a 350ms scroll debounce,
/// so a verse counts once the reader has come to rest on it and a fling
/// past under-counts. The pager equivalent of coming to rest is the cursor
/// staying put — so holding Next through forty verses records the one you
/// stop on, not forty. Deliberately the same number rather than a tuned
/// one: the readers must not disagree about what reading is, and neither
/// must the two verticals.
class VerseReadRecorder extends ConsumerStatefulWidget {
  const VerseReadRecorder({
    super.key,
    required this.activityType,
    required this.dedupeKey,
    required this.child,
    this.sourceRef,
    this.logName = 'reader.verse',
  });

  /// `quran_verse`, `gita_shloka` — what the user did. The event's faith
  /// comes with it, so there is nothing else here to keep in step.
  final ActivityType activityType;

  /// Names this verse, for both "which verse is on screen" and
  /// "this act, at most once a day". Null while a page is in flight and no
  /// verse is rendered.
  ///
  /// It must come from the vertical's own ref helper — `quranVerseRef`,
  /// `shlokaDedupeKey` — and never be assembled at the call site, so that a
  /// verse read in the pager and the same verse read in the scroll collapse
  /// to one event.
  final String? dedupeKey;

  /// The event's provenance, contract §1.6 — `quran:2:255`, `gita:2:47`.
  ///
  /// Separate from [dedupeKey] because the contract has no shape for some
  /// verses this reader can legitimately show: §1.6 fixes a śloka reference
  /// as `gita:<chapter>:<verse>` with no room for *which* text, so a verse
  /// of any other Hindu text has no expressible reference and omits the
  /// field. It must still dedupe, hence two parameters rather than one.
  final String? sourceRef;

  /// Names this reader in the log line a failed record writes.
  final String logName;

  final Widget child;

  @override
  ConsumerState<VerseReadRecorder> createState() => _VerseReadRecorderState();
}

class _VerseReadRecorderState extends ConsumerState<VerseReadRecorder> {
  static const Duration _dwell = Duration(milliseconds: 350);

  Timer? _timer;

  /// The verse [_timer] is counting down for. Null before the first verse.
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
    // The first verse is on screen from the first frame and never arrives
    // through didUpdateWidget, so it would otherwise be the one verse that
    // never counts.
    _watch();
  }

  @override
  void didUpdateWidget(VerseReadRecorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _watch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Idempotent per verse: called on every rebuild, and does nothing while
  /// the verse is unchanged, so a rebuild for an unrelated reason (a
  /// font-size change, a page merging into state) can neither restart nor
  /// duplicate the countdown.
  void _watch() {
    final key = widget.dedupeKey;
    if (key == _dwellingOn) return;

    // The verse changed, so whatever was counting down belongs to a verse
    // the user has already left. It does not get to land.
    _timer?.cancel();
    _dwellingOn = key;
    if (key == null || _recorded.contains(key)) return;

    final sourceRef = widget.sourceRef;
    _timer = Timer(_dwell, () {
      if (!mounted || !_recorded.add(key)) return;
      unawaited(_record(key, sourceRef));
    });
  }

  /// One verse, one event — fire-and-forget, and swallowing everything.
  ///
  /// Reading is the user's act; logging it is this widget's bookkeeping.
  /// Nothing that goes wrong in the bookkeeping may reach the reader, so
  /// the `ref.read` (which can throw) and the future (which is documented
  /// not to, but is not this widget's to trust) are both inside the catch.
  Future<void> _record(String dedupeKey, String? sourceRef) async {
    try {
      await ref
          .read(activityRecorderProvider)
          .record(
            widget.activityType,
            sourceRef: sourceRef,
            // Identical to the key the continuous reader derives for the
            // same verse. Read 2:142 here and again there on the same day
            // and it is one event, because it is one verse read.
            dedupeKey: dedupeKey,
          );
    } on Object catch (e, st) {
      developer.log(
        'failed to record $dedupeKey',
        name: widget.logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
