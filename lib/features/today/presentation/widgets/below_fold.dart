import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/below_fold_gate.dart';

/// Holds a below-the-fold card back until the habit loop has rendered.
///
/// The deferral works by simply not building [child]: a card's fetch starts
/// from the `ref.watch` in its own `build`, so a card that is never built
/// is a request that was never sent. Nothing about the card changes, and it
/// keeps all four of its own states once it does build.
///
/// [placeholder] should be the card's **own** loading skeleton. It is not a
/// different state being shown — it is the same silhouette the card would
/// draw a frame later, so the moment the gate opens there is nothing to
/// see: no flash, no reflow, no jump in scroll position. That is the whole
/// reason this takes a placeholder rather than rendering a gap.
///
/// Deliberately applied here at the Today screen rather than inside the
/// providers themselves. `dailyHadithProvider` also backs the Hadiths tab's
/// hero card, and gating the provider would have made a direct tap into
/// that tab wait on a habit loop the user never asked to see.
class BelowFold extends ConsumerWidget {
  const BelowFold({
    super.key,
    required this.placeholder,
    required this.child,
  });

  /// Drawn while the gate is closed. Match the card's loading state.
  final Widget placeholder;

  /// Built — and therefore fetched — only once the gate is open.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(belowFoldGateProvider) ? child : placeholder;
  }
}
