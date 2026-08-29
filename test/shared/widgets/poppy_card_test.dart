import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(FaithId.islam),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders child content', (tester) async {
    await tester.pumpWidget(
      harness(const PoppyCard(child: Text('hello'))),
    );
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('calls onTap and shows pressed state on tap-down', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      harness(
        PoppyCard(onTap: () => tapped = true, child: const Text('tap me')),
      ),
    );
    await tester.tap(find.text('tap me'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
