import 'package:flutter/material.dart';

/// A small Kaaba marker rendered at the top of the compass dial.
///
/// The colour shifts from sage to gold when the user is aligned within the
/// tolerance window, reinforcing the "you're pointing at the Qibla" moment.
class KaabaMarker extends StatelessWidget {
  const KaabaMarker({super.key, required this.aligned, this.size = 44});

  final bool aligned;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = aligned ? cs.secondary : cs.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: aligned ? 0.18 : 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: aligned
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 18,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Container(
              width: size * 0.18,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: aligned ? cs.onSecondary : cs.onPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
