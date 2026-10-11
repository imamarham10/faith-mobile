import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'playback_audio_handler.dart';

/// Notification channel for scripture playback — Qur'an recitation and
/// Hindu chapter narration share it.
///
/// Deliberately distinct from the `flutter_local_notifications` prayer
/// channels: a channel's importance is fixed at creation and silently
/// inherited by whoever reuses the id, so sharing one would let prayer
/// reminders (`prayer_reminders_v2_softchime`, importance 4) and the media
/// notification redefine each other. This one sits at importance 2.
///
/// The id still says `recitation` though the channel now carries narration
/// too. That is on purpose: the id is invisible to users, while *changing*
/// it would create a second channel and strand the existing one — an empty
/// "Qur'an recitation" row in system settings on every device that has
/// already run this app. Only the user-visible name below moved.
const String kPlaybackChannelId =
    'com.faith.companion.faith_mobile.channel.recitation';

/// Starts `AudioService` on demand and hands out the one handler.
///
/// `audio_service` supports exactly one `AudioService.init()` per process —
/// the constraint that makes a single shared handler the only workable shape
/// for two verticals, and the reason `just_audio_background` (which claims
/// `JustAudioPlatform.instance` globally) could not be used at all.
///
/// `init()` binds a service and creates a media session, so it is **not**
/// called from `main()`: it runs on the first tap of play in either vertical
/// and costs nothing on a cold start that never plays audio. Callers already
/// await their play entry points, so the one-time bind is absorbed by the
/// buffering the first track needs anyway.
class AudioPlaybackService {
  AudioPlaybackService._();

  static final AudioPlaybackService instance = AudioPlaybackService._();

  Future<PlaybackAudioHandler>? _pending;

  /// Non-null once [ensureStarted] has actually completed. Lets callers that
  /// only want to *stop* playback avoid binding a media session that was
  /// never needed.
  PlaybackAudioHandler? _handler;

  /// Test seam. Tests cannot bind a platform media session, so they install
  /// a builder here instead of reaching the `AudioService.init()` below.
  /// Null in production.
  static Future<PlaybackAudioHandler> Function()? debugBuilderOverride;

  /// Idempotent. Concurrent callers share the one in-flight init rather than
  /// racing two `AudioService.init()` calls, which the platform rejects.
  Future<PlaybackAudioHandler> ensureStarted() =>
      _pending ??= _start().onError((Object e, StackTrace st) {
        // A failed bind must not poison every later attempt.
        _pending = null;
        Error.throwWithStackTrace(e, st);
      });

  /// Ends playback if — and only if — the service is already running.
  ///
  /// Called when the app changes faith: narration from the vertical the user
  /// just left has no in-app control left once its mini player is gone, and
  /// a Gita notification sitting over the Islam vertical is precisely the
  /// orphaned session this is meant to prevent. A faith switch on a launch
  /// that never played anything must not be the thing that binds a media
  /// session, hence the null check rather than [ensureStarted].
  Future<void> stopIfRunning() async {
    final handler = _handler;
    if (handler == null) return;
    await handler.stop();
  }

  Future<PlaybackAudioHandler> _start() async {
    final override = debugBuilderOverride;
    if (override != null) {
      final handler = await override();
      _handler = handler;
      return handler;
    }
    final handler = await AudioService.init(
      builder: () => PlaybackAudioHandler(AudioPlayer()),
      config: const AudioServiceConfig(
        androidNotificationChannelId: kPlaybackChannelId,
        androidNotificationChannelName: 'Scripture audio',
        androidNotificationChannelDescription:
            'Playback controls for recitation and narration.',
        // Ongoing: the notification cannot be swiped away mid-track, which
        // is also what keeps the service in the foreground.
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
        // the notification and leaves it on the device for a track that is no
        // longer playing. False gives STOP_FOREGROUND_REMOVE, so the
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
    _handler = handler;
    return handler;
  }
}
