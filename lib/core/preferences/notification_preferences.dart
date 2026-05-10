import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

/// Whether the user wants a reminder for a given prayer, plus the lead time
/// (in minutes) for the early-warning notification.
///
/// Two notifications fire per enabled prayer when [leadMinutes] > 0:
/// one at `time - leadMinutes` and one at `time` itself. Set [leadMinutes]
/// to 0 to fire only the at-time reminder.
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @Default(true) bool fajr,
    @Default(true) bool dhuhr,
    @Default(true) bool asr,
    @Default(true) bool maghrib,
    @Default(true) bool isha,
    @Default(10) int leadMinutes,
  }) = _NotificationPreferences;

  const NotificationPreferences._();

  bool isEnabledFor(String key) => switch (key) {
    'fajr' => fajr,
    'dhuhr' => dhuhr,
    'asr' => asr,
    'maghrib' => maghrib,
    'isha' => isha,
    _ => false,
  };
}

const _kFajr = 'notif.fajr';
const _kDhuhr = 'notif.dhuhr';
const _kAsr = 'notif.asr';
const _kMaghrib = 'notif.maghrib';
const _kIsha = 'notif.isha';
const _kLead = 'notif.leadMinutes';

/// Reads + persists the user's prayer-notification preferences.
@Riverpod(keepAlive: true)
class NotificationPrefs extends _$NotificationPrefs {
  @override
  Future<NotificationPreferences> build() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationPreferences(
      fajr: prefs.getBool(_kFajr) ?? true,
      dhuhr: prefs.getBool(_kDhuhr) ?? true,
      asr: prefs.getBool(_kAsr) ?? true,
      maghrib: prefs.getBool(_kMaghrib) ?? true,
      isha: prefs.getBool(_kIsha) ?? true,
      leadMinutes: prefs.getInt(_kLead) ?? 10,
    );
  }

  Future<void> setEnabled(String key, bool value) async {
    final current = state.valueOrNull ?? const NotificationPreferences();
    final next = switch (key) {
      'fajr' => current.copyWith(fajr: value),
      'dhuhr' => current.copyWith(dhuhr: value),
      'asr' => current.copyWith(asr: value),
      'maghrib' => current.copyWith(maghrib: value),
      'isha' => current.copyWith(isha: value),
      _ => current,
    };
    state = AsyncValue.data(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(key), value);
  }

  Future<void> setLeadMinutes(int minutes) async {
    final current = state.valueOrNull ?? const NotificationPreferences();
    state = AsyncValue.data(current.copyWith(leadMinutes: minutes));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kLead, minutes);
  }

  String _keyFor(String key) => switch (key) {
    'fajr' => _kFajr,
    'dhuhr' => _kDhuhr,
    'asr' => _kAsr,
    'maghrib' => _kMaghrib,
    'isha' => _kIsha,
    _ => 'notif.unknown',
  };
}
