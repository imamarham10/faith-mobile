import 'package:faith_mobile/core/audio/recitation_media.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('recitationUrl', () {
    test('zero-pads surah and ayah to three digits each', () {
      expect(
        recitationUrl(surah: 1, ayah: 1),
        'https://everyayah.com/data/Alafasy_128kbps/001001.mp3',
      );
      expect(
        recitationUrl(surah: 33, ayah: 35),
        'https://everyayah.com/data/Alafasy_128kbps/033035.mp3',
      );
    });

    test('does not pad past three digits for the longest surah', () {
      // Al-Baqarah 2:286 is the largest ayah number in the Qur'an; a fourth
      // digit here would mean the padding logic had grown the field.
      expect(
        recitationUrl(surah: 2, ayah: 286),
        'https://everyayah.com/data/Alafasy_128kbps/002286.mp3',
      );
      expect(
        recitationUrl(surah: 114, ayah: 6),
        'https://everyayah.com/data/Alafasy_128kbps/114006.mp3',
      );
    });
  });

  group('recitationMediaItem', () {
    test('names the verse rather than the app', () {
      final item = recitationMediaItem(
        surah: 33,
        ayah: 35,
        surahName: 'Al-Ahzab',
      );
      // The lock screen is the only place a listener can see what is playing
      // once the screen is off, so a generic "Playing" would be a regression.
      expect(item.title, 'Al-Ahzab 33:35');
      expect(item.artist, kReciterName);
      expect(item.id, recitationUrl(surah: 33, ayah: 35));
    });

    test('carries surah and ayah through extras', () {
      final item = recitationMediaItem(
        surah: 2,
        ayah: 255,
        surahName: 'Al-Baqarah',
      );
      expect(item.extras?['surah'], 2);
      expect(item.extras?['ayah'], 255);
    });
  });

  group('recitationQueue', () {
    test('covers every ayah exactly once, in order', () {
      final q = recitationQueue(
        surahId: 33,
        surahName: 'Al-Ahzab',
        totalVerses: 73,
      );
      expect(q.length, 73);
      expect(q.first.title, 'Al-Ahzab 33:1');
      expect(q.last.title, 'Al-Ahzab 33:73');
      expect(q.map((e) => e.id).toSet().length, 73);
    });

    test('queues the whole surah so auto-advance never reloads', () {
      // The playlist exists specifically so an ayah boundary is a seek, not
      // a `completed` -> fresh-load cycle that would tear the foreground
      // service down and back up at every verse.
      final q = recitationQueue(
        surahId: 1,
        surahName: 'Al-Fatihah',
        totalVerses: 7,
      );
      expect(
        q.map((e) => e.extras?['ayah']).toList(),
        [1, 2, 3, 4, 5, 6, 7],
      );
    });

    test('single-ayah surah still yields one item', () {
      final q = recitationQueue(
        surahId: 108,
        surahName: 'Al-Kawthar',
        totalVerses: 3,
      );
      expect(q.length, 3);
    });
  });
}
