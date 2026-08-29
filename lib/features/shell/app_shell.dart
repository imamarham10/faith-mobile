import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/preferences/selected_faith.dart';
import '../../core/theme/faith_id.dart';

/// Hosts the five primary tabs and preserves their navigation stacks
/// independently via [StatefulShellRoute.indexedStack]. Tabs 2 and 3 swap
/// icon/label by active faith; tab content itself is routed per-faith
/// inside each branch (see app_router.dart) once Hindu routes exist —
/// until then both faiths' tab 2/3 show the existing Islam content.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    if (index == navigationShell.currentIndex) {
      navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    HapticFeedback.selectionClick();
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faith = ref.watch(selectedFaithProvider).valueOrNull ?? FaithId.islam;
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
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
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
