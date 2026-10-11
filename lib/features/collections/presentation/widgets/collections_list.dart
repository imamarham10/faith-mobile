import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../controllers/collections_controller.dart';
import 'collection_card.dart';

/// Every collection a faith has, as a column of cards.
///
/// The browsing surface — the Qur'an tab, the Scripture tab and Practice —
/// as against [CollectionsRail], which is the dashboard's featured few.
///
/// ## Why this list is not filtered by `showOnHome`
///
/// Featuring decides *placement*, never *availability*. A collection the
/// database has not featured must still be findable, and this is where
/// someone looking for one goes. If this list were filtered too, turning a
/// flag off would make a set unreachable rather than unfeatured — which is
/// the failure the dashboard's old time-of-day rule came closest to.
///
/// ## States
///
/// All four, unlike the rail. This screen was opened on purpose, so a
/// shimmer is an honest "it is coming" and a failure is worth a retry —
/// neither is noise here the way both would be above the goal card. Empty
/// still draws nothing at all, heading included: a faith with no
/// collections has nothing to say, not an empty box to say it in.
class CollectionsList extends ConsumerWidget {
  const CollectionsList({super.key, required this.faith, this.label = 'Collections'});

  final FaithId faith;

  /// The heading. Rendered only alongside content — never over an empty
  /// list.
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(collectionsProvider(faith));

    return async.when(
      loading: () => _Framed(
        label: label,
        child: const PoppySkeleton(height: 80, radius: AppRadius.xl),
      ),
      error: (_, __) => _Framed(
        label: label,
        child: _ErrorRow(
          onRetry: () {
            HapticFeedback.heavyImpact();
            ref.invalidate(collectionsProvider(faith));
          },
        ),
      ),
      data: (collections) {
        if (collections.isEmpty) return const SizedBox.shrink();
        return _Framed(
          label: label,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < collections.length; i++) ...[
                CollectionCard(collection: collections[i]),
                if (i != collections.length - 1) const Gap(AppSpacing.md),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Heading plus content, so the three populated states indent identically
/// and the empty one can opt out of both in a single `return`.
class _Framed extends StatelessWidget {
  const _Framed({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label),
        const Gap(AppSpacing.md),
        child,
      ],
    );
  }
}

/// A failed list, and a way to ask again.
///
/// Deliberately not a card. A card in this design system is a button, and a
/// full-width card here would be a card-shaped thing whose only live target
/// is the small button inside it — the exact anatomy behind this project's
/// dead-click reports. So the message is plain text on the page and the
/// only pressable thing is an actual button.
class _ErrorRow extends StatelessWidget {
  const _ErrorRow({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            "Collections didn't load.",
            style: theme.textTheme.bodyMedium,
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}
