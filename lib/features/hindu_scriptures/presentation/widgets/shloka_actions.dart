import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/reader/verse_action_button.dart';
import '../../../share/domain/shareable_content.dart';
import '../../domain/shloka_action_target.dart';
import '../controllers/scripture_audio_controller.dart';
import '../controllers/scripture_bookmarks_controller.dart';
import 'verse_action_sheet.dart';

/// What the per-verse actions *do*, in one place.
///
/// Two surfaces offer these — [VerseActionSheet] in the scrolling reader and
/// [ShlokaActionBar] in the pager — and the whole point of putting the
/// bodies here is that the pair cannot drift. Bookmarking from the bar and
/// from the sheet must write the same row; sharing must produce the same
/// card. The Qur'an's [AyahActions] is the same arrangement for the same
/// reason.
class ShlokaActions {
  const ShlokaActions._();

  /// Whether [target] is bookmarked right now. A `select`, so a surface
  /// watching this rebuilds when *this* verse's bookmark changes and not
  /// when any bookmark anywhere does.
  static bool isBookmarked(WidgetRef ref, ShlokaActionTarget target) =>
      ref.watch(
        scriptureBookmarksControllerProvider.select(
          (s) => (s.valueOrNull ?? const []).any(
            (b) => b.verseId == target.verseId,
          ),
        ),
      );

  static Future<void> toggleBookmark(
    WidgetRef ref,
    ShlokaActionTarget target,
  ) async {
    await ref
        .read(scriptureBookmarksControllerProvider.notifier)
        .toggle(
          verseId: target.verseId,
          textSlug: target.textSlug,
          textName: target.textName,
          chapterNumber: target.chapterNumber,
          sanskritText: target.sanskritText,
          verseNumber: target.verseNumber,
          translation: target.translation,
        );
  }

  static void share(BuildContext context, ShlokaActionTarget target) {
    context.push(
      '/share',
      extra: ShareableContent(
        eyebrow: target.textName,
        title: target.label,
        sanskrit: target.sanskritText,
        translation: target.translation,
        attribution: target.attribution,
      ),
    );
  }

  /// Starts the **chapter** narration — from its beginning, not from
  /// [target].
  ///
  /// ## Why there is no per-verse play
  ///
  /// There is no per-verse Hindu narration to start, and no way to seek to
  /// one. `HinduTextVerse` carries no audio column; `HinduTextAudio` is
  /// keyed `(textId, chapterId, reciterSlug)` and holds one file per
  /// chapter per narrator, with no verse offsets anywhere in the schema. So
  /// `playChapter()` is the only entry point the data supports, and a Play
  /// control sitting on a verse would start the chapter from verse 1 — a
  /// button that plays something other than the thing it is attached to.
  ///
  /// Hence: no Play in [ShlokaActionBar], and in the sheet this is spelled
  /// out as *the chapter, from the beginning*. When per-verse audio exists,
  /// this is the one function that changes.
  static void playChapter(WidgetRef ref, ShlokaActionTarget target) {
    ref
        .read(scriptureAudioControllerProvider.notifier)
        .playChapter(
          textSlug: target.textSlug,
          chapterNumber: target.chapterNumber,
          chapterTitle: target.chapterTitle,
        );
  }
}

/// The pager's action row: Bookmark · Share · More.
///
/// ## Why a visible row rather than the scrolling reader's tap
///
/// In the continuous reader a verse is one row among dozens, so the actions
/// have to be summoned for a particular verse and a tap on that verse is
/// the only gesture that can say *which*. Here the screen holds exactly one
/// verse, so there is nothing to disambiguate — and a hidden gesture on a
/// screen with one subject is a feature nobody finds.
///
/// ## Why three actions where the Qur'an's row has four
///
/// The missing one is Play, and it is missing because it would lie — see
/// [ShlokaActions.playChapter]. Padding the row back to four to match the
/// Islam reader's shape would be matching the wrong thing: parity is in
/// what the two readers *let you do with the verse in front of you*, and
/// neither vertical gets a control that does something else.
///
/// Chapter narration is still one tap away under **More**, where it can be
/// labelled for what it is, and the mini player it raises is already on
/// every scripture screen.
class ShlokaActionBar extends ConsumerWidget {
  const ShlokaActionBar({super.key, required this.target});

  final ShlokaActionTarget target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = ShlokaActions.isBookmarked(ref, target);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
              ShlokaActions.toggleBookmark(ref, target);
            },
          ),
          VerseActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: () {
              HapticFeedback.lightImpact();
              ShlokaActions.share(context, target);
            },
          ),
          VerseActionButton(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            onTap: () {
              HapticFeedback.lightImpact();
              VerseActionSheet.show(context, target: target);
            },
          ),
        ],
      ),
    );
  }
}
