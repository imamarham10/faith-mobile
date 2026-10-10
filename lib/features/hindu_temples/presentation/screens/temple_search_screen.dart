import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../controllers/temple_favorites_controller.dart';
import '../controllers/temples_browse_controller.dart';
import '../widgets/temple_list_tile.dart';

/// `/practice/temples/search` — server-side name search with debounced
/// query. Mirrors `StorySearchScreen`; client gates at 2 characters.
class TempleSearchScreen extends ConsumerStatefulWidget {
  const TempleSearchScreen({super.key});

  @override
  ConsumerState<TempleSearchScreen> createState() => _TempleSearchScreenState();
}

class _TempleSearchScreenState extends ConsumerState<TempleSearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _ctrl,
          focusNode: _focus,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search temples',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.close_rounded, size: 22),
              onPressed: () {
                HapticFeedback.selectionClick();
                _ctrl.clear();
                _onChanged('');
              },
            ),
        ],
      ),
      body: SafeArea(top: false, child: _Body(query: _query)),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (query.length < 2) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_outlined,
                size: 36,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const Gap(AppSpacing.md),
              Text('Search for a temple.', style: theme.textTheme.bodyLarge),
              const Gap(AppSpacing.xs),
              Text(
                'Type at least 2 characters.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final resultsAsync = ref.watch(templesSearchProvider(query));
    final favorites =
        ref.watch(templeFavoritesControllerProvider).valueOrNull ?? const [];
    final favsCtrl = ref.read(templeFavoritesControllerProvider.notifier);

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (_, __) => _ErrorPanel(
        message: 'Search failed.',
        onRetry: () => ref.invalidate(templesSearchProvider(query)),
      ),
      data: (hits) {
        if (hits.isEmpty) {
          return const Center(
            child: IllustratedEmptyState(
              title: 'No temples matched.',
              message: 'Try a different name or city.',
              slot: ArtSlot.emptySearch,
              mascot: MascotState.encourage,
            ),
          );
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.sm,
            AppSpacing.screenEdge,
            AppSpacing.xxl,
          ),
          itemCount: hits.length,
          separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
          itemBuilder: (_, i) {
            final temple = hits[i];
            return TempleListTile(
              temple: temple,
              isFavorite: favorites.any((f) => f.id == temple.id),
              onToggleFavorite: () {
                HapticFeedback.selectionClick();
                favsCtrl.toggle(temple);
              },
              onTap: () => context.push('/practice/temples/${temple.id}'),
            );
          },
        );
      },
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.md),
            Text(message, style: theme.textTheme.bodyLarge),
            const Gap(AppSpacing.lg),
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
