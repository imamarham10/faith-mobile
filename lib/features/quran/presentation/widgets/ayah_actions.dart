import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/reader/verse_action_button.dart';
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
/// See [VerseActionButton]: a card in this design system is a button, and
/// the verse readers assert screen-wide that they contain none.
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
          VerseActionButton(
            icon: Icons.play_arrow_rounded,
            label: 'Play',
            onTap: () {
              HapticFeedback.lightImpact();
              AyahActions.play(ref, target);
            },
          ),
          VerseActionButton(
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
          VerseActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () {
              HapticFeedback.lightImpact();
              AyahActions.share(context, target);
            },
          ),
          VerseActionButton(
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
