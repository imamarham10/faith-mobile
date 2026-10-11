import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../domain/often_read.dart';
import '../../domain/reading_mode.dart';
import '../../../../shared/reader/reading_mode_controller.dart';

/// Shortcut chips for the surahs people open on a schedule — see
/// [kOftenReadSurahs] for which, and why those.
///
/// Scrolls horizontally rather than wrapping, so it occupies one row no
/// matter how many entries it holds and never pushes what is below it off
/// the fold.
///
/// ## Costs nothing to show
///
/// The names and occasions are a **constant**, not a `GET /surahs`
/// projection, so the row paints with the first frame of whatever screen
/// hosts it. That is what lets it sit on Today — a screen whose launch
/// latency has been worked on hard — without adding a request or a
/// skeleton. The only provider it touches is the reading-mode preference,
/// which is a `shared_preferences` read, and even that is only consulted to
/// decide which reader a tap opens.
///
/// Islamic content: host it from the Islam branch of a faith-aware screen,
/// never from shared chrome.
class OftenReadRow extends StatelessWidget {
  const OftenReadRow({
    super.key,
    this.showLabel = true,
    this.horizontalPadding = AppSpacing.screenEdge,
  });

  /// Whether the row draws its own "Often read" header. Off where the host
  /// screen already labels the section itself.
  final bool showLabel;

  /// Inset on the scrolling strip. The default puts the first chip on the
  /// screen's own margin, for hosts that place this edge-to-edge (the
  /// Qur'an tab, the Practice tab). Pass 0 inside a list that is already
  /// inset — Today's — or the chips start two margins in.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              AppSpacing.sm,
            ),
            child: const SectionLabel('Often read'),
          ),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: kOftenReadSurahs.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) =>
                _OftenReadChip(surah: kOftenReadSurahs[index]),
          ),
        ),
      ],
    );
  }
}

class _OftenReadChip extends ConsumerWidget {
  const _OftenReadChip({required this.surah});

  final OftenReadSurah surah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    // Read, not chosen: the chip opens in whichever reader the user last
    // used, which is what keeps this a one-tap shortcut. The mode is
    // changed from inside a reader — see [ReadingModeController].
    final mode = activeReadingMode(ref);

    return Semantics(
      button: true,
      // "Al-Kahf — Fridays", "Ya-Sin — Widely read". Deliberately not
      // "read <occasion>": that phrasing turns a descriptive line into a
      // spoken instruction, which is exactly what the labels avoid.
      label: '${surah.name} — ${surah.occasion}',
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.pill,
        // 14 + text + occasion + 10 clears the 44pt minimum tap target by
        // the height of the row itself.
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(surahReadingRoute(surah.id, mode: mode));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(surah.name, style: theme.textTheme.titleSmall),
            const SizedBox(height: 2),
            Text(
              surah.occasion,
              style: theme.textTheme.labelSmall?.copyWith(
                color: palette.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
