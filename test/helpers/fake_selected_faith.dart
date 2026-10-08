import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fakes [SelectedFaith] to resolve synchronously to a fixed faith, so
/// faith-branching widgets (`TodayScreen`, `AppShell`, ...) render
/// deterministically in widget tests without touching shared_preferences.
class FakeSelectedFaith extends SelectedFaith {
  FakeSelectedFaith(this._faith);

  final FaithId _faith;

  @override
  Future<FaithId?> build() async => _faith;
}

/// Like [FakeSelectedFaith], but the faith can be changed mid-test to
/// simulate Settings → "Switch faith". [set] skips the SharedPreferences
/// write and only moves provider state, which is all faith-reactive widgets
/// observe.
class MutableFakeSelectedFaith extends SelectedFaith {
  MutableFakeSelectedFaith(this._initial);

  final FaithId _initial;

  @override
  Future<FaithId?> build() async => _initial;

  @override
  Future<void> set(FaithId faith) async {
    state = AsyncValue.data(faith);
  }
}
