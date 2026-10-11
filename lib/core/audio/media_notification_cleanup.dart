import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'playback_audio_service.dart';

/// The notification id `audio_service` posts its media notification under.
///
/// Upstream hard-codes it (`AudioService.NOTIFICATION_ID = 1124`) and exposes
/// no way to read or change it, so it is mirrored here. It is only ever a
/// *fallback* matcher — [MediaNotificationCleanup] prefers the channel id,
/// which is ours and therefore cannot drift out from under us on an
/// `audio_service` upgrade.
const int kMediaNotificationId = 1124;

/// Reads the notifications this app currently has posted.
typedef ActiveNotificationsReader = Future<List<ActiveNotification>> Function();

/// Removes one posted notification by id.
typedef NotificationCanceller = Future<void> Function(int id);

/// Decides whether [notification] is the stranded media notification.
///
/// Matching is by **channel** first: `kPlaybackChannelId` belongs to scripture
/// playback and nothing else posts on it, so a hit there is unambiguous and
/// survives upstream renumbering [kMediaNotificationId]. Android below 26 (and
/// a few OEM shells) report a null channel, so id is kept as a fallback —
/// which is still safe, because the only other notifications this app posts
/// are prayer reminders, whose ids are `1000 + dayIndex * 100 + slot * 2 +
/// lead` with `slot` in 0..4. Those always end in 00..09 and can never be
/// 1124. The self-test reminder is 999.
bool isStrandedMediaNotification(ActiveNotification notification) {
  final channelId = notification.channelId;
  if (channelId != null) return channelId == kPlaybackChannelId;
  return notification.id == kMediaNotificationId;
}

/// Clears the media notification that outlives a stopped playback session.
///
/// ## Why this is needed
///
/// `audio_service` posts its notification from a *bound* service. Stopping
/// playback makes it call `NotificationManager.cancel(1124)` and `stopSelf()`
/// — but `stopSelf()` cannot destroy a service that still has a live binding,
/// and the `AudioServicePlugin` holds one for as long as the Flutter engine
/// is up. So `onDestroy` — the one place that calls
/// `stopForeground(STOP_FOREGROUND_REMOVE)` and clears the service's
/// `notificationCreated` flag — never runs on a stop. The notification is
/// left posted, re-materialised a few tens of milliseconds later by the
/// platform, and the listener is left with a lock-screen card carrying stale
/// metadata and transport buttons wired to a dead session.
///
/// Measured on a OnePlus 9R: the record survived with `FLAG_NO_CLEAR` set,
/// and re-appeared as a *new* `NotificationRecord` 26–46 ms after the cancel
/// that `audio_service` itself issued.
///
/// ## Why it polls
///
/// That re-post is a race we do not control, so cancelling once immediately
/// loses. Rather than guess a delay long enough to win, [sweep] re-reads the
/// posted notifications and only reports success once the stranded record is
/// actually gone — a verified post-condition instead of a hopeful `sleep`.
class MediaNotificationCleanup {
  MediaNotificationCleanup({
    required ActiveNotificationsReader readActive,
    required NotificationCanceller cancel,
    this.attempts = 6,
    this.retryDelay = const Duration(milliseconds: 200),
  }) : _readActive = readActive,
       _cancel = cancel;

  /// Wires [sweep] to the real plugin. The plugin is a process-wide singleton
  /// already initialised by `NotificationService.init()` in `main`.
  factory MediaNotificationCleanup.plugin() {
    final plugin = FlutterLocalNotificationsPlugin();
    return MediaNotificationCleanup(
      readActive: plugin.getActiveNotifications,
      cancel: plugin.cancel,
    );
  }

  final ActiveNotificationsReader _readActive;
  final NotificationCanceller _cancel;

  /// How many times to look before giving up. Bounded so a ROM that refuses
  /// the cancel outright cannot spin forever.
  final int attempts;

  /// Spacing between looks. The first look is delayed too: the stranded
  /// record is re-posted *after* teardown, so checking immediately would read
  /// a notification list that is about to change.
  final Duration retryDelay;

  /// Returns true once no stranded media notification is posted.
  ///
  /// Never cancels anything it has not first *seen* and identified through
  /// [isStrandedMediaNotification]; a blind `cancel(1124)` could in principle
  /// hit a notification this app did not post.
  ///
  /// [isStale] is the other half of that safety. A sweep outlives the stop
  /// that started it, and playback can legitimately start again inside that
  /// window — switching faith stops one vertical and immediately loads the
  /// other, and a replay off the mini player does the same. The notification
  /// posted by *that* playback sits on the same channel and is indis-
  /// tinguishable from the stranded one, so the only way to tell them apart
  /// is to know that a new session has begun. When [isStale] says so, the
  /// sweep abandons the field rather than cancel a live card.
  Future<bool> sweep({bool Function()? isStale}) async {
    for (var attempt = 0; attempt < attempts; attempt++) {
      await Future<void>.delayed(retryDelay);
      if (isStale?.call() ?? false) return false;
      final List<ActiveNotification> active;
      try {
        active = await _readActive();
      } on Object catch (e, st) {
        // `getActiveNotifications` is unsupported on some platforms and can
        // throw on others. Losing the sweep is survivable; crashing the
        // teardown is not.
        developer.log(
          'could not read active notifications',
          name: 'audio',
          error: e,
          stackTrace: st,
        );
        return false;
      }
      final stranded = active.where(isStrandedMediaNotification).toList();
      if (stranded.isEmpty) return true;
      for (final notification in stranded) {
        final id = notification.id;
        if (id == null) continue;
        // Re-checked per cancel: the read above is a round trip to the
        // platform, and a new session can start while it is in flight.
        if (isStale?.call() ?? false) return false;
        await _cancel(id);
      }
    }
    developer.log(
      'media notification still posted after $attempts attempts',
      name: 'audio',
    );
    return false;
  }
}
