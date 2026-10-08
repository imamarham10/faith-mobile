import 'package:faith_mobile/features/today/presentation/widgets/daily_hadith_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('splitNarration', () {
    test('lifts the attribution clause off the front of the matn', () {
      // Exactly the shape the live corpus returns — note the missing space
      // after the colon, which is the corpus's own convention.
      const raw =
          'Narrated `Aisha:Sa`d was wounded on the day of Khandaq when a man '
          'from Quraish hit him with an arrow.';
      final split = splitNarration(raw);

      expect(split.narrator, 'Narrated `Aisha');
      expect(split.matn, startsWith('Sa`d was wounded'));
      expect(split.matn, isNot(contains('Narrated')));
    });

    test('leaves text alone when it does not follow the convention', () {
      const raw = 'The Prophet said: actions are judged by intentions.';
      final split = splitNarration(raw);

      expect(split.narrator, isNull);
      expect(split.matn, raw);
    });

    test('does not split on a colon buried deep in the teaching', () {
      // A colon 200 characters in belongs to the matn, not an attribution.
      final raw = 'Narrated ${'a' * 200}: and then he said something.';
      final split = splitNarration(raw);

      expect(split.narrator, isNull);
      expect(split.matn, raw);
    });

    test('keeps the whole text when nothing follows the colon', () {
      const raw = 'Narrated Abu Huraira:';
      final split = splitNarration(raw);

      expect(split.narrator, isNull);
      expect(split.matn, raw);
    });

    test('trims surrounding whitespace', () {
      final split = splitNarration('  Narrated Anas:  He prayed.  ');
      expect(split.narrator, 'Narrated Anas');
      expect(split.matn, 'He prayed.');
    });
  });
}
