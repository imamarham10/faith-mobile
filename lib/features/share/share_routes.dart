import 'package:go_router/go_router.dart';

import 'domain/shareable_content.dart';
import 'presentation/screens/share_card_screen.dart';

/// `/share` lives outside the StatefulShellRoute — it's an overlay reachable
/// from any tab. The [ShareableContent] is passed via `state.extra` so we
/// stay agnostic to the caller's domain model.
final shareRoutes = <RouteBase>[
  GoRoute(
    path: '/share',
    builder: (_, state) {
      final extra = state.extra;
      final content = extra is ShareableContent
          ? extra
          : const ShareableContent(
              eyebrow: 'Siraat',
              title: 'Nothing to share',
            );
      return ShareCardScreen(content: content);
    },
  ),
];
