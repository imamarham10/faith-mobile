import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'recitation_audio_handler.dart';

/// Notification channel for recitation playback.
///
/// Deliberately distinct from the `flutter_local_notifications` prayer
/// channels: a channel's importance is fixed at creation and silently
/// inherited by whoever reuses the id, so sharing one would let prayer
/// reminders and the media notification redefine each other.
const String kRecitationChannelId =
    'com.faith.companion.faith_mobile.channel.recitation';

/// Starts `AudioService` on demand and hands out the one handler.
///
/// `AudioService.init()` binds a service and creates a media session, so it
/// is **not** called from `main()`: it runs on the first tap of "Play
/// recitation" and costs nothing on a cold start that never plays audio.
/// Callers already await [playAyah]-style entry points, so the one-time
/// bind is absorbed by the buffering the first verse needs anyway.
class RecitationAudioService {
  RecitationAudioService._();

  static final RecitationAudioService instance = RecitationAudioService._();

  Future<RecitationAudioHandler>? _pending;

  /// Test seam. Tests cannot bind a platform media session, so they install
  /// a builder here instead of reaching the `AudioService.init()` below.
  /// Null in production.
  static Future<RecitationAudioHandler> Function()? debugBuilderOverride;

  /// Idempotent. Concurrent callers share the one in-flight init rather than
  /// racing two `AudioService.init()` calls, which the platform rejects.
  Future<RecitationAudioHandler> ensureStarted() =>
      _pending ??= _start().onError((Object e, StackTrace st) {
        // A failed bind must not poison every later attempt.
        _pending = null;
        Error.throwWithStackTrace(e, st);
      });

  Future<RecitationAudioHandler> _start() async {
    final override = debugBuilderOverride;
    if (override != null) return override();
    final handler = await AudioService.init(
      builder: () => RecitationAudioHandler(AudioPlayer()),
      config: const AudioServiceConfig(
        androidNotificationChannelId: kRecitationChannelId,
        androidNotificationChannelName: 'Qur’an recitation',
        androidNotificationChannelDescription:
            'Playback controls for Qur’an recitation.',
        // Ongoing: the notification cannot be swiped away mid-recitation,
        // which is also what keeps the service in the foreground.
        androidNotificationOngoing: true,
        // ...and pausing drops it back out of the foreground, so a paused
        // player does not hold a foreground service indefinitely.
        androidStopForegroundOnPause: true,
        androidNotificationClickStartsActivity: true,
        // Must be false, and this is the only lever for it. `audio_service`'s
        // `onDestroy` does:
        //
        //   ServiceCompat.stopForeground(this, config.androidResumeOnClick
        //       ? STOP_FOREGROUND_DETACH : STOP_FOREGROUND_REMOVE);
        //
        // with its explicit `notificationManager.cancel(...)` commented out
        // upstream. Left at its default of true, stopping playback *detaches*
        // the notification and leaves it on the device for a recitation that
        // is no longer playing. False gives STOP_FOREGROUND_REMOVE, so the
        // notification goes when the service does.
        //
        // The cost is only that tapping the notification no longer resumes;
        // tapping still opens the app, via
        // `androidNotificationClickStartsActivity` above.
        androidResumeOnClick: false,
        androidNotificationIcon: 'mipmap/ic_launcher',
      ),
    );
    await handler.start();
    return handler;
  }
}
