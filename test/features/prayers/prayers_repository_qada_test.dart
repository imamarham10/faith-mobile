import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/features/prayers/data/prayers_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records every request Dio issues and answers each with a canned body.
///
/// The point of these tests is *which URL was called*, not what came back —
/// a test that only checked the parsed [PrayerStats] would pass just as
/// happily against the old `POST /log` implementation.
class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter(this.body, {this.statusCode = 201});

  final Map<String, dynamic> body;
  final int statusCode;
  final List<RequestOptions> requests = <RequestOptions>[];

  List<String> get paths => requests.map((r) => r.path).toList();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

PrayersRepository _repoWith(_RecordingAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
    ..httpClientAdapter = adapter;
  return PrayersRepository(dio);
}

void main() {
  const qadaResponse = <String, dynamic>{
    'total': 3,
    'totalQaza': 3,
    'byPrayer': {'fajr': 3, 'dhuhr': 0, 'asr': 0, 'maghrib': 0, 'isha': 0},
  };

  group('PrayersRepository.incrementQada', () {
    test('posts to /qada/increment and never touches the daily log', () async {
      final adapter = _RecordingAdapter(qadaResponse);

      await _repoWith(adapter).incrementQada(prayerName: 'fajr');

      // The whole bug in one assertion: `POST /log` upserts on
      // (userId, prayerName, date), so a qaza increment that went there
      // would overwrite today's `on_time` row for the same prayer.
      expect(
        adapter.paths,
        isNot(contains('/api/v1/islam/prayers/log')),
        reason: 'a qaza increment must never write a prayer-log row',
      );
      expect(adapter.paths, ['/api/v1/islam/prayers/qada/increment']);
      expect(adapter.requests.single.method, 'POST');
    });

    test('sends prayerName and a positive by, and no date field', () async {
      final adapter = _RecordingAdapter(qadaResponse);

      await _repoWith(adapter).incrementQada(prayerName: 'maghrib', by: 4);

      final sent = adapter.requests.single.data as Map<String, dynamic>;
      expect(sent['prayerName'], 'maghrib');
      // The server negates `by` itself on the decrement route, so a negative
      // value posted to /increment would silently decrement.
      expect(sent['by'], 4);
      expect(sent.containsKey('date'), isFalse);
      expect(sent.containsKey('status'), isFalse);
    });

    test(
      'adopts the tally the server returns, with no follow-up read',
      () async {
        final adapter = _RecordingAdapter(qadaResponse);

        final stats = await _repoWith(
          adapter,
        ).incrementQada(prayerName: 'fajr');

        expect(stats.totalQaza, 3);
        expect(stats.fajrQaza, 3);
        expect(stats.dhuhrQaza, 0);
        // One request total — no GET /stats round-trip behind it.
        expect(adapter.requests, hasLength(1));
      },
    );

    test('rejects an out-of-range by before any request is made', () async {
      final adapter = _RecordingAdapter(qadaResponse);
      final repo = _repoWith(adapter);

      await expectLater(
        repo.incrementQada(prayerName: 'fajr', by: 0),
        throwsA(isA<ApiException>()),
      );
      await expectLater(
        repo.incrementQada(prayerName: 'fajr', by: 101),
        throwsA(isA<ApiException>()),
      );
      expect(adapter.requests, isEmpty);
    });

    test('surfaces a server failure as an ApiException', () async {
      final adapter = _RecordingAdapter({
        'statusCode': 400,
        'message': 'prayerName must be one of...',
      }, statusCode: 400);

      await expectLater(
        _repoWith(adapter).incrementQada(prayerName: 'not_a_prayer'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
    });
  });

  group('PrayersRepository.decrementQada', () {
    test('posts to /qada/decrement and never touches the daily log', () async {
      final adapter = _RecordingAdapter(qadaResponse);

      await _repoWith(adapter).decrementQada(prayerName: 'fajr');

      expect(
        adapter.paths,
        isNot(contains('/api/v1/islam/prayers/log')),
        reason: 'a qaza decrement must never write a prayer-log row',
      );
      expect(adapter.paths, ['/api/v1/islam/prayers/qada/decrement']);
      expect(adapter.requests.single.method, 'POST');
    });

    test('sends a POSITIVE by — the route carries the direction', () async {
      final adapter = _RecordingAdapter(qadaResponse);

      await _repoWith(adapter).decrementQada(prayerName: 'asr', by: 2);

      final sent = adapter.requests.single.data as Map<String, dynamic>;
      expect(sent['prayerName'], 'asr');
      // The server computes `-(body.by ?? 1)` on this route. Sending -2 here
      // would therefore *add* two qaza — the exact inversion this asserts
      // against.
      expect(sent['by'], 2);
      expect(sent['by'], isPositive);
    });

    test('rejects a negative or zero by before any request', () async {
      final adapter = _RecordingAdapter(qadaResponse);
      final repo = _repoWith(adapter);

      await expectLater(
        repo.decrementQada(prayerName: 'fajr', by: -1),
        throwsA(isA<ApiException>()),
      );
      await expectLater(
        repo.decrementQada(prayerName: 'fajr', by: 0),
        throwsA(isA<ApiException>()),
      );
      await expectLater(
        repo.decrementQada(prayerName: 'fajr', by: 101),
        throwsA(isA<ApiException>()),
      );
      expect(adapter.requests, isEmpty);
    });

    test('adopts the clamped tally the server returns', () async {
      // The server clamps at zero (`Math.max(0, count + by)`), so a
      // decrement past zero is a 200 with the floor, not an error. The
      // client must take the server's number, not predict its own.
      final adapter = _RecordingAdapter(const <String, dynamic>{
        'total': 0,
        'totalQaza': 0,
        'byPrayer': {'fajr': 0, 'dhuhr': 0, 'asr': 0, 'maghrib': 0, 'isha': 0},
      });

      final stats = await _repoWith(adapter).decrementQada(prayerName: 'fajr');

      expect(stats.fajrQaza, 0);
      expect(stats.totalQaza, 0);
      expect(adapter.requests, hasLength(1));
    });

    test('surfaces a server failure as an ApiException', () async {
      final adapter = _RecordingAdapter({
        'statusCode': 400,
        'message': 'prayerName must be one of...',
      }, statusCode: 400);

      await expectLater(
        _repoWith(adapter).decrementQada(prayerName: 'not_a_prayer'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
    });
  });
}
