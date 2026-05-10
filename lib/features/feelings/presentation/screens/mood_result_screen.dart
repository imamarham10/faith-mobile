import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../data/dtos/remedy.dart';
import '../controllers/journal_controller.dart';
import '../controllers/remedies_controller.dart';
import '../widgets/mood_chip.dart';
import '../widgets/remedy_card.dart';

/// `/reflect/feelings/:mood` — single matched remedy + optional journal note.
class MoodResultScreen extends ConsumerStatefulWidget {
  const MoodResultScreen({super.key, required this.moodSlug});

  final String moodSlug;

  @override
  ConsumerState<MoodResultScreen> createState() => _MoodResultScreenState();
}

class _MoodResultScreenState extends ConsumerState<MoodResultScreen> {
  final _noteController = TextEditingController();
  final _noteFocus = FocusNode();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  String get _moodTitle {
    final raw = widget.moodSlug;
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  Future<void> _saveJournalEntry() async {
    if (_saving) return;
    final text = _noteController.text.trim();
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    try {
      await ref
          .read(journalControllerProvider.notifier)
          .add(mood: widget.moodSlug, note: text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text.isEmpty ? 'Saved.' : 'Reflection saved.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      _noteController.clear();
      _noteFocus.unfocus();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final asyncDetail = ref.watch(emotionDetailProvider(widget.moodSlug));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: Text(_moodTitle, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: asyncDetail.when(
          loading: _MoodResultLoading.new,
          error: (err, _) => _ErrorState(
            message: err.toString(),
            onRetry: () =>
                ref.invalidate(emotionDetailProvider(widget.moodSlug)),
          ),
          data: (detail) {
            final remedy = detail.remedies.isNotEmpty
                ? detail.remedies.first
                : null;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sm,
                AppSpacing.screenEdge,
                AppSpacing.xxl,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: MoodChip(label: _moodTitle, selected: true),
                ),
                const Gap(AppSpacing.lg),
                if (remedy != null)
                  RemedyCard(remedy: remedy)
                      .animate()
                      .fadeIn(duration: 280.ms)
                      .moveY(
                        begin: 8,
                        end: 0,
                        duration: 280.ms,
                        curve: Curves.easeOutCubic,
                      )
                else
                  _NoRemedy(),
                if ((detail.description ?? '').trim().isNotEmpty) ...[
                  const Gap(AppSpacing.base),
                  Text(detail.description!, style: theme.textTheme.bodyMedium),
                ],
                if (remedy != null) ...[
                  const Gap(AppSpacing.base),
                  Row(
                    children: [
                      _IconAction(
                        icon: Icons.favorite_border,
                        label: 'Save',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to favourites.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const Gap.h(AppSpacing.sm),
                      _IconAction(
                        icon: Icons.copy_outlined,
                        label: 'Copy',
                        onTap: () => _copyRemedy(remedy),
                      ),
                    ],
                  ),
                ],
                const Gap(AppSpacing.xl),
                const SectionLabel('Reflect'),
                const Gap(AppSpacing.md),
                _JournalNoteField(
                  controller: _noteController,
                  focus: _noteFocus,
                ),
                const Gap(AppSpacing.base),
                FilledButton(
                  onPressed: _saving ? null : _saveJournalEntry,
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save reflection'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _copyRemedy(Remedy remedy) {
    final buffer = StringBuffer()
      ..writeln(remedy.arabicText)
      ..writeln()
      ..writeln(remedy.translation);
    if ((remedy.source ?? '').isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('— ${remedy.source}');
    }
    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _JournalNoteField extends StatelessWidget {
  const _JournalNoteField({required this.controller, required this.focus});

  final TextEditingController controller;
  final FocusNode focus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      focusNode: focus,
      maxLines: 5,
      minLines: 3,
      textCapitalization: TextCapitalization.sentences,
      style: theme.textTheme.bodyLarge,
      decoration: const InputDecoration(hintText: "What's on your mind?"),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: cs.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: cs.onSurface),
                const Gap.h(AppSpacing.sm),
                Text(label, style: theme.textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoRemedy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: cs.outline),
      ),
      child: Text(
        'No remedy is associated with this mood yet — but your reflection still matters.',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _MoodResultLoading extends StatelessWidget {
  const _MoodResultLoading();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.base,
      ),
      child: Shimmer.fromColors(
        baseColor: cs.outline.withValues(alpha: 0.4),
        highlightColor: cs.outline.withValues(alpha: 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 32,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            const Gap(AppSpacing.lg),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 36,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const Gap(AppSpacing.base),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.lg),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
