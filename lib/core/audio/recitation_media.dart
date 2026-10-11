import 'package:audio_service/audio_service.dart';

/// Base URL for the recitation source. Each ayah is
/// `$kRecitationBaseUrl/$surah$ayah.mp3` (three-digit surah, three-digit
/// ayah).
///
/// Provider: Mishary Rashid Alafasy via everyayah.com — a well-known mirror
/// commonly used by Quran apps.
// TODO: replace with a real recitation source from the backend when available.
const String kRecitationBaseUrl = 'https://everyayah.com/data/Alafasy_128kbps';

/// Reciter shown as the "artist" line of the media notification.
const String kReciterName = 'Mishary Rashid Alafasy';

/// Builds the recitation URL for a specific ayah.
String recitationUrl({required int surah, required int ayah}) {
  final s = surah.toString().padLeft(3, '0');
  final a = ayah.toString().padLeft(3, '0');
  return '$kRecitationBaseUrl/$s$a.mp3';
}

/// The notification / lock-screen entry for one ayah.
///
/// The lock screen is the only place a listener sees *what* is playing once
/// the screen is off, so it names the verse rather than the app: title is
/// `Al-Ahzab 33:35`, not "Playing".
MediaItem recitationMediaItem({
  required int surah,
  required int ayah,
  required String surahName,
}) => MediaItem(
  id: recitationUrl(surah: surah, ayah: ayah),
  title: '$surahName $surah:$ayah',
  artist: kReciterName,
  album: 'Qur’an recitation',
  // `extras` survives the round trip through the platform media session, so
  // the handler can map a notification-driven track change back to an ayah
  // without re-parsing the id.
  extras: {'surah': surah, 'ayah': ayah},
);

/// Every ayah of [surahId] as a queue, in recitation order.
///
/// The whole surah is queued rather than loaded one ayah at a time so that
/// auto-advance never passes through `completed` → a fresh load. That
/// transition would tear the foreground service down and start it again at
/// every verse boundary, which both flickers the notification and reopens
/// the window in which the process is unprotected.
List<MediaItem> recitationQueue({
  required int surahId,
  required String surahName,
  required int totalVerses,
}) => [
  for (var ayah = 1; ayah <= totalVerses; ayah++)
    recitationMediaItem(surah: surahId, ayah: ayah, surahName: surahName),
];
