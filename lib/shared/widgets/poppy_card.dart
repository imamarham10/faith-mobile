import 'package:flutter/material.dart';

import '../../core/theme/faith_theme_extension.dart';

/// The core visual unit of the poppy-comic redesign: rounded-24, thick
/// outline, flat fill. Replaces the `Container(decoration: BoxDecoration(
/// border: Border.all(color: cs.outline)))` pattern used ad hoc across the
/// app.
///
/// Comes in two looks, chosen by whether [onTap] is non-null:
///
/// * **Pressable** — adds the hard offset "sticker" shadow that collapses on
///   press. That shadow *is* the press affordance; it is the whole reason a
///   tappable card reads as a physical thing you can push.
/// * **Decorative** — a flat panel: same fill, same outline, no shadow and no
///   press animation. Still framed and separated from the background, but it
///   promises nothing.
///
/// The split exists because the sticker shadow was previously painted on
/// every card, including the ~50 that have no action. Users read the shadow
/// as "pressable", tapped, and got nothing — reported on the Practice tab's
/// masthead and footer, but true app-wide.
class PoppyCard extends StatelessWidget {
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

  /// The fill, outline and corner shared by both looks. Only [shadowOffset]
  /// differs — 0 paints no shadow at all.
  BoxDecoration _decorationFor(BuildContext context, double shadowOffset) {
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final palette = ext.palette;
    // Pre-blended to opaque: in the pressable look this decoration sits
    // inside an AnimatedContainer with a Transform for the press animation,
    // and on at least one real Android/Impeller combination, a translucent
    // BoxDecoration.color inside a transformed layer composites incorrectly
    // (renders as a much darker, near-opaque fill instead of blending
    // against whatever's behind it) — verified live on-device. Blending
    // against `surfaceCard` up front sidesteps the runtime compositing
    // entirely and is a safe default since callers only ever sit on
    // `surface`/`surfaceCard`, which are visually near-identical. A caller
    // passing an already-opaque color is unaffected (alphaBlend of a fully
    // opaque foreground returns it unchanged). The decorative look has no
    // Transform and so does not strictly need this, but it shares the
    // blend so the two looks differ in exactly one thing: the shadow.
    final fill = Color.alphaBlend(
      color ?? palette.surfaceCard,
      palette.surfaceCard,
    );
    return BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? palette.outline,
        width: ext.cardOutlineWidth,
      ),
      boxShadow: shadowOffset == 0
          ? const []
          : [BoxShadow(color: palette.shadow, offset: Offset(0, shadowOffset))],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onTap != null) return _PressablePoppyCard(card: this);

    // Decorative: flat, and deliberately *not* the pressed look. The pressed
    // look is also shadowless, but it reaches that state by translating the
    // body down by `pressOffset` — reusing it here would paint every
    // decorative card 4px lower than the tappable cards beside it in the
    // same grid row. A decorative card sits at its natural position with no
    // transform at all, so it stays aligned with its neighbours.
    //
    // Skipping AnimatedContainer also drops an AnimationController and a
    // Transform layer per card, on the majority of cards in the app.
    //
    // This must stay a Container rather than the DecoratedBox + Padding it
    // looks equivalent to: Container adds `decoration.padding` — the
    // border's own dimensions, `cardOutlineWidth` on every side — on top of
    // the padding it is given. Hand-rolling it shrinks every decorative card
    // by 2 * cardOutlineWidth in each axis and pulls its content under the
    // outline, which is a layout change, not a paint one. (Caught by the
    // today_progress goldens: 472px tall became 462px.)
    return Container(
      decoration: _decorationFor(context, 0),
      padding: padding,
      child: child,
    );
  }
}

/// The tappable look: sticker shadow at rest, collapsing to flat on press.
class _PressablePoppyCard extends StatefulWidget {
  const _PressablePoppyCard({required this.card});

  final PoppyCard card;

  @override
  State<_PressablePoppyCard> createState() => _PressablePoppyCardState();
}

class _PressablePoppyCardState extends State<_PressablePoppyCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final ext = Theme.of(context).extension<FaithThemeExtension>()!;
    final offset = _pressed ? 0.0 : ext.pressOffset;

    // Note the GestureDetector is only ever built here. A decorative card
    // skips it entirely so it never joins the tap gesture arena —
    // GestureDetector registers a tap recognizer based on onTapDown/onTapUp/
    // onTapCancel being non-null, not on onTap, so passing no-op closures
    // for those would still make an inert card a tap participant.
    return GestureDetector(
      onTap: card.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: ext.pressDuration,
        curve: Curves.easeOut,
        // Paint-only shift: a Transform (unlike `margin`) never participates
        // in layout, so it can never reflow siblings while it animates. It
        // is the identity at rest — the resting "raise" is the shadow alone.
        transform: Matrix4.translationValues(0, ext.pressOffset - offset, 0),
        transformAlignment: Alignment.center,
        decoration: card._decorationFor(context, offset),
        padding: card.padding,
        child: card.child,
      ),
    );
  }
}
