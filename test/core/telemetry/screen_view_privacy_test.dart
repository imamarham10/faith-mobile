/// The end-to-end half of the privacy guarantee.
///
/// `forbidden_data_test.dart` proves the analytics *vocabulary* cannot
/// express an emotion. This proves the thing a real user does — opening
/// the mood picker and tapping "Grieving", which pushes
/// `/reflect/feelings/grieving` — emits a screen name that is not the slug
/// and carries nothing else from the path.
///
/// It drives a genuine `GoRouter` through a genuine [TelemetryScope], with
/// only the sink faked, so what it asserts is what the device would have
/// sent.
library;

import 'package:faith_mobile/core/telemetry/siraat_analytics.dart';
import 'package:faith_mobile/core/telemetry/telemetry.dart';
import 'package:faith_mobile/core/telemetry/telemetry_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/recording_analytics_sink.dart';

/// A router shaped like the real one at the two points that matter: the
/// emotion slug in a path parameter, and a verse reference in another.
GoRouter _router() => GoRouter(
  initialLocation: '/today',
  routes: [
    GoRoute(path: '/today', builder: (_, __) => const Text('today')),
    // Stands in for a route added later that nobody remembered to name in
    // `screenForLocation`. Its path segment is deliberately something that
    // must never be sent.
    GoRoute(
      path: '/unmapped/:secret',
      builder: (_, __) => const Text('unmapped'),
    ),
    GoRoute(
      path: '/reflect',
      builder: (_, __) => const Text('reflect'),
      routes: [
        GoRoute(
          path: 'feelings/:mood',
          builder: (_, state) => Text('mood ${state.pathParameters['mood']}'),
        ),
        GoRoute(path: 'journal', builder: (_, __) => const Text('journal')),
      ],
    ),
    GoRoute(
      path: '/quran',
      builder: (_, __) => const Text('quran'),
      routes: [
        GoRoute(path: 'surah/:id', builder: (_, __) => const Text('surah')),
      ],
    ),
  ],
);

Future<GoRouter> _pump(WidgetTester tester, RecordingAnalyticsSink sink) async {
  final router = _router();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [analyticsProvider.overrideWithValue(SiraatAnalytics(sink))],
      child: TelemetryScope(
        router: router,
        child: MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  late RecordingAnalyticsSink sink;

  setUp(() => sink = RecordingAnalyticsSink());

  testWidgets('navigating into an emotion sends the screen, not the slug', (
    tester,
  ) async {
    final router = await _pump(tester, sink);

    router.go('/reflect/feelings/grieving');
    await tester.pumpAndSettle();

    // The screen the user is actually on, confirming the route really
    // matched and the slug really was in the path.
    expect(find.text('mood grieving'), findsOneWidget);

    final screens = sink.emissions
        .where((e) => e.name == 'screen_view')
        .map((e) => e.params['screen_name'])
        .toList();
    expect(screens, ['today', 'feelings_result']);

    expect(
      sink.wireStrings.where((s) => s.contains('grieving')),
      isEmpty,
      reason:
          'the emotion the user selected reached the analytics layer. This '
          'is the exact failure FirebaseAnalyticsObserver and Firebase\'s '
          'automatic screen reporting would produce, and the reason both '
          'are turned off.',
    );
  });

  testWidgets('two different emotions are indistinguishable downstream', (
    tester,
  ) async {
    final router = await _pump(tester, sink);

    router.go('/reflect/feelings/depressed');
    await tester.pumpAndSettle();
    final afterFirst = sink.emissions.map((e) => e.toString()).toList();

    sink.clear();
    router.go('/reflect');
    await tester.pumpAndSettle();
    router.go('/reflect/feelings/grateful');
    await tester.pumpAndSettle();
    final afterSecond = sink.emissions
        .where((e) => e.params['screen_name'] == 'feelings_result')
        .map((e) => e.toString())
        .toList();

    expect(
      afterSecond,
      [afterFirst.last],
      reason:
          'the two emissions differ, so the emotion is recoverable from the '
          'analytics stream even though the slug itself was never sent',
    );
  });

  testWidgets('a verse reference in a path does not reach the wire', (
    tester,
  ) async {
    // Not forbidden data — the activity stream already records which verses
    // are read on our own server — but it is redundant there, and a screen
    // name that varied per surah would be a second, unreviewed copy of a
    // reading history.
    final router = await _pump(tester, sink);

    router.go('/quran/surah/2?ayah=255');
    await tester.pumpAndSettle();

    final screens = sink.emissions
        .where((e) => e.name == 'screen_view')
        .map((e) => e.params['screen_name']);
    expect(screens, contains('scripture_reader'));
    expect(sink.wireStrings.where((s) => s.contains('255')), isEmpty);
    expect(sink.wireStrings.where((s) => s.contains('/quran')), isEmpty);
  });

  testWidgets('an unmapped route emits nothing at all', (tester) async {
    final router = await _pump(tester, sink);
    sink.clear();

    // The safe default, and the property that keeps this layer honest as
    // the app grows: a route nobody has named in `screenForLocation` is
    // silent rather than leaking whatever its path happens to carry.
    router.go('/unmapped/grieving');
    await tester.pumpAndSettle();

    expect(find.text('unmapped'), findsOneWidget);
    expect(sink.emissions, isEmpty);
  });

  testWidgets('a mapped route still reports, so silence means unmapped', (
    tester,
  ) async {
    // The other direction, so the test above cannot pass by the scope
    // simply being broken.
    final router = await _pump(tester, sink);
    sink.clear();

    router.go('/reflect/journal');
    await tester.pumpAndSettle();
    expect(sink.emissions.single.params['screen_name'], 'journal');
  });
}
