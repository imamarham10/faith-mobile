import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/theme/faith_id.dart';
import '../../data/collections_repository.dart';
import '../../data/dtos/curated_collection.dart';

part 'collections_controller.g.dart';

/// Every curated collection for a faith, in the server's order.
///
/// `keepAlive` because four surfaces read it — Today, the Qur'an tab, the
/// Scripture tab and Practice — and they must share one fetch. An
/// auto-disposed provider would re-request the list on every tab switch,
/// which on a `max: 10` serverless pool is exactly the kind of avoidable
/// traffic the below-the-fold gate exists to remove.
///
/// Keyed by faith rather than reading `selectedFaithProvider` here: the
/// screens already branch on faith before they get this far, and a family
/// keeps the two verticals' lists from evicting each other on a switch.
@Riverpod(keepAlive: true)
Future<List<CuratedCollection>> collections(Ref ref, FaithId faith) {
  return ref.watch(collectionsRepositoryProvider).getCollections(faith);
}

/// The collections the database says belong on the Today dashboard.
///
/// A filter over [collections] and not a second request — `showOnHome` is
/// served on the same list payload, so featuring is free once the list is
/// in hand, and Today, Practice and the scripture tabs still share the one
/// fetch.
///
/// The order is the server's, untouched: the list arrives sorted by
/// `sortOrder` ascending and `where` preserves it. There is deliberately no
/// client-side re-sort and no client-side clock — the dashboard used to
/// decide for itself that the nightly set belonged there between 19:00 and
/// 03:59, and that rule is gone rather than layered under this flag.
///
/// An empty result is an ordinary state, not a failure: most collections
/// are not featured, and a faith may legitimately feature none.
@Riverpod(keepAlive: true)
Future<List<CuratedCollection>> homeCollections(Ref ref, FaithId faith) async {
  final all = await ref.watch(collectionsProvider(faith).future);
  return all.where((c) => c.showOnHome).toList(growable: false);
}

/// One collection with its items resolved — the collection screen's source.
///
/// Auto-disposed, unlike the list. The detail payload carries every item's
/// scripture inline (≈196 KB for the six-item nightly set), and holding
/// that for the life of the process to save a request the user makes once
/// per visit is the wrong trade.
@riverpod
Future<CuratedCollection> collectionDetail(
  Ref ref,
  FaithId faith,
  String slug,
) {
  return ref.watch(collectionsRepositoryProvider).getCollection(faith, slug);
}
