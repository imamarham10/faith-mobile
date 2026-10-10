import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/poppy_button.dart';
import '../../../../shared/widgets/poppy_card.dart';
import '../controllers/delete_account_controller.dart';

/// `/settings/delete-account` — the in-app deletion path Google Play's
/// Account Deletion policy requires (and Apple Guideline 5.1.1(v)).
///
/// A full screen rather than a dialog, and a typed confirmation rather than
/// a second "are you sure": this erases prayer logs, journal entries,
/// bookmarks and streaks with no undo and no export, so the friction is the
/// feature. The confirmation word is matched case-insensitively after
/// trimming — the intent is to make the action deliberate, not to make it a
/// typing test.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  /// What the user has to type. Uppercase as displayed; compared loosely.
  static const String confirmWord = 'DELETE';

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Rebuilds on every keystroke so the button's enabled state tracks the
    // field. Cheap: this screen is a short, static column.
    _controller.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _confirmed =>
      _controller.text.trim().toUpperCase() == DeleteAccountScreen.confirmWord;

  Future<void> _delete() async {
    HapticFeedback.heavyImpact();
    _focus.unfocus();
    final ok = await ref
        .read(deleteAccountControllerProvider.notifier)
        .delete();
    if (!mounted) return;
    if (ok) {
      // The router's redirect sends an unauthenticated session to /login on
      // its own; this only unwinds the settings stack beneath it so there is
      // nothing stale to come back to.
      context.go('/login');
      return;
    }
    // Failure leaves the account and the session intact — the error is
    // rendered inline below the button rather than in a transient snackbar,
    // because the user needs it still on screen when they decide whether to
    // retry.
    HapticFeedback.heavyImpact();
  }

  /// What we can honestly say about the account after a failure.
  ///
  /// For everything except a 401 the server's own ordering guarantees the
  /// account survived — the user row goes last — so saying so is both true
  /// and the thing the user most wants to hear. A 401 is the one status we
  /// cannot read that way: it is returned both for a lapsed session and for
  /// a token whose account is already gone, so this neither reassures nor
  /// alarms, it just gives the next step.
  static String _reassurance(Object? error) {
    if (error is ApiException && error.statusCode == 401) {
      return 'Sign out and sign in again, then try once more.';
    }
    return 'Your account has not been deleted. You are still signed in.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final state = ref.watch(deleteAccountControllerProvider);
    final busy = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          // Nothing to cancel mid-flight — the request is already with the
          // server — so leaving is simply disabled until it settles.
          onPressed: busy ? null : () => context.pop(),
        ),
        title: const Text('Delete account'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.base,
            AppSpacing.screenEdge,
            AppSpacing.xxl,
          ),
          children: [
            Text(
              'This cannot be undone.',
              style: theme.textTheme.headlineSmall?.copyWith(color: cs.error),
            ),
            const Gap(AppSpacing.md),
            Text(
              'Deleting your account permanently removes it and everything '
              'in it from our servers and from this device.',
              style: theme.textTheme.bodyMedium,
            ),
            const Gap(AppSpacing.lg),
            // Decorative: it states facts and does nothing when touched, so
            // it stays flat and promises nothing.
            PoppyCard(
              radius: AppRadius.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in const [
                    'Your prayer and practice logs',
                    'Your streaks and daily goals',
                    'Your journal entries and mood history',
                    'Your bookmarks, favourites and reading progress',
                    'Your profile, preferences and sign-in',
                  ]) ...[_LostRow(text: line), const Gap(AppSpacing.sm)],
                ],
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Type ${DeleteAccountScreen.confirmWord} to confirm.',
              style: theme.textTheme.titleSmall,
            ),
            const Gap(AppSpacing.sm),
            TextField(
              controller: _controller,
              focusNode: _focus,
              enabled: !busy,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: DeleteAccountScreen.confirmWord,
              ),
              onSubmitted: (_) {
                if (_confirmed && !busy) _delete();
              },
            ),
            const Gap(AppSpacing.lg),
            PoppyButton(
              label: busy ? 'Deleting…' : 'Delete my account',
              variant: PoppyButtonVariant.destructive,
              onPressed: _confirmed && !busy ? _delete : null,
            ),
            if (state.hasError) ...[
              const Gap(AppSpacing.base),
              Text(
                '${state.error}\n\n${_reassurance(state.error)}',
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.error),
              ),
            ],
            const Gap(AppSpacing.md),
            Text(
              'Changed your mind? Go back — nothing has happened yet.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _LostRow extends StatelessWidget {
  const _LostRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.close_rounded, size: 16, color: theme.colorScheme.error),
        const Gap.h(AppSpacing.sm),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
