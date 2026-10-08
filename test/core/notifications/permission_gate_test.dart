import 'package:faith_mobile/core/notifications/permission_gate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Counts prompts and returns a fixed outcome, standing in for the OS.
  ({PermissionGate gate, List<bool> Function() asks}) buildGate({
    required bool grants,
    GateStore? store,
  }) {
    final asks = <bool>[];
    final gate = PermissionGate(
      store: store ?? InMemoryGateStore(),
      ask: () async {
        asks.add(grants);
        return grants;
      },
    );
    return (gate: gate, asks: () => asks);
  }

  test('asks once after the first prayer log, never again', () async {
    final (:gate, :asks) = buildGate(grants: false);

    expect(await gate.maybeAskAfterFirstLog(), isTrue); // asked
    expect(await gate.maybeAskAfterFirstLog(), isFalse); // already asked
    expect(asks().length, 1);
  });

  test('a grant also closes the gate for good', () async {
    final (:gate, :asks) = buildGate(grants: true);

    expect(await gate.maybeAskAfterFirstLog(), isTrue);
    expect(await gate.maybeAskAfterFirstLog(), isFalse);
    expect(await gate.maybeAskAfterFirstLog(), isFalse);
    expect(asks().length, 1);
  });

  test('does not ask before any prayer has been logged', () async {
    final (gate: _, :asks) = buildGate(grants: true);

    // Constructing the gate, and anything else short of a logged prayer,
    // must not reach the OS: the whole point is that the prompt is never
    // cold. There is deliberately no launch-time trigger to exercise here.
    expect(asks(), isEmpty);
  });

  test('a denial closes the gate just as a grant does', () async {
    final (:gate, asks: _) = buildGate(grants: false);

    expect(await gate.wasAsked, isFalse);

    await gate.maybeAskAfterFirstLog();

    // Explicitly: a denial is final for the automatic path. Re-asking on a
    // later log would spend Android's second — and permanently
    // denying — prompt.
    expect(await gate.wasAsked, isTrue);
  });

  test('askNow asks even once the gate is closed, and closes it', () async {
    final (:gate, :asks) = buildGate(grants: true);

    await gate.maybeAskAfterFirstLog();
    expect(asks().length, 1);

    // Settings taps are explicit user consent to be prompted again.
    expect(await gate.askNow(), isTrue);
    expect(asks().length, 2);
  });

  test('a Settings ask stops the first log from prompting again', () async {
    final (:gate, :asks) = buildGate(grants: false);

    // Toggling a prayer reminder on in Settings asks before any prayer has
    // been logged. The log path must not then ask a second time.
    await gate.askNow();
    expect(await gate.maybeAskAfterFirstLog(), isFalse);
    expect(asks().length, 1);
  });

  test('an ask that throws leaves the gate open for the next log', () async {
    var calls = 0;
    final gate = PermissionGate(
      store: InMemoryGateStore(),
      ask: () async {
        calls++;
        if (calls == 1) throw StateError('channel not ready');
        return true;
      },
    );

    // Must not propagate: the caller is a successful prayer log.
    expect(await gate.maybeAskAfterFirstLog(), isFalse);
    expect(await gate.wasAsked, isFalse);

    expect(await gate.maybeAskAfterFirstLog(), isTrue);
    expect(calls, 2);
  });

  test('askNow survives a failing ask and stays open', () async {
    var calls = 0;
    final gate = PermissionGate(
      store: InMemoryGateStore(),
      ask: () async {
        calls++;
        if (calls == 1) throw StateError('channel not ready');
        return true;
      },
    );

    // Its callers are bare onTap/onChanged handlers — an async throw there
    // has nothing above it to catch.
    expect(await gate.askNow(), isFalse);
    expect(await gate.wasAsked, isFalse);

    expect(await gate.askNow(), isTrue);
    expect(await gate.wasAsked, isTrue);
  });

  test('two logs in the same tick raise only one prompt', () async {
    var calls = 0;
    final gate = PermissionGate(
      store: InMemoryGateStore(),
      ask: () async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return true;
      },
    );

    final results = await Future.wait([
      gate.maybeAskAfterFirstLog(),
      gate.maybeAskAfterFirstLog(),
    ]);

    expect(calls, 1);
    expect(results.where((asked) => asked).length, 1);
  });

  group('SharedPrefsGateStore', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('the closed gate survives a new gate instance', () async {
      const store = SharedPrefsGateStore();
      var calls = 0;
      PermissionGate build() => PermissionGate(
        store: store,
        ask: () async {
          calls++;
          return false;
        },
      );

      expect(await build().maybeAskAfterFirstLog(), isTrue);
      // A fresh process reaches the prayer-log path with a fresh gate; the
      // flag has to come off disk or every launch re-prompts.
      expect(await build().maybeAskAfterFirstLog(), isFalse);
      expect(calls, 1);
    });

    test('a pre-closed gate is never reopened', () async {
      SharedPreferences.setMockInitialValues({
        PermissionGate.hasAskedKey: true,
      });
      var calls = 0;
      final gate = PermissionGate(
        store: const SharedPrefsGateStore(),
        ask: () async {
          calls++;
          return true;
        },
      );

      expect(await gate.maybeAskAfterFirstLog(), isFalse);
      expect(calls, 0);
    });
  });
}
