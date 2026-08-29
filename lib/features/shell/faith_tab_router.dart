import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/preferences/selected_faith.dart';
import '../../core/theme/faith_id.dart';

/// Picks between an Islam and a Hindu screen for a shared nav slot, based
/// on the active faith. Used for the branch-2 (Scripture/Quran) and
/// branch-3 (Stories/Hadiths) landing routes once Hindu routes exist.
///
/// Scope note: [islam]/[hindu] are plain [WidgetBuilder]s (`Widget
/// Function(BuildContext)`), so they can only host parameter-less landing
/// screens — unlike `GoRoute.builder`, a `WidgetBuilder` can't carry
/// `GoRouterState`. If a future caller needs to thread route params (e.g. a
/// chapter/surah number) through this router, the signature will need to
/// change first.
class FaithTabRouter extends ConsumerWidget {
  const FaithTabRouter({super.key, required this.islam, required this.hindu});

  final WidgetBuilder islam;
  final WidgetBuilder hindu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    return switch (faith) {
      FaithId.islam => islam(context),
      FaithId.hindu => hindu(context),
    };
  }
}
