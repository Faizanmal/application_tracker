import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/application.dart';
import '../../data/services/sync_service.dart';

/// Provider for selected applications
final selectedApplicationsProvider = StateProvider<Set<String>>((ref) => {});

/// Provider for selection mode
final selectionModeProvider = StateProvider<bool>((ref) => false);

/// Bulk actions widget for application list
class BulkActionsBar extends ConsumerWidget {
  final List<Application> applications;
  final VoidCallback? onClose;

  const BulkActionsBar({
    super.key,
    required this.applications,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedApplicationsProvider);
    final selectedCount = selectedIds.length;

    if (selectedCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    ref.read(selectedApplicationsProvider.notifier).state = {};
                    ref.read(selectionModeProvider.notifier).state = false;
                    onClose?.call();
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  '$selectedCount selected',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref.read(selectedApplicationsProvider.notifier).state =
                        applications.map((a) => a.id).toSet();
                  },
                  child: const Text('Select All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _BulkActionButton(
                    icon: Icons.edit,
                    label: 'Status',
                    onPressed: () => _showStatusDialog(context, ref, selectedIds),
                  ),
                  const SizedBox(width: 8),
                  _BulkActionButton(
                    icon: Icons.label,
                    label: 'Tags',
                    onPressed: () => _showTagsDialog(context, ref, selectedIds),
                  ),
                  const SizedBox(width: 8),
                  _BulkActionButton(
                    icon: Icons.archive,
                    label: 'Archive',
                    onPressed: () => _archiveSelected(context, ref, selectedIds),
                  ),
                  const SizedBox(width: 8),
                  _BulkActionButton(
                    icon: Icons.star,
                    label: 'Favorite',
                    onPressed: () => _favoriteSelected(context, ref, selectedIds),
                  ),
                  const SizedBox(width: 8),
                  _BulkActionButton(
                    icon: Icons.delete,
                    label: 'Delete',
                    color: Colors.red,
                    onPressed: () => _deleteSelected(context, ref, selectedIds),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, WidgetRef ref, Set<String> selectedIds) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _StatusSelectionSheet(
        onStatusSelected: (status) async {
          Navigator.pop(context);
          await _updateStatus(context, ref, selectedIds, status);
        },
      ),
    );
  }

  void _showTagsDialog(BuildContext context, WidgetRef ref, Set<String> selectedIds) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _TagSelectionSheet(
        onTagsSelected: (tags) async {
          Navigator.pop(context);
          await _updateTags(context, ref, selectedIds, tags);
        },
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    Set<String> selectedIds,
    ApplicationStatus status,
  ) async {
    // Queue bulk status update for sync
    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.queueOperation(
      operation: SyncOperation.update,
      entityType: 'bulk_status',
      entityId: 'bulk',
      data: {
        'ids': selectedIds.toList(),
        'status': status.name,
      },
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated ${selectedIds.length} applications to ${status.name}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    ref.read(selectedApplicationsProvider.notifier).state = {};
  }

  Future<void> _updateTags(
    BuildContext context,
    WidgetRef ref,
    Set<String> selectedIds,
    List<String> tags,
  ) async {
    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.queueOperation(
      operation: SyncOperation.update,
      entityType: 'bulk_tags',
      entityId: 'bulk',
      data: {
        'ids': selectedIds.toList(),
        'tags': tags,
      },
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated tags for ${selectedIds.length} applications'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    ref.read(selectedApplicationsProvider.notifier).state = {};
  }

  Future<void> _archiveSelected(
    BuildContext context,
    WidgetRef ref,
    Set<String> selectedIds,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Applications'),
        content: Text('Archive ${selectedIds.length} applications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.queueOperation(
      operation: SyncOperation.update,
      entityType: 'bulk_archive',
      entityId: 'bulk',
      data: {
        'ids': selectedIds.toList(),
        'archive': true,
      },
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Archived ${selectedIds.length} applications'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    ref.read(selectedApplicationsProvider.notifier).state = {};
  }

  Future<void> _favoriteSelected(
    BuildContext context,
    WidgetRef ref,
    Set<String> selectedIds,
  ) async {
    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.queueOperation(
      operation: SyncOperation.update,
      entityType: 'bulk_favorite',
      entityId: 'bulk',
      data: {
        'ids': selectedIds.toList(),
        'favorite': true,
      },
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Favorited ${selectedIds.length} applications'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    ref.read(selectedApplicationsProvider.notifier).state = {};
  }

  Future<void> _deleteSelected(
    BuildContext context,
    WidgetRef ref,
    Set<String> selectedIds,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Applications'),
        content: Text(
          'Are you sure you want to delete ${selectedIds.length} applications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.queueOperation(
      operation: SyncOperation.delete,
      entityType: 'bulk_delete',
      entityId: 'bulk',
      data: {
        'ids': selectedIds.toList(),
      },
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted ${selectedIds.length} applications'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    ref.read(selectedApplicationsProvider.notifier).state = {};
  }
}

class _BulkActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _BulkActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _StatusSelectionSheet extends StatelessWidget {
  final Function(ApplicationStatus) onStatusSelected;

  const _StatusSelectionSheet({required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Status',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ApplicationStatus.values.map((status) {
              return ChoiceChip(
                label: Text(_formatStatus(status)),
                selected: false,
                onSelected: (_) => onStatusSelected(status),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatStatus(ApplicationStatus status) {
    return status.name.replaceAll('_', ' ').toUpperCase();
  }
}

class _TagSelectionSheet extends StatefulWidget {
  final Function(List<String>) onTagsSelected;

  const _TagSelectionSheet({required this.onTagsSelected});

  @override
  State<_TagSelectionSheet> createState() => _TagSelectionSheetState();
}

class _TagSelectionSheetState extends State<_TagSelectionSheet> {
  final _controller = TextEditingController();
  final _tags = <String>[];
  final _availableTags = [
    'High Priority',
    'Follow Up',
    'Remote',
    'Startup',
    'Enterprise',
    'Tech',
    'Finance',
    'Healthcare',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Tags',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Add custom tag',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      _tags.add(_controller.text);
                      _controller.clear();
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._availableTags.map((tag) => FilterChip(
                    label: Text(tag),
                    selected: _tags.contains(tag),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _tags.add(tag);
                        } else {
                          _tags.remove(tag);
                        }
                      });
                    },
                  )),
              ..._tags
                  .where((t) => !_availableTags.contains(t))
                  .map((tag) => Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() => _tags.remove(tag));
                        },
                      )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => widget.onTagsSelected(_tags),
                child: const Text('Apply Tags'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Selectable application card wrapper
class SelectableApplicationCard extends ConsumerWidget {
  final Widget child;
  final String applicationId;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SelectableApplicationCard({
    super.key,
    required this.child,
    required this.applicationId,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedApplicationsProvider);
    final selectionMode = ref.watch(selectionModeProvider);
    final isSelected = selectedIds.contains(applicationId);

    return GestureDetector(
      onTap: () {
        if (selectionMode) {
          _toggleSelection(ref);
        } else {
          onTap?.call();
        }
      },
      onLongPress: () {
        if (!selectionMode) {
          ref.read(selectionModeProvider.notifier).state = true;
          _toggleSelection(ref);
        }
        onLongPress?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Stack(
          children: [
            child,
            if (selectionMode)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleSelection(WidgetRef ref) {
    final selectedIds = ref.read(selectedApplicationsProvider);
    final newSet = Set<String>.from(selectedIds);
    
    if (newSet.contains(applicationId)) {
      newSet.remove(applicationId);
    } else {
      newSet.add(applicationId);
    }
    
    ref.read(selectedApplicationsProvider.notifier).state = newSet;

    // Exit selection mode if nothing selected
    if (newSet.isEmpty) {
      ref.read(selectionModeProvider.notifier).state = false;
    }
  }
}
