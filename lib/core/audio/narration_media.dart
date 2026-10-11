/// Media description for Hindu scripture narration.
///
/// The counterpart of `recitation_media.dart` on the Islam side, and
/// deliberately a separate file: both build [MediaItem]s for the one shared
/// [PlaybackAudioHandler], but a Gita chapter is not a Qur'an ayah and
/// neither vocabulary belongs in the other's module.
library;

import 'package:audio_service/audio_service.dart';

/// Absolute playback URL for a narration track.
///
/// Some tracks (this backend's own narrations) are served as host-relative
/// paths (e.g. `/audio/gita/hi/ch01.mp3`) rather than absolute URLs — unlike
/// Qur'an audio, which is always a hardcoded absolute third-party URL.
/// `just_audio` requires an absolute URI, so a relative path must be
/// resolved to one or playback fails outright.
///
/// These particular relative paths are NOT served by the API host —
/// confirmed live: `unified-faith-service.vercel.app/audio/...` 404s. They
/// are served by the web app's own static assets instead
/// (`www.siraat.website/audio/...` 200s), so callers resolve against the web
/// base URL, not the API one.
String narrationUrl(String url, {required String webBaseUrl}) {
  final uri = Uri.parse(url);
  if (uri.hasScheme) return url;
  return Uri.parse(webBaseUrl).resolveUri(uri).toString();
}

/// Human-readable name for a scripture slug — `bhagavad-gita` reads as
/// `Bhagavad Gita`.
///
/// The reader passes a chapter title but no text title, and the lock screen
/// is the only place a listener can see *what* is playing once the screen is
/// off, so "Chapter 2" with no book beside it would be a worse notification
/// than the one this replaces.
String scriptureTextTitle(String slug) => slug
    .split(RegExp(r'[-_]'))
    .where((part) => part.isNotEmpty)
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join(' ');

/// The notification / lock-screen entry for one chapter narration.
///
/// Narration is per-*chapter*, not segmented by verse, so this is a queue of
/// one — which is why the handler derives its control set from the queue
/// length rather than always offering previous/next.
MediaItem narrationMediaItem({
  required String url,
  required String textSlug,
  required int chapterNumber,
  required String chapterTitle,
  required String reciterName,
}) => MediaItem(
  id: url,
  title: chapterTitle,
  artist: reciterName,
  album: '${scriptureTextTitle(textSlug)} · Chapter $chapterNumber',
  // `extras` survives the round trip through the platform media session, so
  // a notification-driven event can be mapped back to a chapter without
  // re-parsing the id.
  extras: {'textSlug': textSlug, 'chapter': chapterNumber},
);
