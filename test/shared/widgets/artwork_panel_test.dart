import 'package:faith_mobile/core/art/artwork.dart';
import 'package:faith_mobile/core/theme/app_theme.dart';
import 'package:faith_mobile/core/theme/faith_id.dart';
import 'package:faith_mobile/shared/widgets/artwork_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Base for the fake bundles: only artwork keys are interfered with.
///
/// Flutter also pulls `AssetManifest.bin` through the same bundle to resolve
/// asset variants, and failing that changes the failure mode under test, so
/// everything outside `assets/art/` is delegated to the real bundle.
abstract class _ArtOnlyBundle extends CachingAssetBundle {
  Future<ByteData> loadArt(String key);

  @override
  Future<ByteData> load(String key) =>
      key.startsWith('assets/art/') ? loadArt(key) : rootBundle.load(key);
}

/// Every artwork load fails — the asset is absent from the bundle.
///
/// `Image.asset` resolves through `DefaultAssetBundle.of(context)`, so
/// wrapping the subtree in one of these drives the real `errorBuilder` path
/// rather than a mocked approximation of it.
class _BrokenAssetBundle extends _ArtOnlyBundle {
  @override
  Future<ByteData> loadArt(String key) async =>
      throw FlutterError('asset missing: $key');
}

/// Returns bytes that are not a decodable image — the corrupt-file case,
/// which fails later in the pipeline than a missing one.
class _CorruptAssetBundle extends _ArtOnlyBundle {
  @override
  Future<ByteData> loadArt(String key) async =>
      ByteData.view(Uint8List.fromList(List.filled(64, 0x7F)).buffer);
}

void main() {
  Widget host({
    required FaithId faith,
    required Widget child,
    AssetBundle? bundle,
  }) {
    final app = MaterialApp(
      theme: AppTheme.light(faith),
      home: Scaffold(
        body: Center(child: SizedBox(width: 200, height: 100, child: child)),
      ),
    );
    return bundle == null
        ? app
        : DefaultAssetBundle(bundle: bundle, child: app);
  }

  group('fallback', () {
    testWidgets('a missing asset renders the fallback, not an exception', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          faith: FaithId.islam,
          bundle: _BrokenAssetBundle(),
          child: const ArtworkPanel(
            slot: ArtSlot.practiceHero,
            fallback: Text('fallback'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.text('fallback'), findsOneWidget);
    });

    testWidgets('a corrupt asset renders the fallback, not an exception', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          faith: FaithId.islam,
          bundle: _CorruptAssetBundle(),
          child: const ArtworkPanel(
            slot: ArtSlot.practiceHero,
            fallback: Text('fallback'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.text('fallback'), findsOneWidget);
    });

    testWidgets('a card around a failed asset still renders its own text', (
      tester,
    ) async {
      // The point of the whole fallback path: a decorative asset must never
      // be able to take the surrounding card down with it.
      await tester.pumpWidget(
        host(
          faith: FaithId.islam,
          bundle: _BrokenAssetBundle(),
          child: const Stack(
            children: [
              ArtworkPanel(slot: ArtSlot.practiceTile1),
              Positioned(left: 0, bottom: 0, child: Text('Dhikr')),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.text('Dhikr'), findsOneWidget);
    });

    testWidgets(
      'no fallback given means it renders nothing and still lays out',
      (tester) async {
        await tester.pumpWidget(
          host(
            faith: FaithId.hindu,
            bundle: _BrokenAssetBundle(),
            child: const ArtworkPanel(slot: ArtSlot.empty),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(tester.takeException(), isNull);
        expect(find.byType(ArtworkPanel), findsOneWidget);
      },
    );
  });

  group('faith resolution through the widget', () {
    // One test per faith rather than a loop inside one test: a second
    // `pumpWidget` in the same test re-resolves the previous faith's still
    // pending image against the new bundle, so the recorder would see both
    // faiths' keys and the assertion would be meaningless.
    for (final faith in FaithId.values) {
      testWidgets('${faith.name} asks its bundle for its own asset', (
        tester,
      ) async {
        final requested = <String>[];
        await tester.pumpWidget(
          host(
            faith: faith,
            bundle: _RecordingBundle(requested),
            child: const ArtworkPanel(slot: ArtSlot.practiceHero),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(
          requested,
          isNotEmpty,
          reason: '${faith.name} requested no asset at all',
        );
        expect(
          requested.every((k) => k.startsWith('assets/art/${faith.name}/')),
          isTrue,
          reason: '${faith.name} requested $requested',
        );
      });
    }

    testWidgets('an explicit faith overrides the themed one', (tester) async {
      final requested = <String>[];
      await tester.pumpWidget(
        host(
          // Theme says Islam...
          faith: FaithId.islam,
          bundle: _RecordingBundle(requested),
          // ...but the caller asked for Hindu.
          child: const ArtworkPanel(
            slot: ArtSlot.practiceHero,
            faith: FaithId.hindu,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(requested, isNotEmpty);
      expect(
        requested.every((k) => k.startsWith('assets/art/hindu/')),
        isTrue,
        reason: 'explicit faith was ignored: $requested',
      );
    });
  });
}

/// Records which keys were asked for, then fails them — the panel's output
/// is irrelevant here, only which faith's file it reached for.
class _RecordingBundle extends _ArtOnlyBundle {
  _RecordingBundle(this.requested);

  final List<String> requested;

  @override
  Future<ByteData> loadArt(String key) async {
    requested.add(key);
    throw FlutterError('asset missing: $key');
  }
}
