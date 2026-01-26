import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/reminder_card.dart';
import '../../widgets/loading_overlay.dart';

/// Reminders list screen
class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    await ref.read(remindersProvider.notifier).loadReminders();
  }

  Future<void> _completeReminder(int id) async {
    try {
      await ref.read(remindersProvider.notifier).completeReminder(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder completed!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _snoozeReminder(int id) async {
    final duration = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Snooze Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('1 hour'),
              onTap: () => Navigator.of(context).pop('1h'),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('3 hours'),
              onTap: () => Navigator.of(context).pop('3h'),
            ),
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Tomorrow'),
              onTap: () => Navigator.of(context).pop('1d'),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Next week'),
              onTap: () => Navigator.of(context).pop('1w'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (duration != null) {
      try {
        await ref.read(remindersProvider.notifier).snoozeReminder(id, duration);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reminder snoozed!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(remindersProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);
    final todayReminders = ref.watch(todayRemindersProvider);
    final pendingReminders = ref.watch(pendingRemindersProvider);

    // Group reminders by category
    final upcomingReminders = pendingReminders
        .where((r) =>
            !DateTimeUtils.isOverdue(r.dueAt) && !DateTimeUtils.isToday(r.dueAt))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          if (overdueReminders.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text(overdueReminders.length.toString()),
                child: const Icon(Icons.warning_amber_outlined),
              ),
              onPressed: () {
                // Scroll to overdue section
              },
            ),
        ],
      ),
      body: state.isLoading && state.reminders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.reminders.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadReminders,
                  child: CustomScrollView(
                    slivers: [
                      // Overdue section
                      if (overdueReminders.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Container(
                            color: AppTheme.errorColor.withValues(alpha: 0.1),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_outlined,
                                  color: AppTheme.errorColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Overdue (${overdueReminders.length})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.errorColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final reminder = overdueReminders[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ReminderCard(
                                    reminder: reminder,
                                    onComplete: () =>
                                        _completeReminder(reminder.id),
                                    onSnooze: () => _snoozeReminder(reminder.id),
                                    onTap: () {},
                                  ),
                                );
                              },
                              childCount: overdueReminders.length,
                            ),
                          ),
                        ),
                      ],

                      // Today section
                      if (todayReminders.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.today,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Today (${todayReminders.length})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final reminder = todayReminders[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ReminderCard(
                                    reminder: reminder,
                                    onComplete: () =>
                                        _completeReminder(reminder.id),
                                    onSnooze: () => _snoozeReminder(reminder.id),
                                    onTap: () {},
                                  ),
                                );
                              },
                              childCount: todayReminders.length,
                            ),
                          ),
                        ),
                      ],

                      // Upcoming section
                      if (upcomingReminders.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Upcoming (${upcomingReminders.length})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final reminder = upcomingReminders[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ReminderCard(
                                    reminder: reminder,
                                    onComplete: () =>
                                        _completeReminder(reminder.id),
                                    onSnooze: () => _snoozeReminder(reminder.id),
                                    onTap: () {},
                                  ),
                                );
                              },
                              childCount: upcomingReminders.length,
                            ),
                          ),
                        ),
                      ],

                      // Completed section toggle
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Toggle showing completed reminders
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              'Show Completed (${state.reminders.where((r) => r.status == 'completed').length})',
                            ),
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 80),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateReminderSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No reminders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create reminders to stay on top of your job search',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateReminderSheet(),
            icon: const Icon(Icons.add),
            label: const Text('Add Reminder'),
          ),
        ],
      ),
    );
  }

  void _showCreateReminderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateReminderSheet(),
    );
  }
}

/// Create reminder bottom sheet
class _CreateReminderSheet extends ConsumerStatefulWidget {
  const _CreateReminderSheet();

  @override
  ConsumerState<_CreateReminderSheet> createState() =>
      _CreateReminderSheetState();
}

class _CreateReminderSheetState extends ConsumerState<_CreateReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedApplicationId;
  String _reminderType = 'follow_up';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _dueTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dueAt = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _dueTime.hour,
        _dueTime.minute,
      );

      final request = CreateReminderRequest(
        title: _titleController.text.trim(),
        reminderType: _reminderType,
        dueAt: dueAt,
        applicationId: _selectedApplicationId != null
            ? int.parse(_selectedApplicationId!)
            : null,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      await ref.read(remindersProvider.notifier).createReminder(request);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder created!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationsState = ref.watch(applicationsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'New Reminder',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title *',
                          prefixIcon: Icon(Icons.notifications_outlined),
                          hintText: 'e.g., Follow up with Google',
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Reminder type
                      DropdownButtonFormField<String>(
                        value: _reminderType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: ReminderType.values.map((type) {
                          return DropdownMenuItem(
                            value: type.value,
                            child: Row(
                              children: [
                                Icon(type.icon, size: 20, color: type.color),
                                const SizedBox(width: 8),
                                Text(type.label),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _reminderType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Application (optional)
                      DropdownButtonFormField<String>(
                        value: _selectedApplicationId,
                        decoration: const InputDecoration(
                          labelText: 'Related Application (Optional)',
                          prefixIcon: Icon(Icons.work_outline),
                        ),
                        hint: const Text('Select an application'),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('None'),
                          ),
                          ...applicationsState.applications.map((app) {
                            return DropdownMenuItem(
                              value: app.id.toString(),
                              child: Text('${app.jobTitle} at ${app.companyName}'),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedApplicationId = value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date and time
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _dueDate,
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _dueDate = date);
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                '${_dueDate.month}/${_dueDate.day}/${_dueDate.year}',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: _dueTime,
                                );
                                if (time != null) {
                                  setState(() => _dueTime = time);
                                }
                              },
                              icon: const Icon(Icons.access_time),
                              label: Text(_dueTime.format(context)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (Optional)',
                          hintText: 'Add any additional notes...',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Reminder'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
