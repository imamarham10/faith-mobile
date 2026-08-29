import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every FaithId has a light and dark palette', () {
    for (final faith in FaithId.values) {
      expect(FaithPalette.of(faith, Brightness.light), isNotNull);
      expect(FaithPalette.of(faith, Brightness.dark), isNotNull);
    }
  });

  test('islam and hindu primaries are distinct', () {
    final islam = FaithPalette.of(FaithId.islam, Brightness.light);
    final hindu = FaithPalette.of(FaithId.hindu, Brightness.light);
    expect(islam.primary, isNot(equals(hindu.primary)));
  });

  test('shared neutrals match across faiths (same brightness)', () {
    final islam = FaithPalette.of(FaithId.islam, Brightness.light);
    final hindu = FaithPalette.of(FaithId.hindu, Brightness.light);
    expect(islam.surface, hindu.surface);
    expect(islam.ink, hindu.ink);
  });
}
