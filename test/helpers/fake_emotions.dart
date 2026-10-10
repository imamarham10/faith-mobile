import 'package:faith_mobile/features/feelings/data/dtos/emotion.dart';
import 'package:faith_mobile/features/hindu_feelings/data/dtos/hindu_emotion.dart';

/// Mood fixtures taken verbatim from the seeded production data, so a test
/// can assert the chooser offers what the server actually has.
///
/// The distinction that matters: `lonely` is a real Hindu slug and is NOT an
/// Islam slug. The chooser used to ship a hardcoded nine-mood list to both,
/// which is how "Lonely" came to be offered under Islam and then 404'd. Any
/// test that proves the two faiths' lists differ has to use real slugs, so
/// these are real.
abstract final class FakeEmotions {
  /// A representative slice of `GET /api/v1/islam/feelings` (14 in full).
  static const List<Emotion> islam = [
    Emotion(id: 'i1', name: 'Anxious', slug: 'anxious'),
    Emotion(id: 'i2', name: 'Grateful', slug: 'grateful'),
    Emotion(id: 'i3', name: 'Lost', slug: 'lost'),
    Emotion(id: 'i4', name: 'Overwhelmed', slug: 'overwhelmed'),
  ];

  /// A representative slice of `GET /api/v1/hindu/feelings` (10 in full).
  static const List<HinduEmotion> hindu = [
    HinduEmotion(id: 'h1', slug: 'anxious', nameEnglish: 'Anxious'),
    HinduEmotion(id: 'h2', slug: 'grateful', nameEnglish: 'Grateful'),
    HinduEmotion(id: 'h3', slug: 'lonely', nameEnglish: 'Lonely'),
    HinduEmotion(id: 'h4', slug: 'restless', nameEnglish: 'Restless'),
  ];
}
