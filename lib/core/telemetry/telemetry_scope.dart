/// Binds `screen_view` to go_router without ever letting a route path
/// reach Google.
///
/// ## Why not `FirebaseAnalyticsObserver`
///
/// The plugin ships a `NavigatorObserver` that names each screen after the
/// route that produced it, and Firebase's Android SDK has an automatic
/// version of the same thing. Either one, pointed at this app, sends
/// `screen_name = "/reflect/feelings/grieving"` the moment a user picks an
/// emotion. That is the single most sensitive value Siraat holds, leaving
/// the device automatically, through a code path no reviewer ever reads.
///
/// So neither is used. The automatic one is switched off in
/// `AndroidManifest.xml`
/// (`google_analytics_automatic_screen_reporting_enabled = false`), the
/// observer is not installed, and screens are logged here instead —
/// through [screenForLocation], which maps a path to a compile-time
/// constant and never echoes its input.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'telemetry.dart';
import 'telemetry_vocabulary.dart';

/// A side-effect carrier that renders [child] verbatim — the same shape as
/// `ActivityFlushScope`, which it sits beside in `main.dart`.
///
/// Costs one `addListener` at mount and nothing per frame.
class TelemetryScope extends ConsumerStatefulWidget {
  const TelemetryScope({required this.router, required this.child, super.key});

  final GoRouter router;
  final Widget child;

  @override
  ConsumerState<TelemetryScope> createState() => _TelemetryScopeState();
}

class _TelemetryScopeState extends ConsumerState<TelemetryScope> {
  AnalyticsScreen? _last;

  @override
  void initState() {
    super.initState();
    widget.router.routerDelegate.addListener(_onRouteChanged);
    // The first screen never fires a change notification — the delegate is
    // already sitting on it by the time this mounts.
    _onRouteChanged();
  }

  @override
  void didUpdateWidget(TelemetryScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.router, widget.router)) {
      oldWidget.router.routerDelegate.removeListener(_onRouteChanged);
      widget.router.routerDelegate.addListener(_onRouteChanged);
    }
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    final matches = widget.router.routerDelegate.currentConfiguration;
    if (matches.isEmpty) return;

    // `uri.path` only. The query string is dropped before matching anyway
    // (see `screenForLocation`), but taking the path here keeps the
    // narrowest thing that can be read from the router in the first place.
    final screen = screenForLocation(matches.uri.path);

    // A route with no mapping sends nothing. That is the deliberate
    // default: a screen added later is invisible until someone names it,
    // rather than leaking whatever its path happens to contain.
    if (screen == null || screen == _last) return;
    _last = screen;
    Telemetry.instance.analytics.screenViewed(screen);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
