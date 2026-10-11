import 'dart:async';

import 'package:faith_mobile/core/network/api_exception.dart';
import 'package:faith_mobile/core/preferences/selected_faith.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/features/collections/data/dtos/collection_item.dart';
import 'package:faith_mobile/features/collections/data/dtos/curated_collection.dart';
import 'package:faith_mobile/features/collections/presentation/controllers/collections_controller.dart';
import 'package:faith_mobile/features/collections/presentation/screens/collection_screen.dart';
import 'package:faith_mobile/shared/widgets/poppy_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_collections.dart';
import '../../helpers/fake_selected_faith.dart';

/// The collection screen, and the one rule on it that is not negotiable.
///
/// > What you can press sits *on* the page. What you can only read *is* the
/// > page.
///
/// A `text` item is a prose instruction with no destination by design, and
/// an item the server could not resolve has no content behind it. Neither
/// may be a card, because in this design system a card **is** a button —
/// the finding behind this project's two dead-click reports, guarded for
/// the Practice chrome in `non_interactive_chrome_test.dart` and guarded
/// here for collection rows.
///
/// None of those refTypes is seeded, so no amount of device QA will ever
/// reach this path. It only exists as a test.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  late String location;

  CuratedCollection mixed() => const CuratedCollection(
    slug: 'mixed',
    faithId: 'islam',
    title: 'A mixed set',
    itemCount: 4,
    items: [
      // Tappable: a whole surah.
      CollectionItem(
        sequence: 1,
        refType: 'text',
        label: 'Cup your hands and blow into them',
      ),
      CollectionItem(
        sequence: 2,
        refType: 'surah',
        repeatCount: 3,
        label: 'Al-Ikhlas',
        citation: 'Bukhari 5017',
        ref: CollectionRef(surahId: 112),
      ),
      // Not tappable: the server could not resolve it.
      CollectionItem(
        sequence: 3,
        refType: 'surah',
        label: 'Al-Falaq',
        ref: CollectionRef(surahId: 113),
        unresolved: CollectionUnresolved(reason: 'surah 113 not seeded'),
      ),
      // Not tappable: no client route addresses a dhikr by slug.
      CollectionItem(
        sequence: 4,
        refType: 'dhikr',
        label: 'Tasbih',
        ref: CollectionRef(refSlug: 'subhanallah'),
      ),
    ],
  );

  Widget host(
    List<Override> overrides, {
    FaithId faith = FaithId.islam,
    String slug = 'mixed',
  }) {
    location = '/';
    return ProviderScope(
      overrides: [
        selectedFaithProvider.overrideWith(() => FakeSelectedFaith(faith)),
        ...overrides,
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(faith),
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (_, __) => CollectionScreen(slug: slug)),
            GoRoute(
              path: '/quran/surah/:id',
              builder: (_, state) {
                location = '/quran/surah/${state.pathParameters['id']}';
                return const Scaffold(body: Text('reader'));
              },
            ),
            GoRoute(
              path: '/quran/hindu-scripture/:slug/:chapter/verses',
              builder: (_, state) {
                location = '/quran/hindu-scripture/'
                    '${state.pathParameters['slug']}/'
                    '${state.pathParameters['chapter']}/verses'
                    '?from=${state.uri.queryParameters['from']}'
                    '&to=${state.uri.queryParameters['to']}';
                return const Scaffold(body: Text('pager'));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  List<Override> detail(CuratedCollection c, {FaithId faith = FaithId.islam}) =>
      [collectionDetailProvider(faith, c.slug).overrideWith((ref) async => c)];

  group('rows that lead nowhere', () {
    testWidgets('are listed, so the count still matches the card', (
      tester,
    ) async {
      await tester.pumpWidget(host(detail(mixed())));
      await settle(tester);

      // All four, including the two that cannot be opened. Skipping them
      // would make "4 readings" a lie and would hide a data problem the
      // server deliberately reports.
      expect(find.text('Cup your hands and blow into them'), findsOneWidget);
      expect(find.text('Al-Ikhlas'), findsOneWidget);
      expect(find.text('Al-Falaq'), findsOneWidget);
      expect(find.text('Tasbih'), findsOneWidget);
    });

    testWidgets('are not cards — only the one tappable item is', (
      tester,
    ) async {
      await tester.pumpWidget(host(detail(mixed())));
      await settle(tester);

      expect(
        find.byType(PoppyCard),
        findsOneWidget,
        reason:
            'three of these four rows open nothing; a card in this design '
            'system is a button, so only the surah may wear one',
      );
    });

    testWidgets('offer nothing to tap in their own subtree', (tester) async {
      await tester.pumpWidget(host(detail(mixed())));
      await settle(tester);

      // The assertion that actually catches the regression: a row could
      // lose its card and keep an InkWell or a GestureDetector and go on
      // swallowing taps silently.
      for (final label in [
        'Cup your hands and blow into them',
        'Al-Falaq',
        'Tasbih',
      ]) {
        // `.first` is the row's *own* Padding — ancestors come back
        // innermost first. `.last` would be the CustomScrollView's
        // SliverPadding, whose subtree legitimately contains the scroll
        // view's gesture recognisers and would make this pass vacuously.
        final row = find
            .ancestor(of: find.text(label), matching: find.byType(Padding))
            .first;
        expect(
          find.descendant(of: row, matching: find.byType(GestureDetector)),
          findsNothing,
          reason: label,
        );
        expect(
          find.descendant(of: row, matching: find.byType(InkWell)),
          findsNothing,
          reason: label,
        );
      }
    });

    testWidgets('an unresolved item says so rather than looking normal', (
      tester,
    ) async {
      await tester.pumpWidget(host(detail(mixed())));
      await settle(tester);

      expect(find.text('unavailable'), findsOneWidget);
    });
  });

  group('Begin', () {
    testWidgets('skips the prose instruction and opens the first reading', (
      tester,
    ) async {
      await tester.pumpWidget(host(detail(mixed())));
      await settle(tester);
      await tester.tap(find.text('Begin'));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/112');
    });

    testWidgets('is absent when nothing in the set opens', (tester) async {
      const deadSet = CuratedCollection(
        slug: 'mixed',
        faithId: 'islam',
        title: 'Nothing here opens',
        itemCount: 1,
        items: [
          CollectionItem(sequence: 1, refType: 'text', label: 'Sit quietly'),
        ],
      );
      await tester.pumpWidget(host(detail(deadSet)));
      await settle(tester);

      expect(
        find.text('Begin'),
        findsNothing,
        reason: 'an inert Begin would be the worst dead click on the screen',
      );
      expect(find.byType(PoppyCard), findsNothing);
    });
  });

  group('both faiths open through the same screen', () {
    testWidgets('an Islamic span lands in the fenced Qur\'an pager', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(detail(FakeCollections.nightly()), slug: 'nightly-recitation'),
      );
      await settle(tester);
      await tester.tap(find.text('Al-Mulk'));
      await tester.pumpAndSettle();

      expect(location, '/quran/surah/67');
    });

    testWidgets('a Hindu range lands in the fenced chapter pager', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          detail(FakeCollections.gita(), faith: FaithId.hindu),
          faith: FaithId.hindu,
          slug: 'gita-daily',
        ),
      );
      await settle(tester);
      await tester.tap(find.text('Bhagavad Gita 12 — Bhakti Yoga'));
      await tester.pumpAndSettle();

      expect(
        location,
        '/quran/hindu-scripture/bhagavad-gita/12/verses?from=1&to=20',
      );
    });

    testWidgets('provenance reads as the server classed it', (tester) async {
      // Spec §5.2: an assembled set must read as a selection, never as
      // "the" prescribed reading.
      await tester.pumpWidget(
        host(
          detail(FakeCollections.gita(), faith: FaithId.hindu),
          faith: FaithId.hindu,
          slug: 'gita-daily',
        ),
      );
      await settle(tester);

      expect(find.text('A selection assembled for this app.'), findsOneWidget);
    });

    testWidgets('the repeat count the old constant could not hold', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(detail(FakeCollections.nightly()), slug: 'nightly-recitation'),
      );
      await settle(tester);

      expect(find.text('×3'), findsNWidgets(2));
    });
  });

  group('states', () {
    testWidgets('a failure offers a retry', (tester) async {
      await tester.pumpWidget(
        host([
          collectionDetailProvider(FaithId.islam, 'mixed').overrideWith(
            (ref) async => throw const ApiException(message: 'Could not reach'),
          ),
        ]),
      );
      await settle(tester);

      // Unlike the dashboard rail, which stays silent: this screen was
      // opened on purpose, so a failure is worth saying out loud.
      expect(find.text('Try again'), findsOneWidget);
      expect(find.text('Could not reach'), findsOneWidget);
    });

    testWidgets('a slug belonging to the other faith reads as not found', (
      tester,
    ) async {
      // The 404 the server returns for `gita-daily` under `/islam/`. There
      // is no faith in the path, so this is how a stale cross-vertical
      // link surfaces.
      await tester.pumpWidget(
        host([
          collectionDetailProvider(FaithId.islam, 'mixed').overrideWith(
            (ref) async => throw const ApiException(
              message: "We couldn't find that.",
              statusCode: 404,
            ),
          ),
        ]),
      );
      await settle(tester);

      expect(find.text("We couldn't find that."), findsOneWidget);
    });

    testWidgets('while loading it shows its own shape, not a blank screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        host([
          collectionDetailProvider(FaithId.islam, 'mixed').overrideWith(
            (ref) => Completer<CuratedCollection>().future,
          ),
        ]),
      );
      await settle(tester);

      expect(find.text('Collection'), findsOneWidget);
      expect(find.byType(PoppyCard), findsNothing);
    });
  });
}
