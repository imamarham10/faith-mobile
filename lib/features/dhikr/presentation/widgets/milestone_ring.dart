import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A thin circular progress ring filling 0→1 toward a target.
///
/// Smoothly tweens between progress values (200ms easeOutCubic) so each
/// increment has a tiny visual nudge toward the goal — small motion that
/// communicates progress without yelling.
class MilestoneRing extends StatelessWidget {
  const MilestoneRing({
    super.key,
    required this.progress,
    this.size = 64,
    this.strokeWidth = 4,
    this.child,
  });

  /// 0..1 — fraction filled.
  final double progress;
  final double size;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: progress.clamp(0, 1).toDouble()),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: value,
              foreground: cs.primary,
              background: cs.outline,
              strokeWidth: strokeWidth,
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.foreground,
    required this.background,
    required this.strokeWidth,
  });

  final double progress;
  final Color foreground;
  final Color background;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = background;
    canvas.drawCircle(center, radius, bg);

    if (progress <= 0) return;

    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = foreground;

    const start = -math.pi / 2; // 12 o'clock
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.foreground != foreground ||
      old.background != background ||
      old.strokeWidth != strokeWidth;
}
