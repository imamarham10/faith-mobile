import 'dart:async';

import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/feelings/data/dtos/emotion.dart';
import 'package:faith_mobile/features/feelings/presentation/controllers/emotions_controller.dart';
import 'package:faith_mobile/features/feelings/presentation/widgets/mood_chip.dart';
import 'package:faith_mobile/features/feelings/presentation/widgets/mood_sheet.dart';
import 'package:faith_mobile/features/hindu_feelings/data/dtos/hindu_emotion.dart';
import 'package:faith_mobile/features/hindu_feelings/presentation/controllers/hindu_emotions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_emotions.dart';
import '../../helpers/fake_selected_faith.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Renders the sheet directly — it is a plain widget, so it needs no
  /// bottom-sheet route to be exercised. [islam] / [hindu] stand in for the
  /// two network lists; passing null leaves that provider pending forever.
  Future<void> pump(
    WidgetTester tester, {
    required FaithId faith,
    List<Emotion>? islam,
    List<HinduEmotion>? hindu,
    Object? islamError,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
          emotionsProvider.overrideWith((ref) {
            if (islamError != null)
              return Future<List<Emotion>>.error(islamError);
            return islam == null
                ? Completer<List<Emotion>>().future
                : Future.value(islam);
          }),
          hinduEmotionsProvider.overrideWith(
            (ref) => hindu == null
                ? Completer<List<HinduEmotion>>().future
                : Future.value(hindu),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(faith),
          home: const Scaffold(body: MoodSheet()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('Islam', () {
    testWidgets('offers exactly the moods the server returned', (tester) async {
      await pump(tester, faith: FaithId.islam, islam: FakeEmotions.islam);

      for (final emotion in FakeEmotions.islam) {
        expect(find.text(emotion.name), findsOneWidget);
      }
      expect(find.byType(MoodChip), findsNWidgets(FakeEmotions.islam.length));
    });

    testWidgets('offers no mood the Islam dataset does not have', (
      tester,
    ) async {
      await pump(tester, faith: FaithId.islam, islam: FakeEmotions.islam);

      // The six slugs the old hardcoded `kDefaultMoods` offered that have no
      // row on the Islam side. Every one of them used to open a screen that
      // said "Emotion with slug '...' not found".
      for (final dead in const [
        'Lonely',
        'Hopeful',
        'Tested',
        'Joyful',
        'Heavy',
        'Searching',
      ]) {
        expect(find.text(dead), findsNothing, reason: '$dead has no remedy');
      }
    });

    testWidgets('shows a dua subtitle', (tester) async {
      await pump(tester, faith: FaithId.islam, islam: FakeEmotions.islam);
      expect(
        find.text("There's a dua for what you're carrying."),
        findsOneWidget,
      );
    });

    testWidgets('offers no chip at all while the list is still loading', (
      tester,
    ) async {
      await pump(tester, faith: FaithId.islam);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(MoodChip), findsNothing);
    });

    testWidgets('offers no chip when the list fails to load', (tester) async {
      await pump(
        tester,
        faith: FaithId.islam,
        islamError: Exception('offline'),
      );

      expect(find.text("Couldn't load moods."), findsOneWidget);
      // The whole point of dropping the hardcoded fallback: a failed load
      // shows nothing rather than a pill the server will reject.
      expect(find.byType(MoodChip), findsNothing);
    });
  });

  group('Hindu', () {
    testWidgets('offers the Hindu list, including slugs Islam lacks', (
      tester,
    ) async {
      await pump(tester, faith: FaithId.hindu, hindu: FakeEmotions.hindu);

      // `lonely` is real here and only here — the exact slug the user hit.
      expect(find.text('Lonely'), findsOneWidget);
      expect(find.text('Restless'), findsOneWidget);
      expect(find.byType(MoodChip), findsNWidgets(FakeEmotions.hindu.length));
    });

    testWidgets('does not show a mood only Islam has', (tester) async {
      await pump(tester, faith: FaithId.hindu, hindu: FakeEmotions.hindu);
      expect(find.text('Overwhelmed'), findsNothing);
    });

    testWidgets('shows a shloka subtitle', (tester) async {
      await pump(tester, faith: FaithId.hindu, hindu: FakeEmotions.hindu);
      expect(
        find.text("There's a shloka for what you're carrying."),
        findsOneWidget,
      );
    });
  });

  testWidgets('showMoodSheet resolves to the chosen slug', (tester) async {
    String? picked;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedFaithProvider.overrideWith(
            () => FakeSelectedFaith(FaithId.islam),
          ),
          emotionsProvider.overrideWith((ref) async => FakeEmotions.islam),
        ],
        child: MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async => picked = await showMoodSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Grateful'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // The slug, not the label — the slug is what the detail endpoint is
    // asked for, so this is the assertion that keeps the two in step.
    expect(picked, 'grateful');
  });
}
