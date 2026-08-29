import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/qibla_data.dart';
import '../../domain/qibla_math.dart';
import '../controllers/qibla_controller.dart';
import '../widgets/calibrate_hint.dart';
import '../widgets/qibla_compass.dart';

/// `/practice/qibla` — full-bleed, immersive compass.
class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  /// Tolerance window (±) for "aligned to Qibla", in degrees.
  static const double _alignmentToleranceDeg = 5;

  bool _hasFiredAlignedHaptic = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final stream = ref.watch(qiblaStreamProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Text('Qibla', style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: stream.when(
          loading: _Loading.new,
          error: (err, _) {
            if (err is LocationUnavailableException) {
              return _PermissionDenied(
                onRetry: () async {
                  final granted = await ref
                      .read(locationServiceProvider)
                      .ensurePermission();
                  if (!mounted) return;
                  if (granted) {
                    ref.invalidate(qiblaStreamProvider);
                  }
                },
              );
            }
            return _ErrorState(
              message: 'Could not load Qibla. ${err.toString()}',
              onRetry: () => ref.invalidate(qiblaStreamProvider),
            );
          },
          data: (snapshot) => _CompassView(
            snapshot: snapshot,
            tolerance: _alignmentToleranceDeg,
            onAlignmentChanged: _handleAlignmentChange,
          ),
        ),
      ),
    );
  }

  void _handleAlignmentChange({required bool aligned}) {
    if (aligned && !_hasFiredAlignedHaptic) {
      _hasFiredAlignedHaptic = true;
      HapticFeedback.heavyImpact();
    } else if (!aligned && _hasFiredAlignedHaptic) {
      // Re-arm: only when the user moves out of the tolerance window do we
      // allow the next alignment to fire a new haptic.
      _hasFiredAlignedHaptic = false;
    }
  }
}

class _CompassView extends StatelessWidget {
  const _CompassView({
    required this.snapshot,
    required this.tolerance,
    required this.onAlignmentChanged,
  });

  final QiblaSnapshot snapshot;
  final double tolerance;
  final void Function({required bool aligned}) onAlignmentChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final qibla = snapshot.qibla;
    final heading = snapshot.deviceHeading;
    final aligned =
        heading != null &&
        QiblaMath.bearingDelta(heading, qibla.bearingDegrees).abs() <=
            tolerance;

    // Notify parent on every build — cheap, parent debounces internally.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onAlignmentChanged(aligned: aligned);
    });

    final width = MediaQuery.sizeOf(context).width;
    final compassSize = (width * 0.78).clamp(240.0, 360.0);

    return Stack(
      children: [
        // Subtle radial overlay for the immersive backdrop
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.9,
                colors: [
                  (aligned ? cs.secondary : cs.primary).withValues(alpha: 0.06),
                  cs.surface,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.lg,
            AppSpacing.screenEdge,
            AppSpacing.xl,
          ),
          child: Column(
            children: [
              if (snapshot.needsCalibration || heading == null)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: CalibrateHint(),
                ),
              const Spacer(),
              if (heading == null)
                _NoCompass(distanceKm: qibla.distanceKm)
              else
                Column(
                  children: [
                    QiblaCompass(
                      deviceHeading: heading,
                      qiblaBearing: qibla.bearingDegrees,
                      aligned: aligned,
                      size: compassSize,
                    ),
                    const Gap(AppSpacing.xl),
                    _AlignmentBadge(aligned: aligned),
                  ],
                ),
              const Gap(AppSpacing.lg),
              Text(
                _distanceLabel(qibla.distanceKm),
                style: theme.textTheme.bodyMedium,
              ),
              const Spacer(),
              _LocationButton(qibla: qibla),
            ],
          ),
        ),
      ],
    );
  }

  String _distanceLabel(double km) {
    if (km < 1) return 'You are at the Kaaba.';
    final formatted = km < 10 ? km.toStringAsFixed(1) : km.toStringAsFixed(0);
    return '$formatted km to Makkah';
  }
}

class _AlignmentBadge extends StatelessWidget {
  const _AlignmentBadge({required this.aligned});

  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = aligned
        ? theme.extension<FaithThemeExtension>()!.palette.accentText
        : cs.onSurfaceVariant;
    final label = aligned ? 'Facing Qibla' : 'Turn until aligned';

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 240),
      style: theme.textTheme.labelLarge!.copyWith(
        color: color,
        letterSpacing: 1.4,
      ),
      child: Text(label.toUpperCase()),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.qibla});

  final QiblaData qibla;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return TextButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          builder: (_) => _LocationSheet(qibla: qibla),
        );
      },
      icon: Icon(Icons.place_outlined, size: 16, color: cs.onSurfaceVariant),
      label: Text(
        '${qibla.latitude.toStringAsFixed(2)}, ${qibla.longitude.toStringAsFixed(2)}',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _LocationSheet extends StatelessWidget {
  const _LocationSheet({required this.qibla});

  final QiblaData qibla;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          12,
          AppSpacing.screenEdge,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
            Text('Your location', style: theme.textTheme.headlineMedium),
            const Gap(AppSpacing.sm),
            Text(
              'Used only on this device to compute Qibla.',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            _SheetRow(
              label: 'Latitude',
              value: qibla.latitude.toStringAsFixed(5),
            ),
            const Gap(AppSpacing.sm),
            _SheetRow(
              label: 'Longitude',
              value: qibla.longitude.toStringAsFixed(5),
            ),
            const Gap(AppSpacing.sm),
            _SheetRow(
              label: 'Bearing to Kaaba',
              value: '${qibla.bearingDegrees.toStringAsFixed(1)}°',
            ),
            const Gap(AppSpacing.sm),
            _SheetRow(
              label: 'Distance',
              value: '${qibla.distanceKm.toStringAsFixed(0)} km',
            ),
            const Gap(AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _NoCompass extends StatelessWidget {
  const _NoCompass({required this.distanceKm});

  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(Icons.explore_outlined, size: 48, color: cs.onSurfaceVariant),
          const Gap(AppSpacing.base),
          Text(
            'No compass on this device',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Your bearing to Makkah is shown above.\nOpen this on a phone with a magnetometer to align.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final compassSize = (width * 0.78).clamp(240.0, 360.0);
    return Center(
      child: Shimmer.fromColors(
        baseColor: cs.outline.withValues(alpha: 0.4),
        highlightColor: cs.outline.withValues(alpha: 0.15),
        period: const Duration(milliseconds: 1400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compassSize,
              height: compassSize,
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
                border: Border.all(color: cs.outline),
              ),
            ),
            const Gap(AppSpacing.xl),
            Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  const _PermissionDenied({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child:
          Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenEdge,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: cs.outline),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_searching,
                        size: 36,
                        color: cs.primary,
                      ),
                      const Gap(AppSpacing.base),
                      Text(
                        'We need your location',
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpacing.sm),
                      Text(
                        'Qibla direction is computed from where you are. Your location stays on this device.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpacing.lg),
                      FilledButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          await onRetry();
                        },
                        child: const Text('Allow location'),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 240.ms)
              .moveY(
                begin: 8,
                end: 0,
                duration: 240.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 36, color: cs.onSurfaceVariant),
            const Gap(AppSpacing.base),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.lg),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
