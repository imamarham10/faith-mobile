import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/selected_faith.dart';
import '../../core/theme/faith_id.dart';

/// Picks between an Islam and a Hindu screen for a shared nav slot, based
/// on the active faith. Used for the branch-2 (Scripture/Quran) and
/// branch-3 (Stories/Hadiths) landing routes once Hindu routes exist.
class FaithTabRouter extends ConsumerWidget {
  const FaithTabRouter({super.key, required this.islam, required this.hindu});

  final WidgetBuilder islam;
  final WidgetBuilder hindu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return faith == FaithId.hindu ? hindu(context) : islam(context);
  }
}
