import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/faith_theme_extension.dart';

enum PoppyButtonVariant { primary, secondary }

/// Chunky 56px-tall button with the same offset-shadow "press" language as
/// [PoppyCard]. `variant: secondary` uses the faith's secondary/accent color
/// instead of primary — for the less-emphasized action in a two-button row.
///
/// Uses `transform:` (not `margin:`) for the press-offset shift — margin is
/// layout space and would reflow sibling widgets on every press (see
/// PoppyCard's Task A6 review for why this matters).
class PoppyButton extends StatefulWidget {
  const PoppyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PoppyButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final PoppyButtonVariant variant;
  final IconData? icon;

  @override
  State<PoppyButton> createState() => _PoppyButtonState();
}

class _PoppyButtonState extends State<PoppyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final enabled = widget.onPressed != null;
    final offset = _pressed ? 0.0 : ext.pressOffset;
    // AppTheme computes onPrimary/onSecondary as separately contrast-checked
    // colors (_onColorFor(palette.primary) vs _onColorFor(palette.secondary)) —
    // they aren't guaranteed to match, so the secondary variant must read its
    // own on* color rather than hardcoding onPrimary for both. Fill and
    // onColor are computed together so a future variant can't update one and
    // forget the other.
    final (fill, onColor) = switch (widget.variant) {
      PoppyButtonVariant.primary => (
        _pressed ? palette.primaryPressed : palette.primary,
        Theme.of(context).colorScheme.onPrimary,
      ),
      PoppyButtonVariant.secondary => (
        _pressed ? palette.secondaryPressed : palette.secondary,
        Theme.of(context).colorScheme.onSecondary,
      ),
    };

    final button = AnimatedContainer(
      duration: ext.pressDuration,
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, ext.pressOffset - offset, 0),
      transformAlignment: Alignment.center,
      height: 56,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.outline, width: ext.cardOutlineWidth),
        boxShadow: offset == 0
            ? const []
            : [BoxShadow(color: palette.shadow, offset: Offset(0, offset))],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: onColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            widget.label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: onColor),
          ),
        ],
      ),
    );

    void handleTap() {
      HapticFeedback.mediumImpact();
      widget.onPressed!();
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      // The label above would duplicate the Text child's own semantics node
      // ("Continue" announced twice) unless descendant semantics are
      // excluded — this node is the single source of truth for the a11y
      // tree here. That also means the activate action must be declared
      // here directly (excludeSemantics drops the GestureDetector's own tap
      // action along with everything else it would have contributed), so
      // screen-reader/switch-access activation still fires the same
      // haptic + callback as a real touch.
      onTap: enabled ? handleTap : null,
      excludeSemantics: true,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: enabled
            ? GestureDetector(
                onTapDown: (_) => setState(() => _pressed = true),
                onTapCancel: () => setState(() => _pressed = false),
                onTapUp: (_) => setState(() => _pressed = false),
                onTap: handleTap,
                child: button,
              )
            : button,
      ),
    );
  }
}
