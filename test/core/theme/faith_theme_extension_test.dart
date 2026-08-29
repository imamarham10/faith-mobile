import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_palette.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('of() builds from a FaithId + palette', () {
    final ext = FaithThemeExtension.of(
      FaithId.hindu,
      FaithPalette.of(FaithId.hindu, Brightness.light),
    );
    expect(ext.faithId, FaithId.hindu);
  });

  test('lerp at t<0.5 keeps this faithId, t>=0.5 keeps other', () {
    final islam = FaithThemeExtension.of(
      FaithId.islam,
      FaithPalette.of(FaithId.islam, Brightness.light),
    );
    final hindu = FaithThemeExtension.of(
      FaithId.hindu,
      FaithPalette.of(FaithId.hindu, Brightness.light),
    );
    expect(islam.lerp(hindu, 0.0).faithId, FaithId.islam);
    expect(islam.lerp(hindu, 0.99).faithId, FaithId.hindu);
  });

  testWidgets('is retrievable via Theme.of(context).extension', (
    tester,
  ) async {
    final ext = FaithThemeExtension.of(
      FaithId.islam,
      FaithPalette.of(FaithId.islam, Brightness.light),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [ext]),
        home: Builder(
          builder: (context) {
            final read = Theme.of(context).extension<FaithThemeExtension>();
            return Text(read!.faithId.name);
          },
        ),
      ),
    );
    expect(find.text('islam'), findsOneWidget);
  });
}
