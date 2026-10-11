import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/hadiths_repository.dart';
import '../../data/dtos/hadith_book.dart';

/// A square-ish card on the hadiths home grid.
///
/// Minimalist: small sage book glyph, name in `titleLarge`, author + count
/// in `bodySmall`. There is no paid-tier badge: this build only ever
/// receives free collections (see [HadithsRepository.getBooks]), so a badge
/// would have nothing to mark.
class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.onTap});

  final HadithBook book;
  final VoidCallback onTap;

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
          Row(
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
                  Icons.menu_book_outlined,
                  size: 18,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            book.name,
            style: theme.textTheme.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if ((book.author ?? '').isNotEmpty)
            Text(
              book.author!,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            Text(
              _countLabel(book.totalHadiths),
              style: theme.textTheme.bodySmall,
            ),
          if ((book.author ?? '').isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              _countLabel(book.totalHadiths),
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _countLabel(int n) {
    if (n <= 0) return 'Hadiths';
    if (n == 1) return '1 hadith';
    if (n >= 1000) {
      final thousands = (n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1);
      return '$thousands K hadiths';
    }
    return '$n hadiths';
  }
}
