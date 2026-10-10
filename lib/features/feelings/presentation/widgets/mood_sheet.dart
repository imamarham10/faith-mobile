import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../hindu_feelings/presentation/widgets/hindu_mood_chip_row.dart';
import 'mood_chip_row.dart';

/// Opens the mood chooser and resolves to the chosen emotion *slug*, or null
/// if the sheet was dismissed.
///
/// The one way into the chooser. It used to be opened from three places with
/// three copies of the sheet configuration, two of which carried their own
/// hardcoded mood list; the slug a caller gets back now always came from the
/// server, so it is always a slug the server will accept.
Future<String?> showMoodSheet(BuildContext context) {
  HapticFeedback.lightImpact();
  final theme = Theme.of(context);
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => const MoodSheet(),
  );
}

/// The mood chooser itself: faith-aware copy over a faith-aware, entirely
/// server-driven chip row. Pops the chosen slug.
class MoodSheet extends ConsumerWidget {
  const MoodSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;

    void pick(String slug) => Navigator.of(context).pop(slug);

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
            Text('How are you?', style: theme.textTheme.headlineMedium),
            const Gap(AppSpacing.sm),
            Text(
              switch (faith) {
                FaithId.islam => "There's a dua for what you're carrying.",
                FaithId.hindu => "There's a shloka for what you're carrying.",
              },
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            switch (faith) {
              FaithId.islam => MoodChipRow(onSelected: pick),
              FaithId.hindu => HinduMoodChipRow(onSelected: pick),
            },
            const Gap(AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
