import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/onboarding_pref.dart';

/// Spec line 134 — five tradition tiles, Islam preselected, others marked
/// "Soon" since the data layer is Islam-only at MVP.
class FaithSelectionScreen extends ConsumerStatefulWidget {
  const FaithSelectionScreen({super.key});

  @override
  ConsumerState<FaithSelectionScreen> createState() =>
      _FaithSelectionScreenState();
}

class _FaithSelectionScreenState extends ConsumerState<FaithSelectionScreen> {
  String _selected = 'islam';

  static const _faiths = <_Faith>[
    _Faith(id: 'islam', label: 'Islam', symbol: '☪', enabled: true),
    _Faith(id: 'christianity', label: 'Christianity', symbol: '✝'),
    _Faith(id: 'judaism', label: 'Judaism', symbol: '✡'),
    _Faith(id: 'hinduism', label: 'Hinduism', symbol: 'ॐ'),
    _Faith(id: 'buddhism', label: 'Buddhism', symbol: '☸'),
  ];

  Future<void> _continue() async {
    HapticFeedback.mediumImpact();
    await ref.read(onboardingDoneProvider.notifier).markDone();
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pick your tradition',
                    style: GoogleFonts.fraunces(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You can change this later from settings.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                itemCount: _faiths.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final f = _faiths[i];
                  final selected = f.enabled && f.id == _selected;
                  return _FaithTile(
                    faith: f,
                    selected: selected,
                    onTap: f.enabled
                        ? () {
                            HapticFeedback.selectionClick();
                            setState(() => _selected = f.id);
                          }
                        : null,
                  ).animate().fadeIn(
                    delay: Duration(milliseconds: 80 * i),
                    duration: 360.ms,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Faith {
  const _Faith({
    required this.id,
    required this.label,
    required this.symbol,
    this.enabled = false,
  });
  final String id;
  final String label;
  final String symbol;
  final bool enabled;
}

class _FaithTile extends StatelessWidget {
  const _FaithTile({
    required this.faith,
    required this.selected,
    required this.onTap,
  });

  final _Faith faith;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final disabled = onTap == null;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: selected
                ? cs.primaryContainer.withValues(alpha: 0.45)
                : cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: selected ? cs.primary : cs.outline,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? cs.primary.withValues(alpha: 0.18)
                      : cs.onSurface.withValues(alpha: 0.05),
                ),
                alignment: Alignment.center,
                child: Text(
                  faith.symbol,
                  style: TextStyle(
                    fontSize: 22,
                    color: disabled
                        ? cs.onSurfaceVariant.withValues(alpha: 0.55)
                        : cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Text(
                  faith.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: disabled
                        ? cs.onSurfaceVariant.withValues(alpha: 0.55)
                        : cs.onSurface,
                  ),
                ),
              ),
              if (disabled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: cs.outline),
                  ),
                  child: Text(
                    'Soon',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                )
              else
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
