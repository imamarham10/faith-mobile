import 'package:faith_mobile/core/telemetry/analytics_sink.dart';
import 'package:faith_mobile/core/telemetry/telemetry_vocabulary.dart';

/// One thing the app tried to send to Google.
class RecordedEmission {
  const RecordedEmission({required this.name, required this.params});

  /// The event name exactly as it would go on the wire.
  final String name;

  /// The encoded parameters, exactly as they would go on the wire — run
  /// through [encodeAnalyticsParams], so this is what Google would
  /// actually receive and not what the caller intended to send.
  final Map<String, Object> params;

  /// Every string this emission would put on the wire: the event name, the
  /// parameter names, and the parameter values that are strings.
  Iterable<String> get wireStrings => <String>[
    name,
    ...params.keys,
    ...params.values.whereType<String>(),
  ];

  @override
  String toString() => '$name$params';
}

/// An [AnalyticsSink] that records instead of sending.
///
/// It deliberately runs the real [encodeAnalyticsParams], so a test
/// asserting over [emissions] is asserting over the bytes Firebase would
/// have seen — not over the typed arguments on the near side of the
/// encoder, which is where a leak would be invisible.
class RecordingAnalyticsSink implements AnalyticsSink {
  final List<RecordedEmission> emissions = <RecordedEmission>[];

  /// Every string the recorded emissions would put on the wire.
  Iterable<String> get wireStrings => emissions.expand((e) => e.wireStrings);

  void clear() => emissions.clear();

  @override
  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<AnalyticsParam, Object> params = const {},
  ]) async {
    emissions.add(
      RecordedEmission(name: event.wire, params: encodeAnalyticsParams(params)),
    );
  }

  @override
  Future<void> logScreen(AnalyticsScreen screen) async {
    emissions.add(
      RecordedEmission(
        name: 'screen_view',
        params: {'screen_name': screen.wire},
      ),
    );
  }
}
