import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// The core visual unit of the poppy-comic redesign: rounded-24, thick
/// outline, flat fill, a hard offset "sticker" shadow that collapses on
/// press. Replaces the `Container(decoration: BoxDecoration(border:
/// Border.all(color: cs.outline)))` pattern used ad hoc across the app.
class PoppyCard extends StatefulWidget {
  const PoppyCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.radius = 24,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  State<PoppyCard> createState() => _PoppyCardState();
}

class _PoppyCardState extends State<PoppyCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    final fill = widget.color ?? palette.surfaceCard;
    final border = widget.borderColor ?? palette.outline;
    final offset = _pressed ? 0.0 : ext.pressOffset;

    final card = AnimatedContainer(
      duration: ext.pressDuration,
      curve: Curves.easeOut,
      // Paint-only shift: a Transform (unlike `margin`) never participates in
      // layout, so it can never reflow siblings while it animates.
      transform: Matrix4.translationValues(0, ext.pressOffset - offset, 0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: border, width: ext.cardOutlineWidth),
        boxShadow: offset == 0
            ? const []
            : [
                BoxShadow(
                  color: palette.shadow,
                  offset: Offset(0, offset),
                ),
              ],
      ),
      padding: widget.padding,
      child: widget.child,
    );

    // Decorative cards (no onTap) skip GestureDetector entirely so they
    // never join the tap gesture arena — GestureDetector registers a tap
    // recognizer based on onTapDown/onTapUp/onTapCancel being non-null,
    // not on onTap, so passing no-op closures for those would still make
    // an inert card a tap participant.
    if (widget.onTap == null) return card;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: card,
    );
  }
}
