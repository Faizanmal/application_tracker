import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/models.dart';

/// Interview card widget
class InterviewCard extends StatelessWidget {
  final Interview interview;
  final VoidCallback? onTap;
  final bool showActions;

  const InterviewCard({
    super.key,
    required this.interview,
    this.onTap,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    final type = InterviewType.fromValue(interview.interviewType);
    final status = InterviewStatus.fromValue(interview.status);
    final isUpcoming = interview.scheduledAt.isAfter(DateTime.now()) &&
        interview.status == 'scheduled';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      type.icon,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interview.application?.companyName ?? 'Unknown Company',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          interview.application?.jobTitle ?? 'Unknown Position',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(context, status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Details
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.calendar_today_outlined,
                      DateTimeUtils.formatDate(interview.scheduledAt),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.access_time,
                      DateTimeUtils.formatTime(interview.scheduledAt),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.videocam_outlined,
                      type.label,
                    ),
                  ),
                  if (interview.durationMinutes != null)
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        Icons.timer_outlined,
                        '${interview.durationMinutes} min',
                      ),
                    ),
                ],
              ),

              // Countdown for upcoming
              if (isUpcoming) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.alarm,
                        size: 16,
                        color: AppTheme.warningColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateTimeUtils.getCountdown(interview.scheduledAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, InterviewStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textTertiary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Compact interview list item
class InterviewListItem extends StatelessWidget {
  final Interview interview;
  final VoidCallback? onTap;

  const InterviewListItem({
    super.key,
    required this.interview,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final type = InterviewType.fromValue(interview.interviewType);

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(type.icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        interview.application?.companyName ?? 'Unknown Company',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${type.label} • ${DateTimeUtils.formatDateTime(interview.scheduledAt)}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
