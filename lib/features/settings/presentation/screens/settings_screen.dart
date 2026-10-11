import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/notifications/permission_gate.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/session/end_session.dart';
import '../../../../core/storage/local_data_purge.dart';
import '../../../../core/preferences/arabic_script.dart';
import '../../../../core/preferences/notification_preferences.dart';
import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/preferences/theme_mode.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/telemetry/telemetry.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/arabic_text.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../prayers/presentation/controllers/prayer_times_controller.dart';

/// Where the published legal pages live. Both are served by the web app
/// (`faith-web-remix`), which is the URL the Play listing points at, so the
/// app and the store declaration can never disagree.
const String _privacyUrl = '$kWebBaseUrl/privacy';
const String _termsUrl = '$kWebBaseUrl/terms';

/// `/settings` — preferences for the app. Sections, top to bottom: theme
/// (faith-neutral, always shown), then — only when the selected faith is
/// Islam — prayer calculation method, prayer notifications, and Arabic
/// script, none of which apply to the Hindu vertical (no prayer times, no
/// Arabic script rendering). Faith and sign-out are always shown last.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
    final themeMode =
        ref.watch(themeModePrefProvider).valueOrNull ?? ThemeMode.system;
    final calcCode =
        ref.watch(calcMethodPrefProvider).valueOrNull ??
        CalcMethod.fallbackCode;
    final notifPrefs =
        ref.watch(notificationPrefsProvider).valueOrNull ??
        const NotificationPreferences();
    final script =
        ref.watch(arabicScriptControllerProvider).valueOrNull ??
        ArabicScript.indoPak;
    // Defaults to on while the preference is still being read. The switch
    // reflects the stored choice, not whether anything is being sent right
    // now — in a debug build nothing is, and a toggle that showed "off"
    // for that reason would be lying about the setting.
    final diagnosticsOn =
        ref.watch(telemetryEnabledProvider).valueOrNull ?? true;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            _SectionHeader(label: 'Appearance'),
            for (final m in ThemeMode.values)
              RadioListTile<ThemeMode>(
                value: m,
                groupValue: themeMode,
                title: Text(_themeLabel(m)),
                onChanged: (v) {
                  if (v == null) return;
                  HapticFeedback.selectionClick();
                  ref.read(themeModePrefProvider.notifier).set(v);
                },
              ),

            if (faith == FaithId.islam) ...[
              _SectionHeader(label: 'Prayer notifications'),
              const _ExactAlarmTile(),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Send test notification'),
                // Deliberately vague about timing: with exact alarms denied
                // the test is posted immediately rather than scheduled, so a
                // promised "~5s" would be wrong half the time. The snackbar
                // says which happened, once it knows.
                subtitle: const Text('Asks permission if needed, then sends'),
                onTap: () => _sendTest(context, ref),
              ),
              ListTile(
                title: const Text('Lead time'),
                subtitle: Text(
                  notifPrefs.leadMinutes == 0
                      ? 'Notify only at prayer time'
                      : 'Notify ${notifPrefs.leadMinutes} min before each prayer',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _pickLeadMinutes(context, ref, notifPrefs.leadMinutes),
              ),
              for (final p in const [
                ('fajr', 'Fajr'),
                ('dhuhr', 'Dhuhr'),
                ('asr', 'ʿAṣr'),
                ('maghrib', 'Maghrib'),
                ('isha', 'ʿIshā'),
              ])
                SwitchListTile.adaptive(
                  title: Text(p.$2),
                  value: notifPrefs.isEnabledFor(p.$1),
                  onChanged: (v) async {
                    HapticFeedback.selectionClick();
                    await ref
                        .read(notificationPrefsProvider.notifier)
                        .setEnabled(p.$1, v);
                    if (v) {
                      // First toggle-on triggers the OS permission ask.
                      // Through the gate, so the first prayer log doesn't
                      // then spend a second prompt on the same question.
                      await ref.read(permissionGateProvider).askNow();
                    }
                  },
                ),

              _SectionHeader(label: 'Prayer calculation method'),
              for (final m in CalcMethod.all)
                RadioListTile<String>(
                  value: m.code,
                  groupValue: calcCode,
                  title: Text(m.label),
                  onChanged: (v) {
                    if (v == null) return;
                    HapticFeedback.selectionClick();
                    ref.read(calcMethodPrefProvider.notifier).set(v);
                  },
                ),

              _SectionHeader(label: 'Arabic script'),
              for (final s in ArabicScript.values)
                RadioListTile<ArabicScript>(
                  value: s,
                  groupValue: script,
                  onChanged: (v) {
                    if (v == null) return;
                    HapticFeedback.selectionClick();
                    ref.read(arabicScriptControllerProvider.notifier).set(v);
                  },
                  title: Text(s.label),
                  subtitle: Text(s.subtitle),
                  // Each row previews its own script's text, not one
                  // shared string in three fonts: the preference picks an
                  // orthography, and only different text can show that.
                  secondary: SizedBox(
                    width: 64,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        s.sample,
                        textAlign: TextAlign.right,
                        style: arabicTextStyle(
                          s,
                          fontSize: 18,
                          height: 1.0,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(label: 'Faith'),
            ListTile(
              leading: const Icon(Icons.diversity_3_outlined),
              title: const Text('Switch faith'),
              subtitle: const Text('Change which tradition the app follows'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.lightImpact();
                context.push(Routes.switchFaith);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: cs.error),
              title: Text(
                'Sign out',
                style: theme.textTheme.bodyLarge?.copyWith(color: cs.error),
              ),
              onTap: () => _confirmSignOut(context, ref),
            ),

            // `const`, unlike its neighbours: the existing section
            // headers predate the lint and are left as they are rather
            // than swept into this change.
            const _SectionHeader(label: 'Privacy'),
            SwitchListTile.adaptive(
              value: diagnosticsOn,
              secondary: const Icon(Icons.bug_report_outlined),
              title: const Text('Share crash reports'),
              // Says exactly what is sent and, more importantly, what is
              // not. The two sentences are the user-facing half of the
              // rule the code enforces: Siraat already records prayers,
              // verses and reflections on its own account system, and
              // none of that is duplicated to anyone else.
              subtitle: const Text(
                'Sends crashes and anonymous usage counts so we can fix '
                'what breaks. Never your reflections, your moods, or which '
                'faith you follow.',
              ),
              onChanged: (v) {
                HapticFeedback.mediumImpact();
                ref.read(telemetryEnabledProvider.notifier).set(v);
              },
            ),

            _SectionHeader(label: 'About'),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy policy'),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _openLegal(context, _privacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of service'),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _openLegal(context, _termsUrl),
            ),

            _SectionHeader(label: 'Account'),
            ListTile(
              leading: Icon(Icons.delete_forever_outlined, color: cs.error),
              title: Text(
                'Delete account',
                style: theme.textTheme.bodyLarge?.copyWith(color: cs.error),
              ),
              subtitle: const Text(
                'Permanently erase your account and all your data',
              ),
              trailing: Icon(Icons.chevron_right, color: cs.error),
              onTap: () {
                HapticFeedback.lightImpact();
                context.push(Routes.deleteAccount);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// Opens one of the legal pages in the browser.
  ///
  /// Hosted on the web app rather than rendered in-app: Play's policy
  /// requires the privacy policy to be reachable from a public URL it can
  /// itself verify, and a page the app draws from a bundled string would
  /// drift from the one the listing points at. [LaunchMode
  /// .externalApplication] rather than an in-app webview, so a user who
  /// wants to keep it, print it or read it later has a real browser tab —
  /// matching how `temple_detail_screen` hands off to Maps.
  Future<void> _openLegal(BuildContext context, String url) async {
    HapticFeedback.lightImpact();
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Couldn\'t open $url'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final ok = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: const Text('Sign out?'),
        // Says which half comes back and which does not. Bookmarks,
        // favourites, prayer logs and dhikr counters all live on the
        // account and are re-fetched on the next sign-in. The reflection
        // journal and mood history never reach the server — there is no
        // journal endpoint — so clearing them off this device, which is
        // what sign-out now does, is permanent. A user is owed that
        // sentence before they tap, not after.
        content: const Text(
          'Your bookmarks, prayer logs and dhikr counters stay on your '
          'account and come back when you sign in.\n\nReflections and mood '
          'history are saved only on this device, and signing out removes '
          'them from it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await HapticFeedback.mediumImpact();
    // Everything this has to do — cancelling the alarms scheduled against
    // this user, erasing the journal, bookmarks and unflushed activity the
    // device holds, dropping the in-memory copies of all of it, and only
    // then clearing the tokens — is `endSession`, which account deletion
    // runs too. This used to cancel the alarms and sign out and nothing
    // else, which left the next person to sign in on this handset looking
    // at the previous user's journal.
    await endSession(
      notifications: ref.read(prayerNotificationSinkProvider),
      purge: ref.read(localDataPurgeProvider),
      auth: ref.read(authControllerProvider.notifier),
    );
    // Router redirect picks up the auth-state change and routes to /login.
  }

  Future<void> _pickLeadMinutes(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    HapticFeedback.lightImpact();
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (sheet) {
        final theme = Theme.of(sheet);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lead time', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                for (final m in const [0, 5, 10, 15, 20, 30])
                  RadioListTile<int>(
                    value: m,
                    groupValue: current,
                    title: Text(m == 0 ? 'No early reminder' : '$m min before'),
                    onChanged: (v) {
                      if (v == null) return;
                      Navigator.of(sheet).pop(v);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (picked == null) return;
    await ref.read(notificationPrefsProvider.notifier).setLeadMinutes(picked);
  }

  static String _themeLabel(ThemeMode m) => switch (m) {
    ThemeMode.system => 'Match system',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  Future<void> _sendTest(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final granted = await ref.read(permissionGateProvider).askNow();
    if (!context.mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission denied. Enable in system settings.',
          ),
        ),
      );
      return;
    }
    try {
      final outcome = await NotificationService.instance.sendTest();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            switch (outcome) {
              TestNotificationOutcome.scheduled =>
                'Test notification scheduled (~5s)',
              // Saying "~5s" here would be a lie: without exact-alarm
              // permission the test is posted now, and the real reminders
              // it is standing in for arrive inside Android's batching
              // window rather than on the minute.
              TestNotificationOutcome.shownImmediately =>
                'Test notification sent. Exact alarms are off, so real '
                    'reminders may arrive a few minutes late.',
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Couldn\'t schedule: $e'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }
}

/// Shown only when Android is refusing exact alarms.
///
/// The app dropped `USE_EXACT_ALARM` (Play restricts it to alarm-clock and
/// calendar apps), so on Android 14+ a fresh install has
/// `SCHEDULE_EXACT_ALARM` denied by default. Reminders still arrive —
/// `ExactAlarmPolicy` falls back to inexact delivery — but inside Android's
/// batching window rather than on the minute, which for Fajr is worth
/// telling the user about and worth offering a one-tap fix.
///
/// Renders nothing in the healthy case: a permanent "everything is fine"
/// row in Settings is noise, and renders nothing while loading so the list
/// does not jump.
class _ExactAlarmTile extends ConsumerStatefulWidget {
  const _ExactAlarmTile();

  @override
  ConsumerState<_ExactAlarmTile> createState() => _ExactAlarmTileState();
}

class _ExactAlarmTileState extends ConsumerState<_ExactAlarmTile>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// `openExactAlarmSettings` returns the moment the intent launches, not
  /// when the user comes back — so re-reading there would re-read "denied"
  /// while they are still standing in system settings, and nothing would
  /// ever read again. Resume is the only moment that knows the answer: the
  /// user has toggled (or not) and returned.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(exactAlarmsAllowedProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Defaults to allowed so the warning never flashes while the first read
    // is in flight.
    final allowed = ref.watch(exactAlarmsAllowedProvider).valueOrNull ?? true;
    if (allowed) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(Icons.alarm_outlined, color: cs.tertiary),
      title: const Text('Reminders may arrive a few minutes late'),
      subtitle: const Text(
        'Android is batching this app’s alarms to save battery. Allow exact '
        'alarms to be reminded on the minute.',
      ),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () async {
        HapticFeedback.lightImpact();
        await NotificationService.instance.openExactAlarmSettings();
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.sm,
      ),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
