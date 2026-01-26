import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/models.dart';

/// Reminder card widget
class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onSnooze;

  const ReminderCard({
    super.key,
    required this.reminder,
    this.onTap,
    this.onComplete,
    this.onSnooze,
  });

  @override
  Widget build(BuildContext context) {
    final type = ReminderType.fromValue(reminder.reminderType);
    final isOverdue = reminder.status == 'pending' &&
        reminder.dueAt.isBefore(DateTime.now());
    final isCompleted = reminder.status == 'completed';

    return Card(
      color: isOverdue
          ? AppTheme.errorColor.withValues(alpha: 0.05)
          : isCompleted
              ? AppTheme.successColor.withValues(alpha: 0.05)
              : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: type.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : type.icon,
                  color: isCompleted ? AppTheme.successColor : type.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reminder.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        if (isOverdue && !isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Overdue',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (reminder.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        reminder.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (reminder.application != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline,
                            size: 14,
                            color: AppTheme.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${reminder.application!.companyName} - ${reminder.application!.jobTitle}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: isOverdue
                              ? AppTheme.errorColor
                              : AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateTimeUtils.formatRelative(reminder.dueAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isOverdue
                                ? AppTheme.errorColor
                                : AppTheme.textSecondary,
                            fontWeight: isOverdue ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),

                    // Actions
                    if (!isCompleted && (onComplete != null || onSnooze != null)) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (onComplete != null)
                            OutlinedButton.icon(
                              onPressed: onComplete,
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Complete'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                minimumSize: Size.zero,
                              ),
                            ),
                          if (onComplete != null && onSnooze != null)
                            const SizedBox(width: 8),
                          if (onSnooze != null)
                            OutlinedButton.icon(
                              onPressed: onSnooze,
                              icon: const Icon(Icons.snooze, size: 16),
                              label: const Text('Snooze'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                minimumSize: Size.zero,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact reminder list item
class ReminderListItem extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const ReminderListItem({
    super.key,
    required this.reminder,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final type = ReminderType.fromValue(reminder.reminderType);
    final isOverdue = reminder.status == 'pending' &&
        reminder.dueAt.isBefore(DateTime.now());

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: type.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(type.icon, color: type.color),
      ),
      title: Text(
        reminder.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        DateTimeUtils.formatRelative(reminder.dueAt),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isOverdue ? AppTheme.errorColor : null,
        ),
      ),
      trailing: onComplete != null
          ? IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: onComplete,
            )
          : const Icon(Icons.chevron_right),
    );
  }
}
