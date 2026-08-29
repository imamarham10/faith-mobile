import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';

/// Fakes [SelectedFaith] to resolve synchronously to a fixed faith, so
/// faith-branching widgets (`TodayScreen`, `AppShell`, ...) render
/// deterministically in widget tests without touching shared_preferences.
class FakeSelectedFaith extends SelectedFaith {
  FakeSelectedFaith(this._faith);

  final FaithId _faith;

  @override
  Future<FaithId?> build() async => _faith;
}
