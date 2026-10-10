import 'package:flutter/material.dart';

import '../../core/art/artwork.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/faith_theme_extension.dart';
import 'artwork_panel.dart';
import 'gap.dart';

/// A screen's title, set directly on the page rather than inside a card.
///
/// ## Why this is not a card
///
/// In this design system the card *is* the button: a thick outline around a
/// flat fill is what every tappable thing on screen wears. A masthead was
/// previously built from the same [PoppyCard] as the Practice grid tiles,
/// with only the press shadow removed — and users went on tapping it, twice
/// reporting the Practice masthead and footer as dead buttons.
///
/// Removing the shadow was not enough because the shadow was never the only
/// signal. Fill, outline, corner radius and anatomy (art band + title +
/// subtitle) were all still shared with the tiles, so the masthead differed
/// from a button in exactly one of five traits.
///
/// The rule this widget encodes instead:
///
/// > **What you can press sits *on* the page. What you can only read *is*
/// > the page.**
///
/// So there is no fill, no outline and no corner here, and the artwork runs
/// off the right edge of the screen. That last part is the signal a card can
/// never counterfeit: a card is always inset from the edge, and only the page
/// itself reaches it. The title takes [TextTheme.displaySmall] to carry the
/// presence the card used to supply.
///
/// Sits in a sliver with **no horizontal padding** — it insets its own text
/// by [AppSpacing.screenEdge] so the art can bleed. Wrapping it in padding
/// defeats the whole device.
class PageMasthead extends StatelessWidget {
  const PageMasthead({
    super.key,
    required this.title,
    required this.subtitle,
    required this.slot,
    this.height = 132,
    this.artFlex = 46,
  });

  final String title;
  final String subtitle;
  final ArtSlot slot;

  final double height;

  /// Share of the width given to the artwork, out of 100. The text column
  /// takes the rest.
  final int artFlex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;
    final palette = ext.palette;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 100 - artFlex,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.screenEdge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displaySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.inkMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: artFlex,
            child: SizedBox.expand(
              child: ArtworkPanel(
                slot: slot,
                scrim: ArtworkScrim.leftFade,
                // Fades to the *page*, not the card. On the cream ground a
                // card-coloured scrim leaves a visible white wedge exactly
                // where the fade should vanish.
                scrimColor: palette.surface,
                fallback: const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
