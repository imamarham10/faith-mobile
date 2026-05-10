import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/dtos/hadith.dart';

/// Compact row used on the book screen and search results.
///
/// Layout: hadith-number badge · narrator + 1-line excerpt · grade chip.
class HadithListTile extends StatelessWidget {
  const HadithListTile({
    super.key,
    required this.hadith,
    required this.onTap,
    this.highlightTerm,
  });

  final Hadith hadith;
  final VoidCallback onTap;

  /// If provided, occurrences of this term in the excerpt will be highlighted
  /// in the secondary color. Case-insensitive.
  final String? highlightTerm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final narrator = (hadith.narratorChain ?? '').trim();
    final excerpt = _firstLine(hadith.textEnglish);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: cs.outline),
          ),
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumberBadge(number: hadith.hadithNumber),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            narrator.isEmpty
                                ? (hadith.book?.name ??
                                      'Hadith ${hadith.hadithNumber}')
                                : narrator,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if ((hadith.grade ?? '').isNotEmpty) ...[
                          const SizedBox(width: AppSpacing.sm),
                          GradeChip(grade: hadith.grade!),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    _Excerpt(text: excerpt, highlightTerm: highlightTerm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _firstLine(String full) {
    final trimmed = full.trim();
    if (trimmed.isEmpty) return '';
    final newline = trimmed.indexOf('\n');
    return newline == -1 ? trimmed : trimmed.substring(0, newline);
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: theme.textTheme.labelMedium?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w600,
        ),
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
    final cs = theme.colorScheme;
    final base = theme.textTheme.bodySmall;
    final term = highlightTerm?.trim() ?? '';

    if (term.isEmpty) {
      return Text(
        text,
        style: base,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lower = text.toLowerCase();
    final needle = term.toLowerCase();
    final idx = lower.indexOf(needle);
    if (idx < 0) {
      return Text(
        text,
        style: base,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + term.length),
            style: base?.copyWith(
              color: cs.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(idx + term.length)),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Grade pill — sage for Sahih, gold for Hasan, muted for the rest.
class GradeChip extends StatelessWidget {
  const GradeChip({super.key, required this.grade});

  final String grade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final lower = grade.toLowerCase();

    final (Color bg, Color fg) = switch (true) {
      _ when lower.contains('sahih') => (cs.primaryContainer, cs.primary),
      _ when lower.contains('hasan') => (cs.secondaryContainer, cs.secondary),
      _ => (cs.surface, cs.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: cs.outline),
      ),
      child: Text(
        grade,
        style: theme.textTheme.labelSmall?.copyWith(color: fg, fontSize: 10),
      ),
    );
  }
}
