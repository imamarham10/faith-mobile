import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/journal_entry.dart';
import '../controllers/journal_controller.dart';
import '../widgets/journal_entry_tile.dart';

/// `/reflect/journal` — chronological list of all journal entries.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _expanded = <String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncEntries = ref.watch(journalControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: Text('Journal', style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: asyncEntries.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _ErrorState(
            message: err.toString(),
            onRetry: () => ref.invalidate(journalControllerProvider),
          ),
          data: (entries) {
            if (entries.isEmpty) return const _Empty();
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.base,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.md),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Dismissible(
                  key: ValueKey('journal-${entry.id}'),
                  direction: DismissDirection.endToStart,
                  background: _DismissBackground(),
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) async {
                    HapticFeedback.heavyImpact();
                    final messenger = ScaffoldMessenger.of(context);
                    await ref
                        .read(journalControllerProvider.notifier)
                        .remove(entry.id);
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Entry removed.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: JournalEntryTile(
                    entry: entry,
                    moodLabel: _moodLabel(entry.mood),
                    expanded: _expanded.contains(entry.id),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        if (!_expanded.add(entry.id)) {
                          _expanded.remove(entry.id);
                        }
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Remove this reflection?'),
          content: const Text("This can't be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).colorScheme.error,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  static String _moodLabel(String slug) =>
      slug.isEmpty ? '' : slug[0].toUpperCase() + slug.substring(1);
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Icon(Icons.delete_outline, color: cs.error),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 40,
              color: cs.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text(
              'Your reflections will live here.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Quietly.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 36,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(AppSpacing.base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(AppSpacing.lg),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}

/// Small helper used externally — accessible from `JournalEntryTile.tap`'s
/// state without a private import.
typedef JournalEntries = List<JournalEntry>;
