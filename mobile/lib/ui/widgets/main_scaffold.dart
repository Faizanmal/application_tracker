import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quick_add.dart';
import 'offline_widgets.dart';
import '../../data/services/sync_service.dart';

/// Main scaffold with bottom navigation
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == '/') return 0;
    if (location.startsWith('/applications')) return 1;
    if (location.startsWith('/interviews')) return 2;
    if (location.startsWith('/reminders')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/applications');
        break;
      case 2:
        context.go('/interviews');
        break;
      case 3:
        context.go('/reminders');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _calculateSelectedIndex(context);
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      body: SyncableRefreshIndicator(
        onRefresh: () => ref.read(syncProvider.notifier).sync(),
        child: Stack(
          children: [
            child,
            // Sync status indicator
            if (syncState.pendingCount > 0)
              Positioned(
                bottom: 16,
                left: 16,
                child: SyncStatusBadge(
                  onTap: () => _showSyncStatus(context, ref),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Interviews',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: const QuickAddFAB(),
    );
  }

  void _showSyncStatus(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SyncStatusView(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(syncProvider.notifier).sync();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.sync),
                label: const Text('Sync Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
