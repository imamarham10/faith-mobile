import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/story_collection.dart';

/// A square-ish card on the stories home grid. Mirrors `BookCard`, minus
/// the author/premium-pill treatment — story collections aren't attributed
/// to a compiler and aren't premium-gated today.
class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
  });

  final StoryCollection collection;
  final VoidCallback onTap;

  String _countLabel(int n) {
    if (n <= 0) return 'Stories';
    return n == 1 ? '1 story' : '$n stories';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.auto_stories_outlined,
              size: 18,
              color: cs.primary,
            ),
          ),
          const Spacer(),
          Text(
            collection.name,
            style: theme.textTheme.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _countLabel(collection.storyCount),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
