import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/dtos/audio_track.dart';
import '../controllers/scripture_audio_controller.dart';

/// Chapter-narration mini player. Renders only when a track is loaded.
///
/// Unlike Quran's per-ayah mini player, there's no prev/next — narration is
/// per-chapter, not per-verse — but there IS a reciter/language switcher
/// (long-press the reciter name) since the backend can offer more than one
/// narration per chapter.
///
/// Explicit height: this widget sits in Scaffold.bottomNavigationBar, which
/// lays it out with a *loose* height constraint and uses whatever height it
/// reports back — an unconstrained Container/PoppyCard here was found live
/// on-device (Quran module, Part B3) to report back almost the full screen
/// height instead of its content height. A tight height sidesteps that.
class AudioMiniPlayer extends ConsumerWidget {
  const AudioMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scriptureAudioControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (!state.hasTrack) return const SizedBox.shrink();

    return AnimatedSlide(
      offset: Offset.zero,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: cs.outline, width: 2),
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
              child: Icon(Icons.menu_book_rounded, size: 20, color: cs.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onLongPress: state.availableTracks.length > 1
                    ? () => _showReciterSheet(context, ref)
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.chapterTitle ?? '',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.errorMessage ??
                          state.currentTrack?.name ??
                          'Narration',
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
            ),
            _IconBtn(
              icon: state.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              primary: true,
              busy: state.isBuffering,
              onTap: () {
                HapticFeedback.lightImpact();
                final ctl = ref.read(scriptureAudioControllerProvider.notifier);
                if (state.isPlaying) {
                  ctl.pause();
                } else {
                  ctl.resume();
                }
              },
            ),
            _IconBtn(
              icon: Icons.close_rounded,
              onTap: () =>
                  ref.read(scriptureAudioControllerProvider.notifier).stop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showReciterSheet(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    final cs = Theme.of(context).colorScheme;
    final state = ref.read(scriptureAudioControllerProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Narration', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                for (final AudioTrack t in state.availableTracks)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(t.name, style: theme.textTheme.titleMedium),
                    subtitle: Text(t.language),
                    trailing: t.reciterSlug == state.currentTrack?.reciterSlug
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref
                          .read(scriptureAudioControllerProvider.notifier)
                          .switchTrack(t);
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
