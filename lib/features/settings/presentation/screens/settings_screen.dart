import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/notifications/permission_gate.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/preferences/arabic_script.dart';
import '../../../../core/preferences/notification_preferences.dart';
import '../../../../core/preferences/selected_faith.dart';
import '../../../../core/preferences/theme_mode.dart';
import '../../../../core/router/routes.dart';
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
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Send test notification'),
                subtitle: const Text(
                  'Asks permission if needed, then fires in ~5s',
                ),
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
                  secondary: SizedBox(
                    width: 48,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'بِسْمِ',
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
        content: const Text(
          'You\'ll need to sign in again to access your bookmarks, '
          'prayer logs, and dhikr counters.',
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
    // Cancel any scheduled prayer-time alarms — they reference user-specific
    // state and shouldn't fire after the user signs out.
    await NotificationService.instance.cancelAll();
    await ref.read(authControllerProvider.notifier).signOut();
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
      await NotificationService.instance.sendTest();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test notification scheduled (~5s)')),
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
