import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../share/domain/shareable_content.dart';
import '../../domain/ayah_action_target.dart';
import '../controllers/audio_controller.dart';
import '../controllers/bookmarks_controller.dart';
import 'ayah_action_sheet.dart';

/// What the per-verse actions *do*, in one place.
///
/// Two surfaces offer these — [AyahActionSheet] in the scrolling reader and
/// [AyahActionBar] in the two verse-at-a-time readers — and the whole point
/// of putting the bodies here is that the pair cannot drift. Bookmarking
/// from the bar and from the sheet must write the same row; sharing must
/// produce the same card. Neither is allowed to become "almost" the other.
class AyahActions {
  const AyahActions._();

  /// Whether [target] is bookmarked right now. A `select`, so a surface
  /// watching this rebuilds when *this* verse's bookmark changes and not
  /// when any bookmark anywhere does.
  static bool isBookmarked(WidgetRef ref, AyahActionTarget target) => ref.watch(
    bookmarksControllerProvider.select(
      (s) => (s.valueOrNull ?? const []).any(
        (b) =>
            b.surahId == target.surahId && b.verseNumber == target.verseNumber,
      ),
    ),
  );

  /// Starts recitation at [target] and lets it run on through the surah.
  ///
  /// `totalVerses` is where the player stops advancing. When the surah
  /// index has not loaded it is unknown, and this passes the current verse
  /// number — so playback is this one ayah and then silence. That is the
  /// safe direction: the alternative, a guessed ceiling, would either cut a
  /// surah short or walk the player off its end requesting audio files that
  /// do not exist.
  static void play(WidgetRef ref, AyahActionTarget target) {
    ref
        .read(audioControllerProvider.notifier)
        .playAyah(
          surahId: target.surahId,
          verseNumber: target.verseNumber,
          surahName: target.surahName,
          totalVerses: target.totalVerses ?? target.verseNumber,
        );
  }

  static Future<void> toggleBookmark(
    WidgetRef ref,
    AyahActionTarget target,
  ) async {
    await ref
        .read(bookmarksControllerProvider.notifier)
        .toggle(
          surahId: target.surahId,
          verseNumber: target.verseNumber,
          surahName: target.surahName,
          textArabic: target.textArabic,
          translation: target.translation,
        );
  }

  static void share(BuildContext context, AyahActionTarget target) {
    context.push(
      '/share',
      extra: ShareableContent(
        eyebrow: 'Quran',
        title: target.label,
        arabic: target.textArabic,
        translation: target.translation,
        attribution: target.attribution,
      ),
    );
  }
}

/// The verse-at-a-time readers' action row: Play · Bookmark · Share · More.
///
/// ## Why a visible row rather than the scrolling reader's long-press
///
/// In the continuous reader a verse is one row among dozens, so the actions
/// have to be summoned for a particular verse and long-press is the only
/// gesture that can say *which*. Here the screen holds exactly one verse,
/// so there is nothing to disambiguate — and a hidden gesture on a screen
/// with one subject is a feature nobody finds. The surah reader's
/// long-press is unchanged; this is the same menu, made visible because
/// visible is now possible.
///
/// ## Why it is not made of cards
///
/// A card in this design system is a button, and the juz reader asserts
/// screen-wide that it contains none — the verse, its position and the
/// progress line are reading matter and a card around any of them reads as
/// pressable. These are real controls, so they need the opposite guarantee:
/// they must be legible as controls *without* borrowing the card
/// signature. So they are flat icon-over-label targets on the page ground,
/// the same anatomy as the icon buttons in the reader's top bar, sized past
/// the 48dp minimum and inset from the screen edge.
///
/// [AyahActions] is where the first three actually run, shared with
/// [AyahActionSheet] — which More opens, and which keeps the long tail
/// (tafsir today, more later) rather than this row growing indefinitely.
class AyahActionBar extends ConsumerWidget {
  const AyahActionBar({super.key, required this.target});

  final AyahActionTarget target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = AyahActions.isBookmarked(ref, target);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.play_arrow_rounded,
            label: 'Play',
            onTap: () {
              HapticFeedback.lightImpact();
              AyahActions.play(ref, target);
            },
          ),
          _ActionButton(
            icon: bookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            label: bookmarked ? 'Saved' : 'Bookmark',
            highlighted: bookmarked,
            onTap: () {
              // Medium, where the others are light: this one changes
              // something that outlives the screen.
              HapticFeedback.mediumImpact();
              AyahActions.toggleBookmark(ref, target);
            },
          ),
          _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () {
              HapticFeedback.lightImpact();
              AyahActions.share(context, target);
            },
          ),
          _ActionButton(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            onTap: () {
              HapticFeedback.lightImpact();
              AyahActionSheet.show(context, target: target);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final color = highlighted ? palette.accentText : palette.inkMuted;

    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          // 10 + 24 + 4 + ~14 + 10 clears 48dp in both axes without a
          // fixed size, so it still grows under MediaQuery.textScaler.
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
