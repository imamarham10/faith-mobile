import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/location/request_location_access.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../prayers/presentation/controllers/prayer_times_controller.dart';

/// Live countdown card for the next prayer.
///
/// Wires into [prayerTimesControllerProvider] to render any of:
/// * loading shimmer
/// * a "Enable location" CTA (permission denied)
/// * an error retry surface
/// * the live countdown over today's day-arc
///
/// All four states render as a `PoppyCard` at `AppRadius.xl` (28) rather
/// than the 24 default the other Today cards (verse/hadith/mood/quick) use —
/// a deliberate "hero card" distinction, since this is the first thing on
/// the screen and the one live/ticking element.
class PrayerCountdownCard extends ConsumerWidget {
  const PrayerCountdownCard({super.key, this.onTap});

  /// Tapping any non-CTA state hits this — typically navigates to the prayer
  /// detail screen. The "Enable location" state ignores it; tapping triggers
  /// the permission flow instead.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(prayerTimesControllerProvider);

    return asyncData.when(
      loading: () => const _LoadingCard(),
      error: (e, _) => _MessageCard(
        title: 'Prayer times',
        body: 'Tap to retry',
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(prayerTimesControllerProvider.notifier).refresh();
        },
      ),
      data: (data) {
        if (data == null) {
          return _MessageCard(
            title: 'Enable location',
            body: 'For accurate prayer times',
            onTap: () async {
              HapticFeedback.lightImpact();
              final ok = await requestLocationAccess(context, ref);
              if (ok) {
                await ref
                    .read(prayerTimesControllerProvider.notifier)
                    .refresh();
              }
            },
          );
        }
        return _LiveCard(
          prayerName: data.next.displayName,
          prayerTime: data.next.time,
          dayProgress: data.next.dayProgress,
          onTap: onTap,
        );
      },
    );
  }
}

class _LiveCard extends StatefulWidget {
  const _LiveCard({
    required this.prayerName,
    required this.prayerTime,
    required this.dayProgress,
    required this.onTap,
  });

  final String prayerName;
  final DateTime prayerTime;
  final double dayProgress;
  final VoidCallback? onTap;

  @override
  State<_LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<_LiveCard> {
  late Timer _ticker;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _diff();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = _diff());
    });
  }

  @override
  void didUpdateWidget(covariant _LiveCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prayerTime != widget.prayerTime) {
      setState(() => _remaining = _diff());
    }
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  Duration _diff() {
    final d = widget.prayerTime.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }

  String get _countdownText {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    if (h <= 0) return '${m}m';
    return '${h}h ${m}m';
  }

  bool get _imminent => _remaining.inMinutes < 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final accent = _imminent ? cs.secondary : cs.primary;
    final accentText = _imminent ? palette.accentText : cs.primary;
    // "Imminent prayer" gets an accent-tinted card fill instead of the
    // default surfaceCard — computed inline from the live palette
    // (0.16 alpha matches the primaryContainer/secondaryContainer
    // convention in app_theme.dart) rather than the old hand-rolled
    // light/dark AppColors.*Soft tokens, which only ever existed as a
    // pre-poppy fallback. FaithPalette.of already resolves the correct
    // brightness, so no isDark branch is needed here.
    //
    // Pre-blended to an OPAQUE color via Color.alphaBlend rather than
    // passed as a translucent Color — PoppyCard wraps its fill in an
    // AnimatedContainer with a (possibly no-op) Transform for the press
    // animation, and on this device's Impeller/Android GPU combination a
    // translucent BoxDecoration.color inside a transformed layer composites
    // incorrectly (renders as a near-opaque, much darker fill instead of
    // blending against surfaceCard behind it) — verified live on-device.
    // Pre-blending sidesteps the runtime compositing entirely.
    final accentSoft = Color.alphaBlend(
      (_imminent ? palette.secondary : palette.primary).withValues(alpha: 0.16),
      palette.surfaceCard,
    );

    return PoppyCard(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      radius: AppRadius.xl,
      color: accentSoft,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'NEXT  ·  ${widget.prayerName}',
                style: theme.textTheme.labelSmall?.copyWith(color: accentText),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(_countdownText, style: theme.textTheme.displayLarge),
          const SizedBox(height: 6),
          Text(
            'until ${DateFormat.jm().format(widget.prayerTime)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 36,
            child: _DayArc(
              progress: widget.dayProgress.clamp(0, 1).toDouble(),
              accent: accent,
              rest: cs.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    // Radius stays AppRadius.xl (28), matching every other state of this
    // card (_LiveCard/_MessageCard) — the deliberate "hero card" distinction
    // documented on PrayerCountdownCard, not PoppyCard's 24 default.
    return const PoppySkeleton(height: 180, radius: AppRadius.xl);
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      // Callers (loading-error retry, "enable location" CTA) already fire
      // their own HapticFeedback before their side effect — don't double it.
      onTap: onTap,
      radius: AppRadius.xl,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PRAYER TIMES',
                style: theme.textTheme.labelSmall?.copyWith(color: cs.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.displaySmall),
          const SizedBox(height: 6),
          Text(body, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text('Tap to continue', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayArc extends StatelessWidget {
  const _DayArc({
    required this.progress,
    required this.accent,
    required this.rest,
  });

  final double progress;
  final Color accent;
  final Color rest;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DayArcPainter(progress: progress, accent: accent, rest: rest),
      size: const Size.fromHeight(36),
    );
  }
}

class _DayArcPainter extends CustomPainter {
  _DayArcPainter({
    required this.progress,
    required this.accent,
    required this.rest,
  });

  static const _bars = 24;
  final double progress;
  final Color accent;
  final Color rest;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 4.0;
    const totalGap = gap * (_bars - 1);
    final barWidth = (size.width - totalGap) / _bars;
    final filledCount = (progress * _bars).round().clamp(0, _bars);

    for (var i = 0; i < _bars; i++) {
      // Sine bell — tallest bars in the middle (midday).
      final t = (i + 0.5) / _bars;
      final h = (size.height * 0.4 + size.height * 0.6 * math.sin(t * math.pi))
          .clamp(4.0, size.height);

      final isFilled = i < filledCount;
      final color = isFilled ? accent.withValues(alpha: 0.5 + 0.5 * t) : rest;

      final x = i * (barWidth + gap);
      final y = size.height - h;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, h),
        const Radius.circular(2),
      );
      canvas.drawRRect(rect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _DayArcPainter old) =>
      old.progress != progress || old.accent != accent || old.rest != rest;
}
