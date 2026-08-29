import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/faith_id.dart';
import '../../core/theme/faith_palette.dart';

enum MascotState { idle, celebrate, encourage, sleep }

/// Coded-vector mascot: one shared rig (body/eyes/mouth) + a faith-specific
/// accessory (crescent-and-star topper for Islam, diya-flame crown for
/// Hindu). See design doc §2 for the rationale on why this is drawn in code
/// rather than sourced — no licensable "character" mascot exists for either
/// motif.
class MascotView extends StatelessWidget {
  const MascotView({
    super.key,
    required this.faith,
    this.state = MascotState.idle,
    this.size = 96,
  });

  final FaithId faith;
  final MascotState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final palette = FaithPalette.of(faith, brightness);
    final painter = CustomPaint(
      size: Size.square(size),
      painter: _MascotPainter(faith: faith, state: state, palette: palette),
    );

    final animated = switch (state) {
      MascotState.idle =>
        painter
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: 0,
              end: -4,
              duration: 1200.ms,
              curve: Curves.easeInOut,
            ),
      MascotState.celebrate =>
        painter
            .animate()
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.15, 1.15),
              duration: 220.ms,
              curve: Curves.easeOut,
            )
            .then()
            .scale(
              begin: const Offset(1.15, 1.15),
              end: const Offset(1, 1),
              duration: 380.ms,
              curve: Curves.elasticOut,
            ),
      MascotState.encourage =>
        painter
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .rotate(begin: -0.02, end: 0.02, duration: 900.ms),
      MascotState.sleep => painter,
    };

    return SizedBox(width: size, height: size, child: animated);
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({
    required this.faith,
    required this.state,
    required this.palette,
  });

  final FaithId faith;
  final MascotState state;
  final FaithPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.38;

    final bodyPaint = Paint()..color = palette.primary;
    final outlinePaint = Paint()
      ..color = palette.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    // Body — a rounded blob, shared rig.
    canvas.drawCircle(center, bodyRadius, bodyPaint);
    canvas.drawCircle(center, bodyRadius, outlinePaint);

    _paintFace(canvas, size, center, bodyRadius);
    _paintAccessory(canvas, size, center, bodyRadius);
  }

  void _paintFace(Canvas canvas, Size size, Offset center, double r) {
    final eyePaint = Paint()..color = palette.ink;
    // Both eyes share the same vertical position (dy) and mirror across the
    // vertical axis (±dx) so the face reads as level, not lopsided.
    const eyeDxFactor = 0.32;
    const eyeDyFactor = -0.1;
    final leftEyeCenter = center + Offset(-r * eyeDxFactor, r * eyeDyFactor);
    final rightEyeCenter = center + Offset(r * eyeDxFactor, r * eyeDyFactor);
    final eyeRadius = size.width * 0.035;

    if (state == MascotState.sleep) {
      final strokePaint = Paint()
        ..color = palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.02
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(
          center: leftEyeCenter,
          width: size.width * 0.1,
          height: size.width * 0.05,
        ),
        0,
        math.pi,
        false,
        strokePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: rightEyeCenter,
          width: size.width * 0.1,
          height: size.width * 0.05,
        ),
        0,
        math.pi,
        false,
        strokePaint,
      );
    } else {
      canvas.drawCircle(leftEyeCenter, eyeRadius, eyePaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius, eyePaint);
    }

    // Mouth — happier arc for celebrate, flat for encourage/idle, small for
    // sleep. The arc is always centered on the ellipse's bottom point (pi/2)
    // so it reads as a symmetric smile regardless of sweep width.
    final mouthPaint = Paint()
      ..color = palette.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;
    final mouthCenter = center + Offset(0, r * 0.3);
    final sweep = switch (state) {
      MascotState.celebrate => 2.6,
      MascotState.sleep => 0.8,
      _ => 1.6,
    };
    final startAngle = (math.pi / 2) - (sweep / 2);
    canvas.drawArc(
      Rect.fromCenter(center: mouthCenter, width: r * 0.6, height: r * 0.35),
      startAngle,
      sweep,
      false,
      mouthPaint,
    );
  }

  void _paintAccessory(Canvas canvas, Size size, Offset center, double r) {
    final accentPaint = Paint()..color = palette.mascotAccent;
    // 0.85r (rather than the head radius 1.0r) so the accessory's base sits
    // over the top of the head — like a topper resting on it — while its
    // highest point still clears the canvas edge with margin at small sizes.
    final top = center - Offset(0, r * 0.85);

    switch (faith) {
      case FaithId.islam:
        // Crescent-and-star topper. A same-size "eraser" circle offset
        // toward one side is subtracted (Path.combine.difference) rather
        // than XOR'd (evenOdd), which matters here: evenOdd between two
        // equal circles leaves slivers on *both* sides — reading as a
        // ring/"O", not a crescent — whereas a one-sided subtraction
        // leaves the single sliver that actually reads as a moon.
        final crescentOuter = Rect.fromCenter(
          center: top,
          width: r * 0.55,
          height: r * 0.55,
        );
        final outerPath = Path()..addOval(crescentOuter);
        final eraserPath = Path()
          ..addOval(crescentOuter.translate(r * 0.16, -r * 0.05));
        final crescentPath = Path.combine(
          PathOperation.difference,
          outerPath,
          eraserPath,
        );
        canvas.drawPath(crescentPath, accentPaint);
        canvas.drawCircle(
          top + Offset(r * 0.3, -r * 0.06),
          r * 0.06,
          accentPaint,
        );
      case FaithId.hindu:
        // Diya-flame crown: a small teardrop above the head.
        final flamePath = Path()
          ..moveTo(top.dx, top.dy - r * 0.35)
          ..quadraticBezierTo(
            top.dx + r * 0.22,
            top.dy + r * 0.1,
            top.dx,
            top.dy + r * 0.3,
          )
          ..quadraticBezierTo(
            top.dx - r * 0.22,
            top.dy + r * 0.1,
            top.dx,
            top.dy - r * 0.35,
          )
          ..close();
        canvas.drawPath(flamePath, accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.faith != faith ||
      oldDelegate.state != state ||
      oldDelegate.palette != palette;
}
