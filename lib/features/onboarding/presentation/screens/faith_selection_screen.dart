import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/mascot_view.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../../data/onboarding_pref.dart';

/// The redesigned front door: two mascots, side by side, in their own
/// palette. Tapping selects; Continue persists [SelectedFaith] and either
/// advances onboarding (first launch) or pops back to Settings ([standalone]).
class FaithSelectionScreen extends ConsumerStatefulWidget {
  const FaithSelectionScreen({super.key, this.standalone = false});

  /// When true (reached from Settings → "Switch faith"), Continue persists
  /// and pops instead of advancing the first-launch onboarding flow.
  final bool standalone;

  @override
  ConsumerState<FaithSelectionScreen> createState() =>
      _FaithSelectionScreenState();
}

class _FaithSelectionScreenState extends ConsumerState<FaithSelectionScreen> {
  FaithId? _selected;

  Future<void> _continue() async {
    final faith = _selected;
    if (faith == null) return;
    await ref.read(selectedFaithProvider.notifier).set(faith);
    if (!mounted) return;
    if (widget.standalone) {
      context.pop();
      return;
    }
    await ref.read(onboardingDoneProvider.notifier).markDone();
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your path',
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.standalone
                        ? 'Pick the tradition you\'d like the app to follow.'
                        : 'You can change this later from settings.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  for (final faith in FaithId.values) ...[
                    _FaithCard(
                      faith: faith,
                      selected: _selected == faith,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selected = faith);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: PoppyButton(
                  label: 'Continue',
                  onPressed: _selected == null ? null : _continue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaithCard extends StatelessWidget {
  const _FaithCard({
    required this.faith,
    required this.selected,
    required this.onTap,
  });

  final FaithId faith;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = faith.label;
    return AnimatedScale(
      duration: AppMotion.cardPress,
      scale: selected ? 1.02 : 1.0,
      child: PoppyCard(
        onTap: onTap,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            MascotView(
              faith: faith,
              state: selected ? MascotState.celebrate : MascotState.idle,
              size: 72,
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: theme.textTheme.titleLarge)),
            if (selected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
