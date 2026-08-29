import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/faith_id.dart';

part 'selected_faith.g.dart';

/// Persisted faith selection. `null` means the user hasn't picked yet
/// (first launch, mid-onboarding). Set from the faith picker screen and
/// from Settings → "Switch faith".
@Riverpod(keepAlive: true)
class SelectedFaith extends _$SelectedFaith {
  static const _key = 'selected_faith';

  @override
  Future<FaithId?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return FaithId.fromName(prefs.getString(_key));
  }

  Future<void> set(FaithId faith) async {
    state = AsyncValue.data(faith);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, faith.name);
  }
}
