import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_theme_extension.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/dtos/hindu_story.dart';

/// Compact row used on the collection screen, search results, and
/// favorites. Mirrors `HadithListTile`, minus the number badge/grade chip
/// — stories aren't citation-graded, and `storyNumber` is often absent.
class StoryListTile extends StatelessWidget {
  const StoryListTile({
    super.key,
    required this.story,
    required this.onTap,
    this.highlightTerm,
  });

  final HinduStory story;
  final VoidCallback onTap;

  /// If provided, occurrences of this term in the summary will be
  /// highlighted in the accent color. Case-insensitive.
  final String? highlightTerm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PoppyCard(
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.base),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            story.title,
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _Excerpt(text: story.summary, highlightTerm: highlightTerm),
        ],
      ),
    );
  }
}

class _Excerpt extends StatelessWidget {
  const _Excerpt({required this.text, this.highlightTerm});

  final String text;
  final String? highlightTerm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentText = theme
        .extension<FaithThemeExtension>()!
        .palette
        .accentText;
    final base = theme.textTheme.bodySmall;
    final term = highlightTerm?.trim() ?? '';

    if (term.isEmpty) {
      return Text(text, style: base, maxLines: 2, overflow: TextOverflow.ellipsis);
    }

    final lower = text.toLowerCase();
    final needle = term.toLowerCase();
    final idx = lower.indexOf(needle);
    if (idx < 0) {
      return Text(text, style: base, maxLines: 2, overflow: TextOverflow.ellipsis);
    }

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + term.length),
            style: base?.copyWith(color: accentText, fontWeight: FontWeight.w600),
          ),
          TextSpan(text: text.substring(idx + term.length)),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
