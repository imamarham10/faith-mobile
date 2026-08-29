import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/stat_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders value and label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(FaithId.islam),
        home: const Scaffold(
          body: StatChip(value: '12', label: 'day streak'),
        ),
      ),
    );
    expect(find.text('12'), findsOneWidget);
    expect(find.text('day streak'), findsOneWidget);
  });
}
