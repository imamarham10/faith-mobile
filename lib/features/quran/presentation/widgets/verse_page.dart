import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../controllers/surah_controller.dart';

// The parts a verse-at-a-time reader is built from.
//
// Two screens read this way — `/quran/juz/:number` across a juz, and
// `/quran/surah/:id/verses` within one surah — and they differ only in
// where the verses come from. The juz reader pages a server endpoint by an
// index that spans surahs; the surah reader already holds every verse from
// one `GET /surah/:id`. That difference is real and lives in two separate
// controllers; *everything the reader looks like* lives here, so the two
// can never drift into two slightly different ways of showing one ayah.

/// The verse surface — position line, Arabic, translation — on a page.
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
class VerseSurface extends ConsumerWidget {
  const VerseSurface({
    super.key,
    required this.positionLine,
    required this.textArabic,
    this.textUthmani,
    this.textIndopak,
    this.translation,
  });

  /// How much larger the Arabic is here than in the continuous reader.
  ///
  /// Applied to the reader's own font-size preference rather than replacing
  /// it, so the settings slider still means what it says — this reader is a
  /// constant multiple louder, not a second opinion.
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

  /// "2. Al-Baqarah  ·  253/286" — built by the caller, because the two
  /// readers know different amounts about where they are.
  final String positionLine;

  final String textArabic;
  final String? textUthmani;
  final String? textIndopak;
  final String? translation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final prefs = ref.watch(readerPreferencesControllerProvider);
    final script = activeArabicScript(ref);

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
              textDirection: TextDirection.rtl,
              child: Text(
                arabicTextForScript(
                  script,
                  textArabic: textArabic,
                  textIndopak: textIndopak,
                  textUthmani: textUthmani,
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
                (translation?.isNotEmpty ?? false)) ...[
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
/// juz controller prefetches a full page ahead and the surah reader holds
/// every verse, so in normal reading this never appears.
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

/// Records one `quran_verse` once the reader has *stayed* on [sourceRef].
///
/// Renders [child] verbatim; it is a side-effect carrier, not a layout.
///
/// ## Why a dwell and why this number
///
/// The continuous reader hangs its recording off a 350ms scroll debounce,
/// so a verse counts once the reader has come to rest on it and a fling
/// past under-counts. The pager equivalent of coming to rest is the cursor
/// staying put — so holding Next through forty verses records the one you
/// stop on, not forty. Deliberately the same number rather than a tuned
/// one: the readers must not disagree about what reading is.
class VerseReadRecorder extends ConsumerStatefulWidget {
  const VerseReadRecorder({
    super.key,
    required this.sourceRef,
    required this.child,
    this.logName = 'quran.verseReader',
  });

  /// `quran:<surah>:<ayah>` for the verse on screen, or null while a page
  /// is in flight and no verse is rendered.
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
    final sourceRef = widget.sourceRef;
    if (sourceRef == _dwellingOn) return;

    // The verse changed, so whatever was counting down belongs to a verse
    // the user has already left. It does not get to land.
    _timer?.cancel();
    _dwellingOn = sourceRef;
    if (sourceRef == null || _recorded.contains(sourceRef)) return;

    _timer = Timer(_dwell, () {
      if (!mounted || !_recorded.add(sourceRef)) return;
      unawaited(_record(sourceRef));
    });
  }

  /// One verse, one event — fire-and-forget, and swallowing everything.
  ///
  /// Reading is the user's act; logging it is this widget's bookkeeping.
  /// Nothing that goes wrong in the bookkeeping may reach the reader, so
  /// the `ref.read` (which can throw) and the future (which is documented
  /// not to, but is not this widget's to trust) are both inside the catch.
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
        'failed to record $sourceRef',
        name: widget.logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
