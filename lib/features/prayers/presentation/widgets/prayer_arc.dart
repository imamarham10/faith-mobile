import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/dtos/prayer_times.dart';

/// Full-width day arc with the 5 obligatory prayer markers.
///
/// Positions are computed from the 24-hour fraction of each prayer time. The
/// active marker (next prayer) is tinted with the primary color.
class PrayerArc extends StatelessWidget {
  const PrayerArc({
    super.key,
    required this.times,
    required this.now,
    required this.activeKey,
  });

  final PrayerTimes times;
  final DateTime now;
  final String activeKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // CustomPaint defaults its preferred size to Size.zero when there's no
    // child — pin the width via LayoutBuilder so the arc spans the card.
    return SizedBox(
      height: 96,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, 96),
            painter: _PrayerArcPainter(
              times: times,
              now: now,
              activeKey: activeKey,
              accent: theme.colorScheme.primary,
              softAccent: theme.colorScheme.primaryContainer,
              rest: theme.colorScheme.outline,
              past: theme.colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.labelSmall ?? const TextStyle(),
            ),
          );
        },
      ),
    );
  }
}

class _PrayerArcPainter extends CustomPainter {
  _PrayerArcPainter({
    required this.times,
    required this.now,
    required this.activeKey,
    required this.accent,
    required this.softAccent,
    required this.rest,
    required this.past,
    required this.labelStyle,
  });

  final PrayerTimes times;
  final DateTime now;
  final String activeKey;
  final Color accent;
  final Color softAccent;
  final Color rest;
  final Color past;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final arcHeight = size.height - 28;
    final centerY = arcHeight;
    final radiusY = arcHeight * 0.85;
    final radiusX = (size.width - 24) / 2;
    final centerX = size.width / 2;

    // Draw the rest arc.
    final restPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = rest;
    final restPath = Path();
    for (var i = 0; i <= 100; i++) {
      final t = i / 100;
      final angle = math.pi - t * math.pi;
      final x = centerX + radiusX * math.cos(angle);
      final y = centerY - radiusY * math.sin(angle);
      if (i == 0) {
        restPath.moveTo(x, y);
      } else {
        restPath.lineTo(x, y);
      }
    }
    canvas.drawPath(restPath, restPaint);

    final markers = <({String key, String label, DateTime time})>[
      (key: 'fajr', label: 'Fajr', time: times.fajr),
      (key: 'dhuhr', label: 'Dhuhr', time: times.dhuhr),
      (key: 'asr', label: 'ʿAṣr', time: times.asr),
      (key: 'maghrib', label: 'Magh.', time: times.maghrib),
      (key: 'isha', label: 'ʿIshā', time: times.isha),
    ];

    // Pass 1 — paint the dots and prepare each label's TextPainter.
    final layouts = <_LabelLayout>[];
    for (final m in markers) {
      final t = _fractionOfDay(m.time);
      final angle = math.pi - t.clamp(0.0, 1.0) * math.pi;
      final x = centerX + radiusX * math.cos(angle);
      final y = centerY - radiusY * math.sin(angle);

      final isActive = m.key == activeKey;
      final isPast = m.time.isBefore(now) && !isActive;

      final dotColor = isActive
          ? accent
          : isPast
          ? past
          : rest;

      if (isActive) {
        canvas.drawCircle(Offset(x, y), 10, Paint()..color = softAccent);
      }
      canvas.drawCircle(
        Offset(x, y),
        isActive ? 5 : 3.5,
        Paint()..color = dotColor,
      );

      final labelColor = isActive ? accent : (isPast ? past : rest);
      final tp = TextPainter(
        text: TextSpan(
          text: m.label.toUpperCase(),
          style: labelStyle.copyWith(
            color: labelColor,
            letterSpacing: 0.8,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      layouts.add(_LabelLayout(tp: tp, dotX: x));
    }

    // Pass 2 — redistribute label x-positions horizontally so close-together
    // prayers (e.g. Maghrib + ʿIshā in summer) don't collide. Labels prefer
    // sitting centered under their dots, but neighbors push each other to
    // satisfy a minimum gap. Forward sweep enforces "no overlap with the
    // previous label"; backward sweep shifts earlier labels left to make
    // room for later ones — so e.g. Asr nudges Dhuhr leftward when Maghrib
    // crowds Asr.
    const minGap = 6.0;
    final positions = layouts
        .map((l) => l.dotX.clamp(l.tp.width / 2, size.width - l.tp.width / 2))
        .toList(growable: false)
        .cast<double>();
    final widths = layouts
        .map((l) => l.tp.width)
        .toList(growable: false);

    for (var i = 1; i < positions.length; i++) {
      final minX = positions[i - 1] +
          widths[i - 1] / 2 +
          minGap +
          widths[i] / 2;
      if (positions[i] < minX) positions[i] = minX;
    }
    for (var i = positions.length - 2; i >= 0; i--) {
      final maxX = positions[i + 1] -
          widths[i + 1] / 2 -
          minGap -
          widths[i] / 2;
      if (positions[i] > maxX) positions[i] = maxX;
    }
    for (var i = 0; i < layouts.length; i++) {
      layouts[i].tp.paint(
        canvas,
        Offset(positions[i] - widths[i] / 2, centerY + 8),
      );
    }

    // "Now" indicator — vertical tick at the current 24-hour fraction.
    final nowT = _fractionOfDay(now);
    final nowAngle = math.pi - nowT * math.pi;
    final nx = centerX + radiusX * math.cos(nowAngle);
    final ny = centerY - radiusY * math.sin(nowAngle);
    canvas.drawCircle(
      Offset(nx, ny),
      2,
      Paint()..color = accent.withValues(alpha: 0.6),
    );
  }

  double _fractionOfDay(DateTime dt) {
    final start = DateTime(now.year, now.month, now.day);
    final secs = dt.difference(start).inSeconds;
    return secs / (24 * 60 * 60);
  }

  @override
  bool shouldRepaint(covariant _PrayerArcPainter old) =>
      old.times != times ||
      old.now != now ||
      old.activeKey != activeKey ||
      old.accent != accent;
}

class _LabelLayout {
  _LabelLayout({required this.tp, required this.dotX});
  final TextPainter tp;
  final double dotX;
}
