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
    // Pre-blended to opaque: this Container sits inside an AnimatedContainer
    // with a (possibly no-op) Transform for the press animation, and on at
    // least one real Android/Impeller combination, a translucent
    // BoxDecoration.color inside a transformed layer composites incorrectly
    // (renders as a much darker, near-opaque fill instead of blending
    // against whatever's behind it) — verified live on-device. Blending
    // against `surfaceCard` up front sidesteps the runtime compositing
    // entirely and is a safe default since callers only ever sit on
    // `surface`/`surfaceCard`, which are visually near-identical. A caller
    // passing an already-opaque color is unaffected (alphaBlend of a fully
    // opaque foreground returns it unchanged).
    final fill = Color.alphaBlend(
      widget.color ?? palette.surfaceCard,
      palette.surfaceCard,
    );
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
            : [BoxShadow(color: palette.shadow, offset: Offset(0, offset))],
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
