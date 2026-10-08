import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

part 'permission_gate.g.dart';

/// Asks the OS for notification permission; resolves to whether it was
/// granted. Injected so tests never touch a platform channel.
typedef AskPermission = Future<bool> Function();

/// Persistence seam for the gate's flag.
abstract class GateStore {
  Future<bool?> readBool(String key);
  Future<void> writeBool(String key, bool value);
}

/// Production store. Reads `SharedPreferences` on every call rather than
/// caching: the gate resolves at most twice in a process lifetime.
class SharedPrefsGateStore implements GateStore {
  const SharedPrefsGateStore();

  @override
  Future<bool?> readBool(String key) async =>
      (await SharedPreferences.getInstance()).getBool(key);

  @override
  Future<void> writeBool(String key, bool value) async =>
      (await SharedPreferences.getInstance()).setBool(key, value);
}

/// Test store. Also serves as a null object where persistence is irrelevant.
class InMemoryGateStore implements GateStore {
  InMemoryGateStore([Map<String, bool>? initial]) : _values = {...?initial};

  final Map<String, bool> _values;

  @override
  Future<bool?> readBool(String key) async => _values[key];

  @override
  Future<void> writeBool(String key, bool value) async => _values[key] = value;
}

/// Decides *when* the app asks for notification permission.
///
/// The app schedules a rolling window of prayer alarms from first launch,
/// but on Android 13+ and on iOS none of them can display anything until
/// the user grants permission — so the default experience was silence:
/// sixty alarms registered with the OS and not one able to surface.
///
/// The ask is deliberately **not** made on first launch. A cold prompt
/// before the user understands the app is the most common route to a
/// permanent denial, and a denial cannot be re-prompted without a trip to
/// system settings. [maybeAskAfterFirstLog] instead fires straight after
/// the first prayer is logged, where the user has just demonstrated intent
/// and the ask explains itself.
///
/// **Denial policy: the automatic ask happens exactly once, ever.** Granted
/// or denied, [maybeAskAfterFirstLog] never prompts a second time. Two
/// consequences, both deliberate:
///
///   * A denial is final as far as the automatic path is concerned.
///     Re-asking on a later log would spend the user's one remaining
///     prompt — Android treats the second denial as permanent — at a
///     moment no more persuasive than the first.
///   * Because of that, Android's permanently-denied state is unreachable
///     through the automatic path. It can only be reached by the user
///     deliberately tapping something in Settings, and those taps go
///     through [askNow], which the user asked for.
///
/// The gate stores whether it has asked and nothing else. It deliberately
/// does *not* cache the grant result: the OS owns that, the user can flip
/// it in system settings at any time, and a stale cached `false` is worse
/// than no answer.
class PermissionGate {
  PermissionGate({required GateStore store, required AskPermission ask})
    : _store = store,
      _ask = ask;

  /// Written once the OS prompt has actually resolved — never before, so a
  /// process death mid-prompt leaves the gate armed for the next log.
  static const String hasAskedKey = 'notif.permission.asked';

  final GateStore _store;
  final AskPermission _ask;

  /// Held while a prompt is open. Logging two prayers in quick succession
  /// otherwise races two prompts through the `hasAsked` check.
  Future<bool>? _inFlight;

  /// Call on the prayer-log success path. Returns whether this call put the
  /// OS prompt on screen — not whether permission was granted.
  ///
  /// Never throws: a failure to ask must not be able to turn a successful
  /// prayer log into an error at the call site.
  Future<bool> maybeAskAfterFirstLog() {
    final running = _inFlight;
    if (running != null) return running.then((_) => false);
    final next = _askOnce().whenComplete(() => _inFlight = null);
    _inFlight = next;
    return next;
  }

  /// Asks regardless of whether the gate has already fired, and closes it.
  /// Returns whether permission was granted.
  ///
  /// For the Settings controls only: a user who taps "Send test
  /// notification" or switches a prayer reminder on has asked for the
  /// prompt, and closing the gate here stops the first prayer log from
  /// spending a second prompt on a question Settings just asked.
  ///
  /// Never throws, for the same reason [maybeAskAfterFirstLog] doesn't: its
  /// callers are `onChanged` and `onTap` handlers with nothing above them
  /// to catch an async failure. A failed ask reports "not granted" and
  /// leaves the gate open rather than closing it on a prompt that never
  /// appeared.
  Future<bool> askNow() async {
    try {
      final granted = await _ask();
      await _store.writeBool(hasAskedKey, true);
      return granted;
    } on Object catch (e, st) {
      developer.log(
        'notification permission ask failed',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  /// Whether the one automatic prompt has already been shown.
  Future<bool> get wasAsked async =>
      await _store.readBool(hasAskedKey) ?? false;

  Future<bool> _askOnce() async {
    try {
      if (await wasAsked) return false;
      final granted = await _ask();
      await _store.writeBool(hasAskedKey, true);
      developer.log(
        'notification permission asked after first prayer log: '
        'granted=$granted',
        name: 'notifications',
      );
      return true;
    } on Object catch (e, st) {
      // The ask never completed, so the gate stays open rather than
      // silently burning the one prompt the user has.
      developer.log(
        'notification permission ask failed',
        name: 'notifications',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
PermissionGate permissionGate(Ref ref) => PermissionGate(
  store: const SharedPrefsGateStore(),
  ask: NotificationService.instance.requestPermissions,
);
