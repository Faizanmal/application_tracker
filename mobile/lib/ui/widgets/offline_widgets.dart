import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/services/sync_service.dart';

/// Connectivity status provider
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Offline indicator widget
class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);

    if (syncState.isOnline && syncState.pendingCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: syncState.isOnline ? Colors.blue.shade100 : Colors.orange.shade100,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              syncState.isOnline ? Icons.sync : Icons.wifi_off,
              size: 16,
              color: syncState.isOnline ? Colors.blue.shade700 : Colors.orange.shade700,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                syncState.isOnline
                    ? 'Syncing ${syncState.pendingCount} changes...'
                    : 'You are offline. ${syncState.pendingCount} changes pending.',
                style: TextStyle(
                  fontSize: 12,
                  color: syncState.isOnline
                      ? Colors.blue.shade700
                      : Colors.orange.shade700,
                ),
              ),
            ),
            if (syncState.isOnline && syncState.status == SyncStatus.syncing)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (syncState.isOnline)
              TextButton(
                onPressed: () async {
                  await ref.read(syncServiceProvider.notifier).sync();
                },
                child: const Text('Sync Now'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Sync status badge
class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);

    if (syncState.pendingCount == 0) {
      return const SizedBox.shrink();
    }

    return Badge(
      label: Text('${syncState.pendingCount}'),
      backgroundColor: syncState.isOnline ? Colors.blue : Colors.orange,
      child: Icon(
        syncState.isOnline ? Icons.sync : Icons.sync_disabled,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Sync status detailed view
class SyncStatusView extends ConsumerWidget {
  const SyncStatusView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _StatusIcon(syncState),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(syncState),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        _getStatusDescription(syncState),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (syncState.pendingCount > 0) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: syncState.status == SyncStatus.syncing ? null : 0,
              ),
              const SizedBox(height: 8),
              Text(
                '${syncState.pendingCount} changes pending',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (syncState.lastResult != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Last sync: ${_formatTime(syncState.lastSyncTime)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (syncState.lastResult!.successful > 0)
                Text(
                  '${syncState.lastResult!.successful} items synced successfully',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                ),
              if (syncState.lastResult!.failed > 0)
                Text(
                  '${syncState.lastResult!.failed} items failed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                      ),
                ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (syncState.pendingCount > 0)
                  TextButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear Pending Changes'),
                          content: const Text(
                            'Are you sure you want to discard all pending changes? This cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Discard'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref.read(syncServiceProvider.notifier).clearQueue();
                      }
                    },
                    child: const Text('Clear Queue'),
                  ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: syncState.isOnline &&
                          syncState.status != SyncStatus.syncing
                      ? () async {
                          await ref.read(syncServiceProvider.notifier).sync();
                        }
                      : null,
                  child: syncState.status == SyncStatus.syncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sync Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusTitle(SyncState state) {
    if (!state.isOnline) return 'Offline';
    switch (state.status) {
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.completed:
        return 'Synced';
      case SyncStatus.failed:
        return 'Sync Failed';
      default:
        return state.pendingCount > 0 ? 'Changes Pending' : 'Up to Date';
    }
  }

  String _getStatusDescription(SyncState state) {
    if (!state.isOnline) {
      return 'Changes will sync when you\'re back online';
    }
    switch (state.status) {
      case SyncStatus.syncing:
        return 'Uploading your changes...';
      case SyncStatus.completed:
        return 'All changes have been saved';
      case SyncStatus.failed:
        return 'Some changes could not be saved';
      default:
        if (state.pendingCount > 0) {
          return 'Tap Sync Now to upload changes';
        }
        return 'All your data is synchronized';
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return 'Never';
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _StatusIcon extends StatelessWidget {
  final SyncState state;

  const _StatusIcon(this.state);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (!state.isOnline) {
      icon = Icons.wifi_off;
      color = Colors.orange;
    } else {
      switch (state.status) {
        case SyncStatus.syncing:
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        case SyncStatus.completed:
          icon = Icons.check_circle;
          color = Colors.green;
          break;
        case SyncStatus.failed:
          icon = Icons.error;
          color = Colors.red;
          break;
        default:
          icon = state.pendingCount > 0 ? Icons.sync : Icons.cloud_done;
          color = state.pendingCount > 0 ? Colors.blue : Colors.green;
      }
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }
}

/// Offline-aware list tile
class OfflineAwareListTile extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isPending;

  const OfflineAwareListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: leading,
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (isPending)
            Icon(
              Icons.sync,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// Pull to refresh with sync
class SyncableRefreshIndicator extends ConsumerWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const SyncableRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        final syncService = ref.read(syncServiceProvider.notifier);
        
        // First sync any pending changes
        await syncService.sync();
        
        // Then refresh data
        await onRefresh();
      },
      child: child,
    );
  }
}
