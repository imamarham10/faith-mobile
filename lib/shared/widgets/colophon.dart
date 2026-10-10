import 'package:flutter/material.dart';

import '../../core/art/artwork.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/faith_theme_extension.dart';
import 'artwork_panel.dart';
import 'gap.dart';

/// A closing line at the foot of a scroll: a small centred motif over a
/// steadying sentence, set on the page itself.
///
/// ## Why a colophon, and why centred
///
/// This replaces a full-width card that carried the same art-band-over-title
/// anatomy as the Practice grid tiles. At the same width, with the same
/// outline and the same fill, it was structurally indistinguishable from a
/// tile — just wider — so it was read as a button and tapped. Removing the
/// press shadow did not fix that, because the outline and fill were doing
/// the talking.
///
/// A colophon is the real-world form for this content: both Islamic and
/// Indic manuscript traditions close a text with a tailpiece — an ornament
/// and a closing line, marking an ending rather than offering an action.
/// Leaning on that gives the content a shape it can hold honestly.
///
/// Two things do the work:
///
/// * **No container.** No fill, no outline, no corner. The white panel
///   against the cream ground was itself most of the "this is an object"
///   cue, before the shadow was ever considered.
/// * **Centred.** Every control on these screens is left-aligned in a grid.
///   Centring is unavailable to the grid, so it reads as a different kind of
///   thing rather than a quieter version of the same thing.
///
/// The ornament is deliberately small. A wide band is a banner, and banners
/// are tappable in most apps people use.
class Colophon extends StatelessWidget {
  const Colophon({
    super.key,
    required this.line,
    required this.caption,
    required this.slot,
    this.ornamentAlignment = Alignment.center,
    this.ornamentWidth = 190,
    this.ornamentHeight = 26,
  });

  /// The closing sentence, e.g. 'Little and often.'
  final String line;

  /// The quieter line beneath it.
  final String caption;

  final ArtSlot slot;

  /// Which part of the band to sample for the rule. Most slots are
  /// photographs of objects, and an arbitrary middle crop of one is a smear;
  /// pass the alignment that lands on an actually ornamental region — for an
  /// illuminated page that is [Alignment.topCenter], the border.
  final Alignment ornamentAlignment;

  /// The ornamental rule is a wide, shallow strip, and both parts of that
  /// matter.
  ///
  /// **Wide**, because every [ArtSlot] asset is encoded as a banner — around
  /// 900px across. Cropping one into a small square samples an arbitrary
  /// patch of it, which rendered on-device as an unreadable smudge; at the
  /// band's own proportions the border pattern is legible as a pattern.
  ///
  /// **Shallow**, because a 56px circle is a button shape — avatars, FABs
  /// and icon buttons are all circles, so the first version of this widget
  /// reintroduced exactly the affordance the rest of it removes. A strip
  /// this thin is not a credible tap target.
  final double ornamentWidth;
  final double ornamentHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;
    final palette = ext.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: ornamentWidth,
            height: ornamentHeight,
            // Dissolves at both ends instead of being cut off, so it reads
            // as an ornament laid on the page rather than a cropped picture
            // sitting in an invisible box. `dstIn` keeps the artwork's own
            // colour and takes only alpha from the gradient.
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x00000000),
                  Color(0xFF000000),
                  Color(0xFF000000),
                  Color(0x00000000),
                ],
                stops: [0, 0.22, 0.78, 1],
              ).createShader(rect),
              child: ArtworkPanel(
                slot: slot,
                scrim: ArtworkScrim.none,
                alignment: ornamentAlignment,
                fallback: const SizedBox.shrink(),
              ),
            ),
          ),
          const Gap(AppSpacing.base),
          Text(
            line,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const Gap(AppSpacing.xs),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: palette.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
