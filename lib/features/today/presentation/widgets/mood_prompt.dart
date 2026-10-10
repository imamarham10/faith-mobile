import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/poppy_card.dart';
import '../../../feelings/presentation/widgets/mood_sheet.dart';

/// Tappable card opening the mood reflection sheet.
///
/// Picking a mood lands on that mood's remedy, the same destination the
/// Reflect tab's mood door reaches. It previously awaited the sheet and threw
/// the result away, so every mood here was a dead end regardless of which
/// slug it carried.
class MoodPrompt extends StatelessWidget {
  const MoodPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return PoppyCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      onTap: () => _open(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling?',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'A moment of reflection',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward,
            size: 18,
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final slug = await showMoodSheet(context);
    if (slug == null || !context.mounted) return;
    // `go`, not `push`: the destination lives in the Reflect branch of the
    // StatefulShellRoute, and pushing another branch's route from here would
    // stack it on a navigator the shell isn't showing. `go` activates that
    // branch, so the remedy is actually on screen and Back lands on Reflect.
    context.go('/reflect/feelings/$slug');
  }
}
