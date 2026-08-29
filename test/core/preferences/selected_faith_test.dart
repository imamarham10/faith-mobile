import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to null (no faith chosen yet)', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final result = await container.read(selectedFaithProvider.future);
    expect(result, isNull);
  });

  test('set() persists and is readable after rebuild', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(selectedFaithProvider.future);
    await container.read(selectedFaithProvider.notifier).set(FaithId.hindu);
    expect(container.read(selectedFaithProvider).valueOrNull, FaithId.hindu);

    // Fresh container simulates app relaunch — must read from persisted prefs.
    final relaunch = ProviderContainer();
    addTearDown(relaunch.dispose);
    final reloaded = await relaunch.read(selectedFaithProvider.future);
    expect(reloaded, FaithId.hindu);
  });
}
