import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/faith_theme_extension.dart';
import 'kaaba_marker.dart';

/// The compass dial.
///
/// Visual model:
///   * a circular dial that counter-rotates with the device heading so that
///     "north" on the dial always points to magnetic north
///   * a Kaaba marker rendered at the Qibla bearing on the dial
///
/// The whole composition is wrapped in a single rotation so the dial and
/// markers stay in sync as the user pivots.
class QiblaCompass extends StatelessWidget {
  const QiblaCompass({
    super.key,
    required this.deviceHeading,
    required this.qiblaBearing,
    required this.aligned,
    this.size = 280,
  });

  /// Device heading in degrees (0..360) clockwise from north. May be null
  /// when the platform has no magnetometer.
  final double? deviceHeading;

  /// Qibla bearing from current location, degrees clockwise from north.
  final double qiblaBearing;

  /// Whether the device is currently pointing within tolerance of Qibla.
  final bool aligned;

  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accentText = Theme.of(
      context,
    ).extension<FaithThemeExtension>()!.palette.accentText;
    // Counter-rotate the dial so north is fixed on the screen.
    final dialRotation = -(deviceHeading ?? 0) * math.pi / 180;
    // Place the Kaaba marker at the Qibla bearing on the dial.
    final kaabaAngle = qiblaBearing * math.pi / 180;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: dialRotation, end: dialRotation),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        builder: (context, value, _) {
          return Transform.rotate(
            angle: value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring with cardinal ticks
                CustomPaint(
                  size: Size.square(size),
                  painter: _DialPainter(
                    ringColor: cs.outline,
                    tickColor: cs.onSurfaceVariant,
                    cardinalColor: cs.onSurface,
                    accent: aligned ? cs.secondary : cs.primary,
                    accentText: aligned ? accentText : cs.primary,
                    aligned: aligned,
                    textStyle:
                        Theme.of(context).textTheme.labelSmall ??
                        const TextStyle(),
                  ),
                ),
                // Kaaba marker placed on the dial at qiblaBearing.
                Align(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: kaabaAngle,
                    child: Transform.translate(
                      offset: Offset(0, -size / 2 + 32),
                      child: Transform.rotate(
                        // Counter-rotate so the marker itself stays upright
                        // visually (the user reads it head-on).
                        angle: -kaabaAngle - value,
                        child: KaabaMarker(aligned: aligned),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.ringColor,
    required this.tickColor,
    required this.cardinalColor,
    required this.accent,
    required this.accentText,
    required this.aligned,
    required this.textStyle,
  });

  final Color ringColor;
  final Color tickColor;
  final Color cardinalColor;
  final Color accent;
  final Color accentText;
  final bool aligned;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Soft inner backdrop circle
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ringColor;
    canvas.drawCircle(center, radius - 8, bg);

    // Inner accent ring — strengthens when aligned
    final accentRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = aligned ? 2.4 : 1
      ..color = accent.withValues(alpha: aligned ? 0.55 : 0.18);
    canvas.drawCircle(center, radius - 22, accentRing);

    // Tick marks every 6° — major every 30°
    for (var deg = 0; deg < 360; deg += 6) {
      final isMajor = deg % 30 == 0;
      final angle = (deg - 90) * math.pi / 180; // 0° at top
      final outer = Offset(
        center.dx + radius * math.cos(angle) - 8 * math.cos(angle),
        center.dy + radius * math.sin(angle) - 8 * math.sin(angle),
      );
      final innerLen = isMajor ? 14.0 : 6.0;
      final inner = Offset(
        outer.dx - innerLen * math.cos(angle),
        outer.dy - innerLen * math.sin(angle),
      );
      final paint = Paint()
        ..color = isMajor ? cardinalColor : tickColor.withValues(alpha: 0.5)
        ..strokeWidth = isMajor ? 1.4 : 0.8
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(inner, outer, paint);
    }

    // Cardinal letters (N/E/S/W)
    void drawCardinal(String letter, double bearingDeg) {
      final angle = (bearingDeg - 90) * math.pi / 180;
      final r = radius - 40;
      final pos = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: letter,
          style: textStyle.copyWith(
            color: letter == 'N' ? accentText : cardinalColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 1.4,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
    }

    drawCardinal('N', 0);
    drawCardinal('E', 90);
    drawCardinal('S', 180);
    drawCardinal('W', 270);
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) =>
      old.aligned != aligned ||
      old.ringColor != ringColor ||
      old.accent != accent ||
      old.accentText != accentText;
}
