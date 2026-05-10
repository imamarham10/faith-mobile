import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../shared/widgets/gap.dart';
import '../../data/dtos/dhikr_counter.dart';
import '../controllers/dhikr_counter_controller.dart';
import '../controllers/dhikr_counters_controller.dart';
import '../widgets/milestone_ring.dart';

/// The marquee Dhikr screen. Tap-anywhere increment, optimistic + debounced.
class DhikrCounterScreen extends ConsumerStatefulWidget {
  const DhikrCounterScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends ConsumerState<DhikrCounterScreen> {
  /// Drives the on-milestone flash on the count number.
  int _flashKey = 0;

  Future<void> _onTapZone() async {
    final result = ref
        .read(dhikrCounterControllerProvider(widget.id).notifier)
        .increment();
    if (result.count == 0) return;
    if (result.isMilestone) {
      await HapticFeedback.heavyImpact();
      if (!mounted) return;
      setState(() => _flashKey++);
    } else {
      await HapticFeedback.mediumImpact();
    }
  }

  Future<void> _confirmReset(DhikrCounter counter) async {
    HapticFeedback.lightImpact();
    final ok = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: const Text('Reset count?'),
        content: const Text('This will set the count back to zero.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await HapticFeedback.mediumImpact();
    await ref.read(dhikrCounterControllerProvider(widget.id).notifier).reset();
  }

  Future<void> _editTarget(DhikrCounter counter) async {
    final controller = TextEditingController(
      text: counter.targetCount.toString(),
    );
    final next = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog.adaptive(
          title: const Text('Change goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Target count'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final n = int.tryParse(controller.text.trim());
                Navigator.of(ctx).pop(n);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (next == null || next <= 0) return;
    await HapticFeedback.mediumImpact();
    await ref
        .read(dhikrCounterControllerProvider(widget.id).notifier)
        .setTarget(next);
  }

  Future<void> _confirmDelete() async {
    HapticFeedback.lightImpact();
    final ok = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: const Text('Delete counter?'),
        content: const Text('This counter and its history will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await HapticFeedback.heavyImpact();
    await ref.read(dhikrCountersControllerProvider.notifier).delete(widget.id);
    if (!mounted) return;
    context.pop();
  }

  Future<void> _doneAndPop() async {
    HapticFeedback.mediumImpact();
    await ref.read(dhikrCounterControllerProvider(widget.id).notifier).flush();
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final async = ref.watch(dhikrCounterControllerProvider(widget.id));

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        // Best-effort flush — controller also flushes on dispose.
        ref.read(dhikrCounterControllerProvider(widget.id).notifier).flush();
      },
      child: Scaffold(
        appBar: AppBar(
          title: async.maybeWhen(
            data: (c) => Text(
              c.phraseTransliteration ?? c.phraseEnglish ?? c.name,
              style: theme.textTheme.titleMedium,
            ),
            orElse: () => const Text('Counter'),
          ),
          centerTitle: true,
          actions: [
            async.maybeWhen(
              data: (c) => PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (key) {
                  switch (key) {
                    case 'reset':
                      _confirmReset(c);
                    case 'goal':
                      _editTarget(c);
                    case 'delete':
                      _confirmDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'reset', child: Text('Reset count')),
                  PopupMenuItem(value: 'goal', child: Text('Change goal')),
                  PopupMenuItem(value: 'delete', child: Text('Delete counter')),
                ],
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        body: SafeArea(
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Couldn\'t load this counter',
                      style: theme.textTheme.titleMedium,
                    ),
                    const Gap(8),
                    Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const Gap(16),
                    FilledButton(
                      onPressed: () =>
                          ref.invalidate(dhikrCounterControllerProvider),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
            data: (counter) {
              final target = counter.targetCount > 0 ? counter.targetCount : 33;
              final progress = (counter.count / target)
                  .clamp(0.0, 1.0)
                  .toDouble();
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _onTapZone,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenEdge,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(24),
                            if (counter.phraseArabic != null &&
                                counter.phraseArabic!.isNotEmpty)
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  counter.phraseArabic!,
                                  textAlign: TextAlign.center,
                                  style: arabicTextStyleOf(
                                    ref,
                                    fontSize: 36,
                                    height: 1.6,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                            const Gap(12),
                            if ((counter.phraseTransliteration ??
                                    counter.phraseEnglish ??
                                    counter.name)
                                .isNotEmpty)
                              Text(
                                counter.phraseTransliteration ??
                                    counter.phraseEnglish ??
                                    counter.name,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium,
                              ),
                            if ((counter.meaning ?? '').isNotEmpty) ...[
                              const Gap(2),
                              Text(
                                counter.meaning!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                            const Spacer(),
                            _CountHero(
                              count: counter.count,
                              target: target,
                              progress: progress,
                              flashKey: _flashKey,
                            ),
                            const Spacer(),
                            Text(
                              'Tap anywhere to count',
                              style: theme.textTheme.labelSmall,
                            ),
                            const Gap(20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenEdge,
                      AppSpacing.sm,
                      AppSpacing.screenEdge,
                      AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              side: BorderSide(color: cs.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                            ),
                            onPressed: () => _confirmReset(counter),
                            child: const Text('Reset'),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                            ),
                            onPressed: _doneAndPop,
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CountHero extends StatelessWidget {
  const _CountHero({
    required this.count,
    required this.target,
    required this.progress,
    required this.flashKey,
  });

  final int count;
  final int target;
  final double progress;
  final int flashKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 220,
          width: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              MilestoneRing(progress: progress, size: 220, strokeWidth: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(anim);
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child:
                    Text(
                          '$count',
                          key: ValueKey<int>(count),
                          style: theme.textTheme.displayLarge,
                        )
                        .animate(key: ValueKey<int>(flashKey))
                        .scaleXY(
                          begin: 1.0,
                          end: 1.08,
                          duration: 140.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .then()
                        .scaleXY(
                          begin: 1.08,
                          end: 1.0,
                          duration: 220.ms,
                          curve: Curves.easeInCubic,
                        ),
              ),
            ],
          ),
        ),
        const Gap(8),
        Text(
          target > 0 ? 'Goal $target' : 'Free count',
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
