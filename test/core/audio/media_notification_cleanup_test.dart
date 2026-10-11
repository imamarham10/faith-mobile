import 'package:faith_mobile/core/audio/media_notification_cleanup.dart';
import 'package:faith_mobile/core/audio/playback_audio_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

ActiveNotification _notification({int? id, String? channelId}) =>
    ActiveNotification(id: id, channelId: channelId);

/// A prayer reminder as `notificationId()` builds them:
/// `1000 + dayIndex * 100 + slot * 2 + lead`.
ActiveNotification _prayerReminder({required int id}) =>
    _notification(id: id, channelId: 'prayer_reminders_v2_softchime');

ActiveNotification _mediaNotification() =>
    _notification(id: kMediaNotificationId, channelId: kPlaybackChannelId);

void main() {
  group('isStrandedMediaNotification', () {
    test('matches anything on the playback channel', () {
      expect(isStrandedMediaNotification(_mediaNotification()), isTrue);
      // Survives upstream renumbering NOTIFICATION_ID.
      expect(
        isStrandedMediaNotification(
          _notification(id: 2048, channelId: kPlaybackChannelId),
        ),
        isTrue,
      );
    });

    test('spares every prayer reminder id the planner can produce', () {
      // dayIndex 0..13, five prayers, lead and on-time.
      for (var dayIndex = 0; dayIndex < 14; dayIndex++) {
        for (var slot = 0; slot < 5; slot++) {
          for (final lead in [0, 1]) {
            final id = 1000 + (dayIndex * 100) + (slot * 2) + lead;
            expect(
              isStrandedMediaNotification(_prayerReminder(id: id)),
              isFalse,
              reason: 'prayer reminder $id must never be swept',
            );
            // ...and also when the ROM reports no channel at all.
            expect(
              isStrandedMediaNotification(_notification(id: id)),
              isFalse,
              reason: 'channel-less prayer reminder $id must survive',
            );
          }
        }
      }
    });

    test('spares the self-test reminder', () {
      expect(isStrandedMediaNotification(_prayerReminder(id: 999)), isFalse);
    });

    test('falls back to the id when the ROM reports no channel', () {
      expect(
        isStrandedMediaNotification(_notification(id: kMediaNotificationId)),
        isTrue,
      );
    });

    test('a foreign channel is never swept, whatever its id', () {
      expect(
        isStrandedMediaNotification(
          _notification(id: kMediaNotificationId, channelId: 'something.else'),
        ),
        isFalse,
      );
    });
  });

  group('MediaNotificationCleanup.sweep', () {
    const fast = Duration.zero;

    test('cancels the stranded notification and confirms it is gone', () async {
      final reads = <int>[];
      final cancelled = <int>[];
      var posted = [_mediaNotification()];

      final cleanup = MediaNotificationCleanup(
        readActive: () async {
          reads.add(posted.length);
          return posted;
        },
        cancel: (id) async {
          cancelled.add(id);
          posted = [];
        },
        retryDelay: fast,
      );

      expect(await cleanup.sweep(), isTrue);
      expect(cancelled, [kMediaNotificationId]);
      // One read that found it, one that confirmed the cancel landed.
      expect(reads.length, 2);
    });

    test('retries when the platform re-posts the card', () async {
      final cancelled = <int>[];
      // Re-posted twice before the cancel finally sticks — the race this
      // exists for.
      var survivesMoreCancels = 2;

      final cleanup = MediaNotificationCleanup(
        readActive: () async =>
            survivesMoreCancels >= 0 ? [_mediaNotification()] : const [],
        cancel: (id) async {
          cancelled.add(id);
          survivesMoreCancels--;
        },
        retryDelay: fast,
      );

      expect(await cleanup.sweep(), isTrue);
      expect(cancelled, hasLength(3));
    });

    test('gives up after the bounded number of attempts', () async {
      var cancels = 0;
      final cleanup = MediaNotificationCleanup(
        readActive: () async => [_mediaNotification()],
        cancel: (_) async => cancels++,
        attempts: 4,
        retryDelay: fast,
      );

      expect(await cleanup.sweep(), isFalse);
      expect(cancels, 4, reason: 'must not spin forever on a stubborn ROM');
    });

    test('cancels nothing when only prayer reminders are posted', () async {
      final cancelled = <int>[];
      final cleanup = MediaNotificationCleanup(
        readActive: () async => [
          _prayerReminder(id: 1000),
          _prayerReminder(id: 1109),
          _prayerReminder(id: 999),
        ],
        cancel: (id) async => cancelled.add(id),
        retryDelay: fast,
      );

      expect(await cleanup.sweep(), isTrue);
      expect(cancelled, isEmpty);
    });

    test(
      'leaves prayer reminders alone while sweeping the media card',
      () async {
        final cancelled = <int>[];
        var posted = <ActiveNotification>[
          _prayerReminder(id: 1000),
          _mediaNotification(),
          _prayerReminder(id: 1304),
        ];

        final cleanup = MediaNotificationCleanup(
          readActive: () async => posted,
          cancel: (id) async {
            cancelled.add(id);
            posted = posted.where((n) => n.id != id).toList();
          },
          retryDelay: fast,
        );

        expect(await cleanup.sweep(), isTrue);
        expect(cancelled, [kMediaNotificationId]);
        expect(posted.map((n) => n.id), [1000, 1304]);
      },
    );

    test(
      'stands down when a new session starts before the first look',
      () async {
        var cancels = 0;
        final cleanup = MediaNotificationCleanup(
          readActive: () async => [_mediaNotification()],
          cancel: (_) async => cancels++,
          retryDelay: fast,
        );

        // Faith switch: stop, then the other vertical loads immediately.
        expect(await cleanup.sweep(isStale: () => true), isFalse);
        expect(
          cancels,
          isZero,
          reason: 'must never cancel a card for audio that is playing',
        );
      },
    );

    test('stands down mid-loop when playback restarts', () async {
      var cancels = 0;
      var stale = false;
      final cleanup = MediaNotificationCleanup(
        // Never goes away, so the sweep would otherwise run to its bound.
        readActive: () async => [_mediaNotification()],
        cancel: (_) async {
          cancels++;
          // The replay lands right after the first cancel.
          stale = true;
        },
        retryDelay: fast,
      );

      expect(await cleanup.sweep(isStale: () => stale), isFalse);
      expect(cancels, 1, reason: 'stops as soon as the session changes');
    });

    test('reports failure rather than throwing when the read fails', () async {
      var cancels = 0;
      final cleanup = MediaNotificationCleanup(
        readActive: () async => throw Exception('unsupported on this platform'),
        cancel: (_) async => cancels++,
        retryDelay: fast,
      );

      expect(await cleanup.sweep(), isFalse);
      expect(cancels, isZero);
    });
  });
}
