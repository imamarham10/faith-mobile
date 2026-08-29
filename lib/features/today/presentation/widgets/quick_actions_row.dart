import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/poppy_card.dart';
import '../../../../shared/widgets/poppy_icon.dart';
import '../../../quran/presentation/controllers/quran_home_controller.dart';

/// Three-up grid of headlining quick-actions on the Today screen.
class QuickActionsRow extends ConsumerWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastRead = ref.watch(lastReadControllerProvider).valueOrNull;
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.explore_outlined,
            label: 'Qibla',
            onTap: () => context.push('/practice/qibla'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.fingerprint,
            label: 'Tasbih',
            onTap: () => context.push('/practice/dhikr'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            icon: Icons.bookmark_border,
            label: 'Last read',
            onTap: () {
              if (lastRead != null) {
                context.push(
                  '/quran/surah/${lastRead.surahId}?ayah=${lastRead.verseNumber}',
                );
              } else {
                context.push('/quran');
              }
            },
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
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
    return PoppyCard(
      padding: const EdgeInsets.symmetric(vertical: 20),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          PoppyIcon(icon: icon, size: 36),
          const SizedBox(height: 8),
          Text(label, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}
