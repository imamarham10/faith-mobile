import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/emotions_controller.dart';
import 'mood_chip.dart';

/// Wrap of all 9 default moods, used inside the chooser bottom sheet.
class MoodChipRow extends StatelessWidget {
  const MoodChipRow({super.key, required this.onSelected, this.selectedSlug});

  final void Function(String slug) onSelected;
  final String? selectedSlug;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm + 2,
      runSpacing: AppSpacing.sm + 2,
      children: [
        for (final mood in kDefaultMoods)
          MoodChip(
            label: mood.name,
            selected: selectedSlug == mood.slug,
            onTap: () => onSelected(mood.slug),
          ),
      ],
    );
  }
}
