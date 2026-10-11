import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/faith_id.dart';
import '../../../../shared/widgets/gap.dart';
import '../../../../shared/widgets/section_label.dart';
import '../controllers/collections_controller.dart';
import 'collection_card.dart';

/// The collections the database has featured, on the Today dashboard.
///
/// ## Every unsettled state renders nothing
///
/// Loading, error and empty all draw [SizedBox.shrink], and so does the
/// heading — there is no skeleton and no orphaned label.
///
/// That is a deliberate divergence from Today's other cards, which all show
/// a shimmer while they load. A verse of the day is *always* there, so a
/// skeleton is an honest promise of a thing that is coming. A featured
/// collection may legitimately not exist: most collections are not
/// featured, and a faith may feature none. A skeleton that resolves to
/// nothing is a lie, and this rail sits directly above the goal card —
/// the worst place on the screen to reserve space for something that may
/// never arrive. So it occupies zero pixels until it has something to say.
///
/// An error renders nothing for the same reason, with no retry: this is a
/// discovery surface the user did not ask for, and a failure banner above
/// their goal card is noise about a request they never made. The retry
/// lives where someone went looking for collections on purpose — the
/// Qur'an/Scripture tab, Practice, and the collection screen.
///
/// ## Height does not grow with the list
///
/// A horizontal rail, not a column. Three or four featured collections
/// must not push the goal card down the screen, so the extras are reached
/// sideways and the vertical cost is the same whether the database
/// features one or six.
///
/// ## Order
///
/// The server's, untouched — `sortOrder` ascending, as
/// `homeCollectionsProvider` received it. Nothing here re-sorts, and
/// nothing here consults the clock; which collections are featured, and in
/// what order, is the database's decision alone.
class CollectionsRail extends ConsumerWidget {
  const CollectionsRail({super.key, required this.faith});

  final FaithId faith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref
        .watch(homeCollectionsProvider(faith))
        .valueOrNull;

    if (collections == null || collections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      // Min, not the default max: a Column hands itself every pixel its
      // parent offers unless told otherwise, which inside a sliver is
      // invisible and anywhere else is a rail that swallows the screen.
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Collections'),
        const Gap(AppSpacing.md),
        SizedBox(
          height: CollectionTile.heightOf(context),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            // Zero inset: the rail's host already carries the screen edge,
            // and a second margin would start the first tile two in.
            padding: EdgeInsets.zero,
            itemCount: collections.length,
            separatorBuilder: (_, __) => const Gap.h(AppSpacing.md),
            itemBuilder: (_, i) => CollectionTile(collection: collections[i]),
          ),
        ),
        const Gap(AppSpacing.xl),
      ],
    );
  }
}
