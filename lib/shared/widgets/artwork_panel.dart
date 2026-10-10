import 'package:flutter/material.dart';

import '../../core/art/artwork.dart';
import '../../core/theme/faith_id.dart';
import '../../core/theme/faith_theme_extension.dart';

/// How the artwork is tied back to the card it sits on.
///
/// Every scrim is mixed from `palette.surfaceCard`, never a literal colour,
/// which is what makes one asset correct on both the cream light ground and
/// the near-black dark one without per-image or per-theme tuning: the
/// gradient always resolves to whatever the card is actually painted in.
enum ArtworkScrim {
  /// Opaque at the bottom, clear well before the top. Short on purpose: a
  /// scrim that reaches across the whole panel desaturates the artwork into
  /// a pale smear, which is what it looked like on-device the first time.
  /// Only use this where text genuinely sits *over* the image.
  bottom,

  /// Opaque at the left edge, clear by a third. Softens the seam where an
  /// artwork band butts up against a solid text column, so the two read as
  /// one card rather than two glued panels.
  leftFade,

  /// No scrim — the artwork is clipped and shown at full saturation. The
  /// default for banded layouts, where the art has its own region and never
  /// competes with text.
  none,
}

/// Renders one [ArtSlot]'s artwork, treated so it sits on the app's grounds,
/// and **degrades to [fallback] rather than failing** on any of the three
/// ways artwork can be absent:
///
/// 1. the faith has no entry for the slot ([artworkFor] returns null),
/// 2. the asset is missing from the bundle or corrupt (`errorBuilder`),
/// 3. the asset is still decoding (`frameBuilder` — the box is already
///    reserved at the right aspect ratio, so nothing reflows when it lands).
///
/// A decorative asset must never be able to take a card down, so all three
/// paths end at the same widget the card would have shown before any
/// artwork existed.
class ArtworkPanel extends StatelessWidget {
  const ArtworkPanel({
    super.key,
    required this.slot,
    this.faith,
    this.scrim = ArtworkScrim.bottom,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.fallback,
    this.decorative = true,
    this.scrimColor,
  });

  final ArtSlot slot;

  /// Defaults to the faith the theme is already built for, so callers that
  /// are inside a themed subtree never have to plumb it through.
  final FaithId? faith;

  final ArtworkScrim scrim;
  final BoxFit fit;
  final Alignment alignment;

  /// Shown whenever artwork is unavailable. Null means "render nothing",
  /// which is the right answer for purely decorative positions.
  final Widget? fallback;

  /// Whether this artwork is purely decoration, and so hidden from assistive
  /// technology. **Defaults to true**, because most slots sit on a card that
  /// already carries a title and a subtitle: announcing a line of museum
  /// catalogue copy before each one would put four extra strings between a
  /// TalkBack user and the word "Dhikr" on the Practice grid alone.
  ///
  /// Pass false only where the artwork is genuinely the card's content — an
  /// empty state, where there is nothing else to describe.
  final bool decorative;

  /// What the scrim fades *to*. Defaults to `palette.surfaceCard`, which is
  /// right for every artwork sitting inside a card.
  ///
  /// Uncontained artwork — art placed straight onto the page rather than in
  /// a card — must pass `palette.surface` instead. The two are not
  /// interchangeable: the card is white and the page is warm cream, so a
  /// card-coloured scrim over the page ground leaves a pale wedge exactly
  /// where the fade is supposed to disappear.
  final Color? scrimColor;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final art = artworkFor(faith ?? ext.faithId, slot);
    final empty = fallback ?? const SizedBox.shrink();
    if (art == null) return empty;

    final card = scrimColor ?? ext.palette.surfaceCard;

    return RepaintBoundary(
      child: Builder(
        builder: (_) {
          // No `cacheWidth`. Every asset in `assets/art/` is already encoded
          // at its display size (360px for a grid tile, 900px for a
          // full-width band), so a decode target derived from layout is at
          // best a no-op and at worst an upscale — a 167pt tile on a 3x
          // screen asks for 501px, which would decode a 360px file larger
          // than it is and cost memory for no sharpness. Natural size is the
          // right size, and it keeps the provider a plain `AssetImage`.
          final image = Image.asset(
            art.assetKey,
            fit: fit,
            alignment: alignment,
            excludeFromSemantics: decorative,
            semanticLabel: decorative ? null : art.semanticLabel,
            // Settle in rather than pop: the fade is driven by the decode
            // itself, so it reads as the image arriving, and it is finite —
            // an infinitely repeating decoration would hang every
            // `pumpAndSettle` in the suite.
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                child: child,
              );
            },
            errorBuilder: (context, error, stack) => empty,
          );

          final gradient = switch (scrim) {
            ArtworkScrim.none => null,
            ArtworkScrim.bottom => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                card,
                card.withValues(alpha: 0.82),
                card.withValues(alpha: 0),
              ],
              stops: const [0, 0.26, 0.58],
            ),
            ArtworkScrim.leftFade => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [card, card.withValues(alpha: 0)],
              stops: const [0, 0.34],
            ),
          };

          return Stack(
            fit: StackFit.passthrough,
            children: [
              image,
              if (gradient != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(gradient: gradient),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
