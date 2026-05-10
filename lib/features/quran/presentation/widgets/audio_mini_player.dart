import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/audio_controller.dart';

/// Mini player. Renders only when a track is loaded — short-circuits to
/// SizedBox.shrink otherwise so the parent Scaffold's bottomNavigationBar
/// slot collapses cleanly.
class AudioMiniPlayer extends ConsumerWidget {
  const AudioMiniPlayer({super.key, required this.surahName});

  final String surahName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (!state.hasTrack) return const SizedBox.shrink();

    return AnimatedSlide(
      offset: Offset.zero,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: cs.outline),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.title ?? surahName,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    state.errorMessage ?? 'Mishary Rashid Alafasy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: state.errorMessage != null
                          ? cs.error
                          : cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _SpeedPill(
              speed: state.speed,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(audioControllerProvider.notifier).cycleSpeed();
              },
              onLongPress: () => _showSpeedSheet(context, ref),
            ),
            const SizedBox(width: 4),
            _IconBtn(
              icon: Icons.skip_previous_rounded,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(audioControllerProvider.notifier).previous();
              },
            ),
            _IconBtn(
              icon: state.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              primary: true,
              busy: state.isBuffering,
              onTap: () {
                HapticFeedback.lightImpact();
                final ctl = ref.read(audioControllerProvider.notifier);
                if (state.isPlaying) {
                  ctl.pause();
                } else {
                  ctl.resume();
                }
              },
            ),
            _IconBtn(
              icon: Icons.skip_next_rounded,
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(audioControllerProvider.notifier).next();
              },
            ),
            _IconBtn(
              icon: Icons.close_rounded,
              onTap: () =>
                  ref.read(audioControllerProvider.notifier).stop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedSheet(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        final current = ref.read(audioControllerProvider).speed;
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Playback speed', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                for (final s in [...kPlaybackSpeeds]..sort())
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_label(s), style: theme.textTheme.titleMedium),
                    trailing: (s - current).abs() < 0.001
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref
                          .read(audioControllerProvider.notifier)
                          .setSpeed(s);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _label(double speed) {
    final s = speed.toStringAsFixed(2);
    final trimmed = s.endsWith('00')
        ? s.substring(0, s.length - 3)
        : (s.endsWith('0') ? s.substring(0, s.length - 1) : s);
    return '$trimmed×';
  }
}

class _SpeedPill extends StatelessWidget {
  const _SpeedPill({
    required this.speed,
    required this.onTap,
    required this.onLongPress,
  });

  final double speed;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Tooltip(
      message: 'Tap to cycle, long-press for all speeds',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Container(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 28),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outline),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            alignment: Alignment.center,
            child: Text(
              AudioMiniPlayer._label(speed),
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.primary = false,
    this.busy = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = primary ? 40.0 : 36.0;
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        iconSize: primary ? 26 : 22,
        color: primary ? cs.primary : cs.onSurface,
        icon: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
      ),
    );
  }
}
