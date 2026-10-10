import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/art/artwork.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/illustrated_empty_state.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_skeleton.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../feelings/data/dtos/journal_entry.dart';
import '../../../feelings/presentation/controllers/journal_controller.dart';
import '../../../feelings/presentation/widgets/mood_chip.dart';
import '../../data/dtos/hindu_remedy.dart';
import '../controllers/hindu_remedies_controller.dart';
import '../widgets/hindu_remedy_card.dart';

/// The Hindu body of `/reflect/feelings/:mood` — every matched remedy (up
/// to 4 Gita verses, each with its own reflective note — unlike Islam's
/// `_IslamMoodResultContent`, which shows only the first of its emotion's
/// remedies, since here each note is written to accompany its specific
/// verse and truncating to one would silently drop real, already-fetched
/// content) plus the same journal note field, saved through the
/// faith-neutral `journalControllerProvider` shared with Islam.
class HinduMoodResultContent extends ConsumerStatefulWidget {
  const HinduMoodResultContent({super.key, required this.moodSlug});

  final String moodSlug;

  @override
  ConsumerState<HinduMoodResultContent> createState() =>
      _HinduMoodResultContentState();
}

class _HinduMoodResultContentState
    extends ConsumerState<HinduMoodResultContent> {
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

  Future<void> _saveJournalEntry(List<HinduRemedy> remedies) async {
    if (_saving) return;
    final text = _noteController.text.trim();
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    try {
      await ref
          .read(journalControllerProvider.notifier)
          .add(
            mood: widget.moodSlug,
            note: text,
            remedies: remedies
                .map(
                  (r) => JournalRemedySnapshot(
                    primaryText: r.sanskritText,
                    script: JournalRemedyScript.sanskrit,
                    transliteration: r.transliteration,
                    translation: r.translationText,
                    reference: r.reference,
                    note: r.note.trim().isEmpty ? null : r.note,
                    deepLink: (r.textSlug != null && r.chapterNumber != null)
                        ? '/quran/hindu-scripture/${r.textSlug}/'
                              '${r.chapterNumber}?verse=${r.verseNumber}'
                        : null,
                  ),
                )
                .toList(),
          );
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
    final asyncDetail = ref.watch(hinduEmotionDetailProvider(widget.moodSlug));

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
          loading: _Loading.new,
          error: (err, _) => _ErrorState(
            message: err.toString(),
            onRetry: () =>
                ref.invalidate(hinduEmotionDetailProvider(widget.moodSlug)),
          ),
          data: (detail) {
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
                  child: MoodChip(
                    label: detail.nameHindi != null
                        ? '${detail.nameEnglish} · ${detail.nameHindi}'
                        : detail.nameEnglish,
                    selected: true,
                  ),
                ),
                const Gap(AppSpacing.lg),
                if (detail.remedies.isEmpty)
                  const _NoRemedy()
                else
                  for (var i = 0; i < detail.remedies.length; i++) ...[
                    HinduRemedyCard(remedy: detail.remedies[i])
                        .animate()
                        .fadeIn(delay: (i * 60).ms, duration: 280.ms)
                        .moveY(
                          begin: 8,
                          end: 0,
                          delay: (i * 60).ms,
                          duration: 280.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    if (i != detail.remedies.length - 1)
                      const Gap(AppSpacing.base),
                  ],
                const Gap(AppSpacing.xl),
                const SectionLabel('Reflect'),
                const Gap(AppSpacing.md),
                _JournalNoteField(
                  controller: _noteController,
                  focus: _noteFocus,
                ),
                const Gap(AppSpacing.base),
                PoppyButton(
                  label: _saving ? 'Saving…' : 'Save reflection',
                  onPressed: _saving
                      ? null
                      : () => _saveJournalEntry(detail.remedies),
                ),
              ],
            );
          },
        ),
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

class _NoRemedy extends StatelessWidget {
  const _NoRemedy();

  @override
  Widget build(BuildContext context) {
    return const IllustratedEmptyState(
      title: 'No remedy yet',
      message: 'No remedy is associated with this mood yet — but your reflection still matters.',
      slot: ArtSlot.emptyDormant,
      mascot: MascotState.sleep,
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: PoppySkeleton(height: 32, radius: AppRadius.pill),
          ),
          Gap(AppSpacing.lg),
          PoppySkeleton(height: 220, radius: AppRadius.lg),
        ],
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
            PoppyButton(label: 'Try again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
