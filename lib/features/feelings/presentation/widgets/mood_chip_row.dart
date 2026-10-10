import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/emotions_controller.dart';
import 'mood_chip.dart';

/// Wrap of the Islamic moods, used inside the chooser bottom sheet.
///
/// Sourced entirely from `GET /api/v1/islam/feelings` — the only list that
/// can be trusted, since the slug a chip carries is the slug the detail
/// endpoint is then asked for. A shipped-in-the-binary list drifts from the
/// seed data the moment either changes: six of the nine moods this used to
/// offer had no row on the Islam side at all, so six of nine chips dead-ended
/// in "Emotion with slug '…' not found". A shorter list that works beats a
/// longer one that lies, so there is deliberately no offline fallback —
/// mirrors `HinduMoodChipRow`, which has always worked this way.
class MoodChipRow extends ConsumerWidget {
  const MoodChipRow({super.key, required this.onSelected, this.selectedSlug});

  final void Function(String slug) onSelected;
  final String? selectedSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(emotionsProvider);
    return async.when(
      loading: () => const SizedBox(
        height: 44,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (_, __) => Text(
        "Couldn't load moods.",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      data: (emotions) => Wrap(
        spacing: AppSpacing.sm + 2,
        runSpacing: AppSpacing.sm + 2,
        children: [
          for (final emotion in emotions)
            MoodChip(
              label: emotion.name,
              selected: selectedSlug == emotion.slug,
              onTap: () => onSelected(emotion.slug),
            ),
        ],
      ),
    );
  }
}
