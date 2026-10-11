import 'dart:convert';

import 'package:faith_mobile/features/collections/data/dtos/curated_collection.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parsing the shapes the live API actually serves.
///
/// The fixtures below are trimmed from real responses of
/// `GET /api/v1/islam/collections[/nightly-recitation]` and the Hindu peer,
/// keeping every key this client reads and one it does not, so the
/// "unknown keys are ignored" assumption is exercised rather than assumed.
void main() {
  group('the list payload', () {
    const islamList = '''
    [{
      "slug": "nightly-recitation",
      "faithId": "islam",
      "title": "Nightly Recitation",
      "subtitle": "Before sleep",
      "description": "The set recited before sleeping.",
      "occasionType": "nightly",
      "occasionConfig": {"clock": {"to": "03:59", "from": "20:00"}},
      "orderSemantics": "sequence",
      "artworkKey": null,
      "estimatedMinutes": 6,
      "priority": 10,
      "sortOrder": 10,
      "provenance": {
        "provenanceClass": "transmitted",
        "reviewStatus": "self_reviewed",
        "curatedBy": "team/curated-collections-spec.md",
        "curatedAt": "2026-10-11T12:51:15.090Z",
        "reviewedBy": "Arham Imam",
        "reviewedAt": "2026-10-11T12:51:15.090Z"
      },
      "itemCount": 6
    }]''';

    test('parses a summary, items absent', () {
      final raw = (jsonDecode(islamList) as List).first;
      final c = CuratedCollection.fromJson(raw as Map<String, dynamic>);

      expect(c.slug, 'nightly-recitation');
      expect(c.title, 'Nightly Recitation');
      expect(c.itemCount, 6);
      expect(c.estimatedMinutes, 6);
      expect(c.sortOrder, 10);
      expect(c.occasionConfig?['clock'], {'to': '03:59', 'from': '20:00'});
      expect(c.provenance?.reviewedBy, 'Arham Imam');
      expect(c.provenance?.curatedAt, isA<DateTime>());
      expect(
        c.items,
        isEmpty,
        reason: 'the list endpoint omits items; itemCount is what cards use',
      );
    });

    test('a payload without showOnHome is not featured', () {
      // The column is being added server-side. Until it lands, every
      // collection must read as unfeatured — a dashboard with none on it,
      // never one with all of them.
      final raw = (jsonDecode(islamList) as List).first;
      final c = CuratedCollection.fromJson(raw as Map<String, dynamic>);

      expect(c.showOnHome, isFalse);
    });

    test('showOnHome is honoured once the server sends it', () {
      final raw =
          (jsonDecode(islamList) as List).first as Map<String, dynamic>;
      final c = CuratedCollection.fromJson({...raw, 'showOnHome': true});

      expect(c.showOnHome, isTrue);
    });
  });

  group('the detail payload', () {
    test('parses items and drops the resolved scripture', () {
      // `content` is ~196 KB of verse trees on the real response and this
      // client reads none of it — the readers fetch their own text. The
      // key is present here precisely to prove it is ignored rather than
      // choked on.
      const detail = '''
      {
        "slug": "nightly-recitation",
        "faithId": "islam",
        "title": "Nightly Recitation",
        "itemCount": 2,
        "items": [
          {
            "sequence": 1,
            "refType": "surah",
            "repeatCount": 3,
            "label": "Al-Ikhlas",
            "note": "The x3 belongs to the cupped-hands form.",
            "citation": "Bukhari 5017",
            "grading": "sahih",
            "translationSource": null,
            "isOptional": false,
            "ref": {
              "surahId": 112, "ayahStart": null, "ayahEnd": null,
              "hinduTextSlug": null, "chapterNumber": null,
              "verseStart": null, "verseEnd": null,
              "refSlug": null, "refId": null
            },
            "content": {"kind": "surah", "surah": {"id": 112}, "verses": []},
            "unresolved": null
          },
          {
            "sequence": 2,
            "refType": "ayah_range",
            "repeatCount": 1,
            "label": "Ayat al-Kursi",
            "isOptional": true,
            "ref": {"surahId": 2, "ayahStart": 255, "ayahEnd": null},
            "content": null,
            "unresolved": {"reason": "surah 2 not seeded"}
          }
        ]
      }''';

      final c = CuratedCollection.fromJson(
        jsonDecode(detail) as Map<String, dynamic>,
      );

      expect(c.items, hasLength(2));

      final first = c.items.first;
      expect(first.refType, 'surah');
      expect(first.repeatCount, 3);
      expect(first.ref.surahId, 112);
      expect(first.grading, 'sahih');
      expect(first.isOptional, isFalse);
      expect(first.unresolved, isNull);

      final second = c.items[1];
      expect(second.ref.ayahStart, 255);
      expect(second.ref.ayahEnd, isNull);
      expect(second.isOptional, isTrue);
      expect(second.unresolved?.reason, 'surah 2 not seeded');
      // Defaulted, not required: an item that omits it reads as "once".
      expect(second.repeatCount, 1);
    });

    test('parses a Hindu verse range', () {
      const detail = '''
      {
        "slug": "gita-daily",
        "faithId": "hindu",
        "title": "Daily Gita",
        "occasionType": "evergreen",
        "occasionConfig": {"always": true},
        "itemCount": 1,
        "items": [{
          "sequence": 1,
          "refType": "hindu_verse_range",
          "repeatCount": 1,
          "label": "Bhagavad Gita 12",
          "citation": "Bhagavad Gita 12.1-20",
          "grading": "not_applicable",
          "isOptional": false,
          "ref": {
            "surahId": null, "hinduTextSlug": "bhagavad-gita",
            "chapterNumber": 12, "verseStart": 1, "verseEnd": 20
          },
          "unresolved": null
        }]
      }''';

      final c = CuratedCollection.fromJson(
        jsonDecode(detail) as Map<String, dynamic>,
      );

      expect(c.occasionConfig, {'always': true});
      expect(c.items.single.ref.hinduTextSlug, 'bhagavad-gita');
      expect(c.items.single.ref.chapterNumber, 12);
      expect(c.items.single.ref.verseEnd, 20);
    });
  });
}
