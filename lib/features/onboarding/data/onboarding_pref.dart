import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_pref.g.dart';

/// Persists whether the user has completed the onboarding flow.
/// Resolved once at boot; flipped to `true` when the user hits "Get started"
/// at the end of the faith-selection screen. Subsequent launches skip
/// onboarding and go straight to login (or home if already authed).
@Riverpod(keepAlive: true)
class OnboardingDone extends _$OnboardingDone {
  static const _key = 'onboarding_done';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> markDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    state = const AsyncValue.data(true);
  }
}
