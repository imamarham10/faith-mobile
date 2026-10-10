import 'package:flutter/material.dart';

import '../../core/art/artwork.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/faith_theme_extension.dart';
import 'artwork_panel.dart';
import 'gap.dart';
import 'poppy_card.dart';

/// A screen masthead: title and subtitle in a solid column, a museum motif
/// in the other half.
///
/// **Superseded by [PageMasthead], and no longer used by any screen.** This
/// builds on [PoppyCard], and a card in this design system reads as a button
/// — which is exactly what users reported twice about the Practice tab's
/// masthead. Kept only for its golden tests; do not reach for it in new code.
///
/// The two regions are kept side by side rather than stacking text over a
/// scrimmed image. Laying a scrim across the whole band was tried first and
/// desaturated the artwork into a pale smear on-device; splitting the band
/// keeps the paint at full strength and the type at full contrast, and it
/// behaves identically in both themes because the only colour involved is
/// `palette.surfaceCard`.
///
/// Degrades to a plain titled card when the faith has no artwork for [slot]
/// or the asset fails to decode — see [ArtworkPanel].
class IllustratedHeader extends StatelessWidget {
  const IllustratedHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.slot,
    this.titleStyle,
    this.height = 128,
    this.textFlex = 48,
  });

  final String title;
  final String subtitle;
  final ArtSlot slot;

  /// Defaults to `headlineMedium`. Screens whose titles are set in
  /// `displaySmall` pass their own so this never restyles them.
  final TextStyle? titleStyle;

  final double height;

  /// Share of the width given to the text column, out of 100. Screens with
  /// a longer subtitle need more of it or the copy wraps to three lines.
  final int textFlex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          AppRadius.lg - ext.cardOutlineWidth,
        ),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Expanded(
                flex: textFlex,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                  ),
                  // Capped and shrinkable rather than free-flowing. The band
                  // is a fixed height, so a subtitle that wraps further than
                  // expected — a longer translation, a larger textScaler, a
                  // tall glyph like ﷺ, or simply a different font — must
                  // ellipsize instead of overflowing the card.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle ?? theme.textTheme.headlineMedium,
                      ),
                      const Gap(4),
                      Flexible(
                        child: Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 100 - textFlex,
                child: ArtworkPanel(
                  slot: slot,
                  scrim: ArtworkScrim.leftFade,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
