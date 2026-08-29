import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
import 'package:faith_mobile/shared/widgets/poppy_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the given icon glyph', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(FaithId.islam),
        home: const Scaffold(body: PoppyIcon(icon: Icons.fingerprint)),
      ),
    );
    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
  });

  testWidgets(
    'does not render an invisible icon when a custom background is supplied without a foreground',
    (tester) async {
      final palette = AppTheme.light(FaithId.islam).extension<FaithThemeExtension>()!.palette;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: Scaffold(
            body: PoppyIcon(icon: Icons.star, background: palette.primary),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(iconWidget.color, isNot(equals(palette.primary)));
    },
  );
}
