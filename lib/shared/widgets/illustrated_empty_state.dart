import 'package:flutter/material.dart';

import '../../core/art/artwork.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/faith_theme_extension.dart';
import 'artwork_panel.dart';
import 'gap.dart';
import 'mascot_view.dart';

/// The shared empty state: a motif band with the mascot resting on it, then
/// the headline, the explanation, and whatever action the screen offers.
///
/// Replaces the `Icon` + two `Text`s that every empty surface in the app
/// used to draw for itself — a shape that read as a gap rather than as a
/// designed state.
///
/// The mascot defaults to [MascotState.sleep] on purpose. It suits "nothing
/// here yet", and it is the one state in [MascotView]'s switch that returns
/// the painter unanimated: `idle` and `encourage` call
/// `.animate(onPlay: (c) => c.repeat(...))`, which never finishes and so
/// hangs any `pumpAndSettle()` that has one in the tree.
class IllustratedEmptyState extends StatelessWidget {
  const IllustratedEmptyState({
    super.key,
    required this.title,
    this.message,
    this.action,
    this.mascot = MascotState.sleep,
    this.slot = ArtSlot.empty,
  });

  final String title;
  final String? message;

  /// Rendered under the copy — usually a `PoppyButton`.
  final Widget? action;

  final MascotState mascot;
  final ArtSlot slot;

  static const double _bandHeight = 104;
  static const double _mascotSize = 76;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<FaithThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Stretch, not center. Under `center` the children only get loose
        // constraints, so the artwork band — a Stack whose only intrinsically
        // sized child is the mascot — collapsed to the mascot's 76pt width
        // and rendered as a stamp rather than a band. The copy below stays
        // centred via `textAlign`.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _bandHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    // Scrimmed, not bare: the mascot sits on this band, and
                    // it needs a calm ground under it to read against.
                    child: ArtworkPanel(
                      slot: slot,
                      faith: ext.faithId,
                      scrim: ArtworkScrim.bottom,
                      // Announced here: on an empty screen the artwork and
                      // the mascot are the only non-text content, and there
                      // is no competing list for it to get in the way of.
                      decorative: false,
                    ),
                  ),
                ),
                MascotView(
                  faith: ext.faithId,
                  state: mascot,
                  size: _mascotSize,
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.base),
          Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const Gap(AppSpacing.xs),
            Text(
              message!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const Gap(AppSpacing.lg), action!],
        ],
      ),
    );
  }
}
