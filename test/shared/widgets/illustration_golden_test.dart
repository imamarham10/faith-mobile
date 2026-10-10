import 'dart:async';

import 'package:faith_mobile/core/art/artwork.dart';
import 'package:faith_mobile/core/theme/faith_palette.dart';
import 'package:faith_mobile/core/theme/faith_theme_extension.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/illustrated_empty_state.dart';
import 'package:faith_mobile/shared/widgets/mascot_view.dart';
import 'package:faith_mobile/shared/widgets/illustrated_header.dart';
import 'package:faith_mobile/shared/widgets/poppy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldens for the two widgets that carry artwork, in both faiths and both
/// themes.
///
/// Scoped to the illustration-bearing widgets rather than to whole screens on
/// purpose: these assert exactly what this change introduced — that a motif
/// resolves per faith, that the scrim lands correctly on the cream ground and
/// on the near-black one — without taking on a maintenance surface of
/// full-screen goldens that every unrelated copy edit would then invalidate.
void main() {
  const phone = Size(390, 844);

  void useViewport(WidgetTester tester, Size size) {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  /// Decodes every artwork asset into the global image cache.
  ///
  /// Run **before** any themed widget is pumped, and deliberately not via a
  /// `runAsync` wrapped around the live tree: `AppTheme` builds its text
  /// theme through GoogleFonts, `flutter_test_config.dart` sets
  /// `allowRuntimeFetching = false`, and letting real async run while those
  /// futures are pending surfaces font-load failures that arrive *after the
  /// test completes* — uncatchable by `takeException`. Warming the cache up
  /// front keeps the only real async work in a window where no font future
  /// exists yet.
  ///
  /// `ArtworkPanel` passes no `cacheWidth`, so the provider in the tree is a
  /// plain `AssetImage` and these cache entries are the ones it hits — which
  /// makes `wasSynchronouslyLoaded` true and the artwork present in the very
  /// first frame.
  Future<void> warmArtwork(WidgetTester tester) async {
    final keys = <String>{
      for (final faith in FaithId.values)
        for (final slot in ArtSlot.values) artworkFor(faith, slot)!.assetKey,
    };

    await tester.runAsync(() async {
      for (final key in keys) {
        final completer = Completer<void>();
        final stream = AssetImage(key).resolve(ImageConfiguration.empty);
        late final ImageStreamListener listener;
        listener = ImageStreamListener(
          (_, _) {
            stream.removeListener(listener);
            if (!completer.isCompleted) completer.complete();
          },
          onError: (error, _) {
            stream.removeListener(listener);
            if (!completer.isCompleted) completer.completeError(error);
          },
        );
        stream.addListener(listener);
        await completer.future;
      }
    });
  }

  /// Takes a *builder*, not a widget. `AppTheme` touches GoogleFonts the
  /// moment it is constructed, so passing an already-built widget would start
  /// those font futures before [warmArtwork] runs and put us straight back
  /// into the uncatchable post-test font failure. Building after the warm-up
  /// keeps that ordering honest.
  Future<void> pumpWithArtwork(
    WidgetTester tester,
    Widget Function() build,
  ) async {
    useViewport(tester, phone);
    await warmArtwork(tester);
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
  }

  /// A minimal theme carrying the real [FaithPalette] and
  /// [FaithThemeExtension], but **not** built through [AppTheme].
  ///
  /// `AppTheme` composes its text theme with GoogleFonts, which starts font
  /// load futures the moment it is constructed. `flutter_test_config.dart`
  /// sets `allowRuntimeFetching = false`, so those futures are doomed, and
  /// `matchesGoldenFile` performs real file I/O that lets them resolve
  /// mid-comparison — surfacing as "thrown after the test had completed",
  /// which `takeException` cannot reach and which fails the test for a reason
  /// that has nothing to do with the pixels.
  ///
  /// What these goldens exist to protect is the illustration layer: that a
  /// motif resolves per faith, that it is clipped and laid out correctly, and
  /// that the scrim — mixed from `palette.surfaceCard` — lands right on both
  /// the cream ground and the near-black one. All of that comes from the
  /// palette and the extension, both of which are the real ones here. Glyph
  /// shapes were never asserted by this harness anyway: the project disables
  /// font fetching precisely because it accepts fallback glyphs in goldens.
  Widget host({
    required FaithId faith,
    required Brightness brightness,
    required Widget child,
  }) {
    final palette = FaithPalette.of(faith, brightness);
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: palette.surface,
        colorScheme: base.colorScheme.copyWith(
          brightness: brightness,
          primary: palette.primary,
          surface: palette.surface,
          onSurface: palette.ink,
          onSurfaceVariant: palette.inkMuted,
          outline: palette.outline,
        ),
        textTheme: base.textTheme.apply(
          bodyColor: palette.ink,
          displayColor: palette.ink,
        ),
        extensions: [FaithThemeExtension.of(faith, palette)],
      ),
      home: Scaffold(
        body: Center(
          child: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }

  String suffix(Brightness b) => b == Brightness.light ? '' : '_dark';

  group('IllustratedHeader', () {
    for (final faith in FaithId.values) {
      for (final brightness in Brightness.values) {
        testWidgets('${faith.name}${suffix(brightness)}', (tester) async {
          await pumpWithArtwork(
            tester,
            () => host(
              faith: faith,
              brightness: brightness,
              child: const IllustratedHeader(
                title: 'Practice',
                subtitle: 'Tend your practice.',
                slot: ArtSlot.practiceHero,
              ),
            ),
          );

          await expectLater(
            find.byType(IllustratedHeader),
            matchesGoldenFile(
              'goldens/illustrated_header_${faith.name}${suffix(brightness)}.png',
            ),
          );
        });
      }
    }
  });

  group('IllustratedEmptyState', () {
    for (final faith in FaithId.values) {
      for (final brightness in Brightness.values) {
        testWidgets('${faith.name}${suffix(brightness)}', (tester) async {
          await pumpWithArtwork(
            tester,
            () => host(
              faith: faith,
              brightness: brightness,
              child: IllustratedEmptyState(
                title: 'A quiet month',
                message: 'No major events this month.',
                slot: ArtSlot.emptyDormant,
                action: PoppyButton(label: 'Browse', onPressed: () {}),
              ),
            ),
          );

          await expectLater(
            find.byType(IllustratedEmptyState),
            matchesGoldenFile(
              'goldens/illustrated_empty_${faith.name}${suffix(brightness)}.png',
            ),
          );
        });
      }
    }
  });

  // `encourage` is now the mascot on every "go and do something" empty state,
  // so it needs looking at. It repeats forever, which rules out
  // `pumpAndSettle` — bounded pumps instead, the convention already used by
  // faith_selection_screen_test.dart and mascot_view_test.dart.
  group('IllustratedEmptyState, encouraging', () {
    for (final faith in FaithId.values) {
      for (final brightness in Brightness.values) {
        testWidgets('${faith.name}${suffix(brightness)}', (tester) async {
          useViewport(tester, phone);
          await warmArtwork(tester);
          await tester.pumpWidget(
            host(
              faith: faith,
              brightness: brightness,
              child: const IllustratedEmptyState(
                title: 'No bookmarks yet',
                message: 'Tap any ayah to bookmark it.',
                slot: ArtSlot.emptyBookmarks,
                mascot: MascotState.encourage,
              ),
            ),
          );
          // Lands the first frame of the repeating animation at a fixed
          // point, so the golden is deterministic rather than a race.
          await tester.pump(const Duration(milliseconds: 50));

          await expectLater(
            find.byType(IllustratedEmptyState),
            matchesGoldenFile(
              'goldens/illustrated_empty_encourage_'
              '${faith.name}${suffix(brightness)}.png',
            ),
          );
        });
      }
    }
  });

  group('artwork actually rendered', () {
    // Guards the goldens themselves: a blank-rectangle regression (asset
    // renamed, directory dropped from pubspec, decode failing) would still
    // match a golden recorded from the same blank state, so assert
    // independently that a real image is in the tree.
    for (final faith in FaithId.values) {
      testWidgets('${faith.name} header paints a decoded image', (
        tester,
      ) async {
        await pumpWithArtwork(
          tester,
          () => host(
            faith: faith,
            brightness: Brightness.light,
            child: const IllustratedHeader(
              title: 'Practice',
              subtitle: 'Tend your practice.',
              slot: ArtSlot.practiceHero,
            ),
          ),
        );

        final images = tester.widgetList<Image>(find.byType(Image));
        expect(images, hasLength(1));
        final provider = images.single.image;
        expect(
          provider,
          isA<AssetImage>().having(
            (a) => a.assetName,
            'assetName',
            startsWith('assets/art/${faith.name}/'),
          ),
        );
      });
    }
  });
}
