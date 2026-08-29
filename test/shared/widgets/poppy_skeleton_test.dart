import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/poppy_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(
    theme: AppTheme.light(FaithId.islam),
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('renders without throwing', (tester) async {
    await tester.pumpWidget(harness(const PoppySkeleton(height: 200)));
    // Shimmer's own animation controller keeps this from ever fully
    // settling — a bounded pump is enough to prove the first frame built.
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);
    expect(find.byType(PoppySkeleton), findsOneWidget);
  });

  testWidgets('respects a custom height', (tester) async {
    await tester.pumpWidget(harness(const PoppySkeleton(height: 123)));
    await tester.pump(const Duration(milliseconds: 50));

    final size = tester.getSize(find.byType(PoppySkeleton));
    expect(size.height, 123);
  });
}
