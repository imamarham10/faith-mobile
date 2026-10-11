import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/faith_theme_extension.dart';

/// One control in a verse reader's pinned action row.
///
/// ## Why it is not made of a card
///
/// A card in this design system is a button, and every verse reader asserts
/// screen-wide that it contains none — the verse, its position and the
/// progress line are reading matter, and a card around any of them reads as
/// pressable. These are real controls, so they need the opposite guarantee:
/// they must be legible as controls *without* borrowing the card signature.
/// So they are flat icon-over-label targets on the page ground, the same
/// anatomy as the icon buttons in a reader's top bar, sized past the 48dp
/// minimum and inset from the screen edge.
///
/// Shared rather than copied into each vertical's action row: an action
/// that looked like a control in one reader and like a card in the other
/// would be exactly the drift these readers were factored to prevent.
class VerseActionButton extends StatelessWidget {
  const VerseActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Draws the control in the accent ink — for a state that outlives the
  /// screen, like a verse already bookmarked.
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
