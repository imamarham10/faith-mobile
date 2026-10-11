import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../domain/recitation_collection.dart';

/// The entry point to a curated set: name, what it is, how many readings.
///
/// Tapping it opens the collection's own screen — the sequence — rather
/// than any one item, because a set is a thing you work through and the
/// first decision is always *where in it am I tonight*.
///
/// Also costs nothing to show: [RecitationCollection] is a constant, so
/// this paints on the first frame of whatever hosts it.
class RecitationCollectionCard extends StatelessWidget {
  const RecitationCollectionCard({
    super.key,
    required this.collection,
    this.icon = Icons.nightlight_round,
  });

  final RecitationCollection collection;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<FaithThemeExtension>()!.palette;
    final count = collection.items.length;

    return Semantics(
      button: true,
      label: '${collection.title}, $count readings',
      excludeSemantics: true,
      child: PoppyCard(
        radius: AppRadius.xl,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(collection.route);
        },
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: cs.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    '$count readings  ·  ${collection.blurb}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.inkMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// The nightly set as it appears on the Today dashboard: present in the
/// evening, absent the rest of the day.
///
/// Today is a claim about *now*, so a card for a set read before sleep
/// earns its slot between roughly Isha and the small hours and not at
/// 10am, where it would be one more permanent thing to scroll past. It is
/// never lost by being hidden here: the card's permanent home is the
/// Qur'an tab, which is where someone looking for it at noon goes.
///
/// [now] is injectable so the hour is a parameter rather than a reading of
/// the wall clock taken inside `build` — which would make both the widget
/// and its test depend on when they ran.
class NightlyRecitationSlot extends StatelessWidget {
  const NightlyRecitationSlot({super.key, this.now});

  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final hour = (now ?? DateTime.now()).hour;
    if (!isNightlyHour(hour)) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.base),
      child: RecitationCollectionCard(collection: kNightlyRecitation),
    );
  }
}
