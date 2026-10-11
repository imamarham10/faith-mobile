import 'package:faith_mobile/core/providers.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/hadiths/presentation/screens/hadith_book_screen.dart';
import 'package:faith_mobile/features/hadiths/presentation/screens/hadith_search_screen.dart';
import 'package:faith_mobile/features/hadiths/presentation/screens/hadiths_home_screen.dart';
import 'package:faith_mobile/features/hadiths/presentation/widgets/book_card.dart';
import 'package:faith_mobile/features/hadiths/presentation/widgets/hadith_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/stub_http.dart';
import 'free_tier_only_test.dart'
    show kBooksPayload, kFreeBookId, kPremiumBookId, kForbiddenBody, hadithJson;

/// What a user can actually reach, driven from the live wire shapes rather
/// than from stubbed repositories: the real `HadithsRepository` runs, and
/// only the HTTP adapter is replaced. A paid collection is in every payload
/// these screens fetch — the question each test asks is whether any of it
/// arrives on screen.
void main() {
  late StubHttpAdapter adapter;

  /// Every sentence the tree is currently drawing.
  List<String> renderedCopy(WidgetTester tester) => [
    for (final w in tester.widgetList<Text>(find.byType(Text)))
      w.data ?? w.textSpan?.toPlainText() ?? '',
    // Styled runs — the search excerpt's highlight, the grade chip — are
    // RichText, not Text, and would otherwise slip the sweep.
    for (final w in tester.widgetList<RichText>(find.byType(RichText)))
      w.text.toPlainText(),
  ];

  void expectNoSalesCopy(WidgetTester tester) {
    for (final line in renderedCopy(tester)) {
      final lower = line.toLowerCase();
      expect(
        lower,
        isNot(contains('premium')),
        reason: 'user-facing copy must not mention a tier: "$line"',
      );
      for (final word in ['upgrade', 'subscri', 'unlock', 'paid plan']) {
        expect(
          lower,
          isNot(contains(word)),
          reason: 'user-facing copy must not sell anything: "$line"',
        );
      }
    }
  }

  Future<void> pump(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioProvider.overrideWithValue(adapter.dio())],
        child: MaterialApp.router(
          theme: AppTheme.light(FaithId.islam),
          routerConfig: GoRouter(
            initialLocation: '/here',
            routes: [
              GoRoute(path: '/here', builder: (_, __) => screen),
              GoRoute(
                path: '/hadiths',
                builder: (_, __) => const Scaffold(body: Text('books home')),
              ),
            ],
          ),
        ),
      ),
    );
    // Bounded rather than settled: the mascot and masthead artwork animate
    // on a repeating controller, which pumpAndSettle would spin on forever.
    // Three frames, not one: the books list resolves on the first, the feed
    // it gates is only *requested* on the second, and lands on the third.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
  }

  setUp(() {
    adapter = StubHttpAdapter({
      '/hadiths/books': (200, kBooksPayload),
      '/hadiths/daily': (200, hadithJson(book: kBooksPayload[0])),
      '/hadiths/search': (200, [hadithJson(book: kBooksPayload[0])]),
      // The 403 a paid `bookId` earns. Reaching it at all is the failure.
      '/islam/hadiths': (403, kForbiddenBody),
    });
  });

  group('Books grid', () {
    testWidgets('lists only the collections this build carries', (
      tester,
    ) async {
      await pump(tester, const HadithsHomeScreen());

      final names = tester
          .widgetList<BookCard>(find.byType(BookCard))
          .map((c) => c.book.name)
          .toList();

      expect(names, contains('Sahih al-Bukhari'));
      expect(names, contains('40 Hadith Nawawi'));
      expect(names, isNot(contains('Sahih Muslim')));
      expect(names, isNot(contains('Sunan Abu Dawud')));
      expect(names.length, 3);
    });

    testWidgets('draws no tier badge and no sales copy', (tester) async {
      await pump(tester, const HadithsHomeScreen());
      expectNoSalesCopy(tester);
    });
  });

  group('Search', () {
    testWidgets('promises only the corpus it can actually search', (
      tester,
    ) async {
      await pump(tester, const HadithSearchScreen());

      // 7,671 free hadiths across three collections — not the 20,508 the
      // full library would total.
      expect(find.textContaining('7.7K'), findsOneWidget);
      expectNoSalesCopy(tester);
    });
  });

  group('A link into a paid collection', () {
    testWidgets('degrades to a dead link, not a locked door', (tester) async {
      await pump(tester, const HadithBookScreen(bookId: kPremiumBookId));

      expect(find.text('This collection isn\'t available'), findsOneWidget);
      expect(find.text('Browse hadiths'), findsOneWidget);
      expectNoSalesCopy(tester);
    });

    testWidgets('never asks the server for it', (tester) async {
      await pump(tester, const HadithBookScreen(bookId: kPremiumBookId));

      // The books list resolves first and the feed provider is only watched
      // for an id that is in it, so the 403 — and the sales copy it carries
      // — is never fetched in the first place.
      expect(adapter.requested.where((u) => u.contains('bookId=')), isEmpty);
    });

    testWidgets('an unknown id degrades the same way', (tester) async {
      await pump(tester, const HadithBookScreen(bookId: 'deleted-long-ago'));

      expect(find.text('This collection isn\'t available'), findsOneWidget);
      expectNoSalesCopy(tester);
    });
  });

  group('A link into a free collection', () {
    testWidgets('still opens', (tester) async {
      adapter.routes['/islam/hadiths'] = (
        200,
        {
          'hadiths': [hadithJson(book: kBooksPayload[0])],
          'total': 1,
          'page': 1,
          'limit': 20,
          'totalPages': 1,
        },
      );

      await pump(tester, const HadithBookScreen(bookId: kFreeBookId));

      expect(find.text('Sahih al-Bukhari'), findsWidgets);
      expect(find.byType(HadithListTile), findsOneWidget);
      expectNoSalesCopy(tester);
    });
  });
}
