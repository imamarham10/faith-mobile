import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../feelings/presentation/widgets/mood_chip.dart';
import '../controllers/hindu_emotions_controller.dart';

/// Wrap of all Hindu moods, used inside the chooser bottom sheet. Reuses
/// `MoodChip` (already faith-aware — its accent-color math is verified for
/// both palettes) but, unlike Islam's `MoodChipRow`, sources its labels
/// from a real network list rather than a hardcoded const, since the
/// backend here is fully seeded and the two faiths' mood sets don't match
/// (Hindu has "angry"/"fearful"/"grieving"/"guilty"/"restless"/
/// "unmotivated"; Islam has "hopeful"/"lost"/"tested"/"joyful"/"searching").
class HinduMoodChipRow extends ConsumerWidget {
  const HinduMoodChipRow({super.key, required this.onSelected, this.selectedSlug});

  final void Function(String slug) onSelected;
  final String? selectedSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(hinduEmotionsProvider);
    return async.when(
      loading: () => const SizedBox(
        height: 44,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (_, __) => Text(
        'Couldn\'t load moods.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      data: (emotions) => Wrap(
        spacing: AppSpacing.sm + 2,
        runSpacing: AppSpacing.sm + 2,
        children: [
          for (final emotion in emotions)
            MoodChip(
              label: emotion.nameEnglish,
              selected: selectedSlug == emotion.slug,
              onTap: () => onSelected(emotion.slug),
            ),
        ],
      ),
    );
  }
}
