import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../data/dtos/juz.dart';
import '../../data/dtos/surah.dart';
import '../controllers/juz_reader_controller.dart';
import '../controllers/quran_home_controller.dart';
import '../controllers/surah_controller.dart';

/// `/quran/juz/:number` — one verse at a time, with back and forward.
///
/// ## Why this reader is not a card
///
/// The screen it is modelled on puts the verse in a raised card. In this
/// design system a card is a button, and the verse is the one thing on the
/// page you cannot press — so the verse, its position line and the juz
/// progress line are all set directly on the page, and the only cards here
/// are the two navigation buttons at the foot. Same rule as [PageMasthead]
/// and [Colophon]: *what you can press sits on the page; what you can only
/// read is the page.*
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

    return SingleChildScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.base,
        AppSpacing.screenEdge,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _JuzProgress(
            juzNumber: state.juzNumber,
            versesLeft: state.versesLeft,
            cursor: state.cursor,
            verseCount: state.verseCount,
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
                ? const _VerseSkeleton(key: ValueKey('loading'))
                : _VerseSurface(key: ValueKey(state.cursor), verse: verse),
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

/// The verse itself: position, Arabic, translation. Set on the page.
class _VerseSurface extends ConsumerWidget {
  const _VerseSurface({super.key, required this.verse});

  final JuzVerse verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final prefs = ref.watch(readerPreferencesControllerProvider);

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${verse.surahId}. ${verse.surahName}  ·  $position',
          style: theme.textTheme.titleSmall?.copyWith(color: palette.inkMuted),
        ),
        const Gap(AppSpacing.lg),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            verse.textArabic,
            textAlign: TextAlign.right,
            // Same call, same line height as AyahView — the juz reader must
            // not be a second opinion on Arabic typography.
            style: arabicTextStyleOf(
              ref,
              fontSize: prefs.arabicFontSize,
              height: 2.2,
              color: cs.onSurface,
            ),
          ),
        ),
        if (prefs.showTranslation &&
            (verse.translation?.isNotEmpty ?? false)) ...[
          const Gap(AppSpacing.lg),
          Divider(color: cs.outline, height: 1),
          const Gap(AppSpacing.lg),
          Text(verse.translation!, style: theme.textTheme.bodyLarge),
        ],
      ],
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
  const _VerseSkeleton({super.key});

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
