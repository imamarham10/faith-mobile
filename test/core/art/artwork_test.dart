import 'dart:io';

import 'package:faith_mobile/core/art/artwork.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the catalog itself: that every slot resolves, that it resolves to
/// the *asking* faith's own artwork, and — the one that actually catches
/// mistakes — that the file it names is really in the bundle.
void main() {
  group('faith resolution', () {
    test('every faith/slot pair resolves to artwork', () {
      for (final faith in FaithId.values) {
        for (final slot in ArtSlot.values) {
          expect(
            artworkFor(faith, slot),
            isNotNull,
            reason: 'no artwork mapped for $faith / $slot',
          );
        }
      }
    });

    test('a slot resolves to the asking faith, never the other one', () {
      for (final slot in ArtSlot.values) {
        expect(
          artworkFor(FaithId.islam, slot)!.assetKey,
          startsWith('assets/art/islam/'),
          reason: 'Islam leaked a non-Islam asset at $slot',
        );
        expect(
          artworkFor(FaithId.hindu, slot)!.assetKey,
          startsWith('assets/art/hindu/'),
          reason: 'Hindu leaked a non-Hindu asset at $slot',
        );
      }
    });

    test('the two faiths never share an asset file', () {
      for (final slot in ArtSlot.values) {
        expect(
          artworkFor(FaithId.islam, slot)!.assetKey,
          isNot(equals(artworkFor(FaithId.hindu, slot)!.assetKey)),
          reason: 'both faiths resolve $slot to the same file',
        );
      }
    });

    test('every artwork carries a non-empty label and a sane ratio', () {
      for (final faith in FaithId.values) {
        for (final slot in ArtSlot.values) {
          final art = artworkFor(faith, slot)!;
          expect(art.semanticLabel, isNotEmpty);
          expect(art.aspectRatio, greaterThan(0));
        }
      }
    });
  });

  group('bundle integrity', () {
    test('every assetKey names a file that exists on disk', () {
      for (final faith in FaithId.values) {
        for (final slot in ArtSlot.values) {
          final key = artworkFor(faith, slot)!.assetKey;
          expect(
            File(key).existsSync(),
            isTrue,
            reason: '$faith / $slot points at missing file $key',
          );
        }
      }
    });

    test('every asset directory used by the catalog is declared in pubspec', () {
      // Read as lines rather than through a YAML parser: this assertion is
      // not worth a new dependency, and the `assets:` block is a flat list
      // of literal paths, which is exactly what this matches.
      final declared = File('pubspec.yaml')
          .readAsLinesSync()
          .map((l) => l.trim())
          .where((l) => l.startsWith('- assets/'))
          .map((l) => l.substring(2))
          .toSet();

      for (final faith in FaithId.values) {
        for (final slot in ArtSlot.values) {
          final key = artworkFor(faith, slot)!.assetKey;
          final dir = '${key.substring(0, key.lastIndexOf('/'))}/';
          expect(
            declared,
            contains(dir),
            reason:
                '$dir holds artwork but is not listed under flutter.assets — '
                'it would be missing from the built bundle',
          );
        }
      }
    });
  });
}
