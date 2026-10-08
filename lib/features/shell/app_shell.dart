import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/preferences/selected_faith.dart';
import '../../core/theme/faith_id.dart';

/// Hosts the five primary tabs and preserves their navigation stacks
/// independently via [StatefulShellRoute.indexedStack]. Tabs 2 and 3 swap
/// icon/label by active faith; tab content itself is routed per-faith
/// inside each branch (see app_router.dart).
///
/// That per-branch stack preservation is also why this widget owns faith
/// invalidation: when the faith changes, every branch still holds whatever
/// the previous faith pushed onto it, and go_router has no API to rewrite a
/// branch that isn't the current one (`StatefulNavigationShellState`
/// refreshes only `widget.currentIndex` on each rebuild). So each branch is
/// marked stale and rerouted to its root the moment before it becomes
/// visible — see [_markEveryBranchStale].
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Last faith this shell observed. Stays null until the async
  /// [selectedFaithProvider] first resolves, so a cold start — and the
  /// `loading -> data` transition it ends with — is never mistaken for a
  /// switch.
  FaithId? _lastFaith;

  /// Branch indices still holding routes pushed under a previous faith.
  final Set<int> _staleBranches = <int>{};

  /// Branch rendered on the previous build, used to spot a branch that was
  /// entered by something other than this shell. See [_build].
  int? _lastIndex;

  GoRouter? _router;
  bool _resetScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The visible branch can only be reset once the shell is back on top of
    // the root navigator (the faith picker stacks above it), and popping
    // those pages doesn't necessarily rebuild this widget — so listen to the
    // router itself for the moment the stack unwinds.
    final router = GoRouter.of(context);
    if (!identical(router, _router)) {
      _router?.routerDelegate.removeListener(_handleRouteChanged);
      _router = router..routerDelegate.addListener(_handleRouteChanged);
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_handleRouteChanged);
    super.dispose();
  }

  void _handleRouteChanged() => _scheduleStaleBranchReset();

  void _markEveryBranchStale() {
    final branchCount = widget.navigationShell.route.branches.length;
    _staleBranches.addAll(List<int>.generate(branchCount, (i) => i));
  }

  /// Defers the reset to after the current frame: this runs from `build` and
  /// from router notifications, and `goBranch` navigates.
  void _scheduleStaleBranchReset() {
    if (_resetScheduled) return;
    _resetScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetScheduled = false;
      if (!mounted) return;
      _resetVisibleBranchIfStale();
    });
  }

  void _resetVisibleBranchIfStale() {
    final index = widget.navigationShell.currentIndex;
    if (!_staleBranches.contains(index)) return;
    // Resetting the visible branch replaces the whole route match list, so
    // it would tear down the faith picker / settings pages stacked above
    // this shell. Wait until they're gone.
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
    _staleBranches.remove(index);
    widget.navigationShell.goBranch(index, initialLocation: true);
  }

  void _onTap(int index) {
    final wasStale = _staleBranches.remove(index);
    if (index == widget.navigationShell.currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    HapticFeedback.selectionClick();
    widget.navigationShell.goBranch(index, initialLocation: wasStale);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedFaith = ref.watch(selectedFaithProvider).valueOrNull;
    if (resolvedFaith != null) {
      if (_lastFaith != null && _lastFaith != resolvedFaith) {
        _markEveryBranchStale();
      }
      _lastFaith = resolvedFaith;
    }
    // Every path this shell controls drops a branch from [_staleBranches]
    // *before* navigating to it, so a branch that becomes current while
    // still marked stale was entered from outside — a deep link or a
    // notification tap, which builds a fresh stack of its own. Nothing to
    // reset, and resetting anyway would bounce the user off the very
    // screen they were sent to.
    final index = widget.navigationShell.currentIndex;
    if (_lastIndex != null && _lastIndex != index) {
      _staleBranches.remove(index);
    }
    _lastIndex = index;

    _scheduleStaleBranchReset();

    final faith = resolvedFaith ?? FaithId.islam;
    final (tab2Icon, tab2SelectedIcon, tab2Label) = switch (faith) {
      FaithId.islam => (
        Icons.menu_book_outlined,
        Icons.menu_book,
        'Quran',
      ),
      FaithId.hindu => (
        Icons.auto_stories_outlined,
        Icons.auto_stories,
        'Scripture',
      ),
    };
    final (tab3Icon, tab3SelectedIcon, tab3Label) = switch (faith) {
      FaithId.islam => (
        Icons.history_edu_outlined,
        Icons.history_edu,
        'Hadiths',
      ),
      FaithId.hindu => (
        Icons.temple_hindu_outlined,
        Icons.temple_hindu,
        'Stories',
      ),
    };

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.wb_twilight_outlined),
            selectedIcon: Icon(Icons.wb_twilight),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(tab2Icon),
            selectedIcon: Icon(tab2SelectedIcon),
            label: tab2Label,
          ),
          NavigationDestination(
            icon: Icon(tab3Icon),
            selectedIcon: Icon(tab3SelectedIcon),
            label: tab3Label,
          ),
          const NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa),
            label: 'Practice',
          ),
          const NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined),
            selectedIcon: Icon(Icons.self_improvement),
            label: 'Reflect',
          ),
        ],
      ),
    );
  }
}
