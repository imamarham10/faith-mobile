import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/quran/data/dtos/verse.dart';
import 'package:faith_mobile/features/quran/presentation/widgets/ayah_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The surah reader had the same flaw as the juz reader: the Arabic-script
/// preference swapped the font and left the text alone. Two readers of one
/// text must not disagree about what script the reader asked for — the same
/// class of inconsistency as two readers disagreeing about verse counts.
void main() {
  const seeded = Verse(
    id: '2:142',
    surahId: 2,
    verseNumber: 142,
    textArabic: 'payload-arabic',
    textIndopak: 'payload-indopak',
  );

  /// What the API returns today, and for any verse the seed misses.
  const unseeded = Verse(
    id: '2:142',
    surahId: 2,
    verseNumber: 142,
    textArabic: 'payload-arabic',
  );

  Future<void> pump(
    WidgetTester tester,
    Verse verse, {
    String? script,
  }) async {
    SharedPreferences.setMockInitialValues({
      if (script != null) 'arabic_script': script,
    });
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(FaithId.islam),
          home: Scaffold(
            body: AyahView(
              verse: verse,
              arabicFontSize: 28,
              showTranslation: false,
              isPlaying: false,
              isBookmarked: false,
              onTap: () {},
              onLongPress: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Indo-Pak renders the Indo-Pak text, not the payload text', (
    tester,
  ) async {
    await pump(tester, seeded);

    expect(find.text('payload-indopak'), findsOneWidget);
    expect(find.text('payload-arabic'), findsNothing);
  });

  testWidgets('Naskh renders the payload text', (tester) async {
    await pump(tester, seeded, script: 'naskh');

    expect(find.text('payload-arabic'), findsOneWidget);
  });

  testWidgets('a null textIndopak still renders the verse', (tester) async {
    // The live path: the field is additive and not yet seeded.
    await pump(tester, unseeded);

    expect(find.text('payload-arabic'), findsOneWidget);
  });

  testWidgets('Uthmani falls back — the surah payload carries no Uthmani', (
    tester,
  ) async {
    await pump(tester, seeded, script: 'uthmani');

    expect(find.text('payload-arabic'), findsOneWidget);
  });

  testWidgets('leading is split evenly so the marks above line one survive', (
    tester,
  ) async {
    await pump(tester, seeded);

    final arabic = tester.widget<Text>(find.text('payload-indopak'));
    expect(arabic.style!.leadingDistribution, TextLeadingDistribution.even);
    expect(arabic.style!.height, greaterThan(1.8));
  });
}
