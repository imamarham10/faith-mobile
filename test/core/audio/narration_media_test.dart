import 'package:audio_service/audio_service.dart';
import 'package:faith_mobile/core/audio/narration_media.dart';
import 'package:faith_mobile/core/audio/playback_audio_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('narrationUrl', () {
    const web = 'https://www.siraat.website';

    test('resolves a host-relative narration path against the web app', () {
      // The API host 404s these; the web app serves them. Resolving against
      // the wrong base is silent — the player just never starts.
      expect(
        narrationUrl('/audio/gita/hi/ch01.mp3', webBaseUrl: web),
        'https://www.siraat.website/audio/gita/hi/ch01.mp3',
      );
    });

    test('leaves an absolute url alone', () {
      expect(
        narrationUrl('https://cdn.example.com/ch02.mp3', webBaseUrl: web),
        'https://cdn.example.com/ch02.mp3',
      );
    });

    test('tolerates a trailing slash on the base', () {
      expect(
        narrationUrl('/audio/gita/hi/ch01.mp3', webBaseUrl: '$web/'),
        'https://www.siraat.website/audio/gita/hi/ch01.mp3',
      );
    });
  });

  group('scriptureTextTitle', () {
    test('reads a slug as the name of the book', () {
      expect(scriptureTextTitle('bhagavad-gita'), 'Bhagavad Gita');
      expect(scriptureTextTitle('ramayana'), 'Ramayana');
      expect(scriptureTextTitle('shiva_purana'), 'Shiva Purana');
    });
  });

  group('narrationMediaItem', () {
    final item = narrationMediaItem(
      url: 'https://www.siraat.website/audio/gita/hi/ch02.mp3',
      textSlug: 'bhagavad-gita',
      chapterNumber: 2,
      chapterTitle: 'Sankhya Yoga',
      reciterName: 'Hindi — Swami Anand',
    );

    test('names the chapter and the book, not the app', () {
      // The lock screen is the only place a listener sees what is playing
      // once the screen is off. "Qur'an recitation" over a Gita chapter was
      // the content bug this had to avoid.
      expect(item.title, 'Sankhya Yoga');
      expect(item.album, 'Bhagavad Gita · Chapter 2');
      expect(item.artist, 'Hindi — Swami Anand');
    });

    test('plays from the resolved url', () {
      // The handler builds its audio source from `id`, so a relative path
      // surviving to here would fail at playback, not at resolution.
      expect(item.id, 'https://www.siraat.website/audio/gita/hi/ch02.mp3');
      expect(Uri.parse(item.id).hasScheme, isTrue);
    });

    test('carries the chapter identity through the media session', () {
      expect(item.extras, {'textSlug': 'bhagavad-gita', 'chapter': 2});
    });
  });

  group('playbackControls', () {
    test('a one-track narration queue offers no previous or next', () {
      final b = playbackControls(playing: true, multiTrack: false);
      expect(b.controls, [MediaControl.pause, MediaControl.stop]);
    });

    test('a surah queue offers previous and next', () {
      final b = playbackControls(playing: true, multiTrack: true);
      expect(b.controls, [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
        MediaControl.stop,
      ]);
    });

    test('play replaces pause when stopped', () {
      expect(
        playbackControls(playing: false, multiTrack: false).controls.first,
        MediaControl.play,
      );
    });

    test('every compact index points at a control that exists', () {
      // A compact index past the end of the control list crashes some OEM
      // notification shells, and the single-track queue is exactly where
      // that regression would appear.
      for (final playing in [true, false]) {
        for (final multiTrack in [true, false]) {
          final b = playbackControls(playing: playing, multiTrack: multiTrack);
          for (final i in b.compactIndices) {
            expect(
              i,
              lessThan(b.controls.length),
              reason: 'playing=$playing multiTrack=$multiTrack',
            );
          }
        }
      }
    });
  });
}
