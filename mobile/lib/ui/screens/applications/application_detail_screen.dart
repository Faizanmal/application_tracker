import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/loading_overlay.dart';

/// Application detail screen
class ApplicationDetailScreen extends ConsumerWidget {
  final String applicationId;

  const ApplicationDetailScreen({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(applicationProvider(applicationId));

    return applicationAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(applicationProvider(applicationId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (application) => _ApplicationDetailContent(
        application: application,
        onRefresh: () => ref.invalidate(applicationProvider(applicationId)),
      ),
    );
  }
}

class _ApplicationDetailContent extends ConsumerStatefulWidget {
  final Application application;
  final VoidCallback onRefresh;

  const _ApplicationDetailContent({
    required this.application,
    required this.onRefresh,
  });

  @override
  ConsumerState<_ApplicationDetailContent> createState() =>
      _ApplicationDetailContentState();
}

class _ApplicationDetailContentState
    extends ConsumerState<_ApplicationDetailContent> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String status) async {
    setState(() => _isUpdating = true);
    try {
      await ref
          .read(applicationsProvider.notifier)
          .updateStatus(widget.application.id, status);
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated')),
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
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _deleteApplication() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text(
          'Are you sure you want to delete this application? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(applicationsProvider.notifier)
            .deleteApplication(widget.application.id);
        if (mounted) {
          context.pop();
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
    final app = widget.application;
    final status = ApplicationStatus.fromValue(app.status);

    return LoadingOverlay(
      isLoading: _isUpdating,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Application'),
          actions: [
            IconButton(
              icon: Icon(
                app.starred ? Icons.star : Icons.star_border,
                color: app.starred ? AppTheme.warningColor : null,
              ),
              onPressed: () => ref
                  .read(applicationsProvider.notifier)
                  .toggleStarred(app.id),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteApplication();
                } else if (value == 'edit') {
                  // TODO: Navigate to edit screen
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Company logo
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                app.companyName.isNotEmpty
                                    ? app.companyName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.jobTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  app.companyName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Status dropdown
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton<String>(
                              value: app.status,
                              isDense: true,
                              underline: const SizedBox(),
                              style: TextStyle(
                                color: status.color,
                                fontWeight: FontWeight.w600,
                              ),
                              items: ApplicationStatus.values.map((s) {
                                return DropdownMenuItem(
                                  value: s.value,
                                  child: Text(s.label),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null && value != app.status) {
                                  _updateStatus(value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Details
              _buildDetailSection('Details', [
                if (app.location != null)
                  _buildDetailRow(
                      Icons.location_on_outlined, 'Location', app.location!),
                if (app.workMode != null)
                  _buildDetailRow(Icons.home_work_outlined, 'Work Mode',
                      WorkMode.fromValue(app.workMode!).label),
                if (app.jobType != null)
                  _buildDetailRow(Icons.work_outline, 'Job Type',
                      JobType.fromValue(app.jobType!).label),
                if (app.salaryMin != null || app.salaryMax != null)
                  _buildDetailRow(
                    Icons.attach_money,
                    'Salary',
                    _formatSalary(app.salaryMin, app.salaryMax, app.salaryCurrency),
                  ),
                if (app.appliedAt != null)
                  _buildDetailRow(Icons.calendar_today_outlined, 'Applied',
                      DateTimeUtils.formatDate(app.appliedAt!)),
                if (app.deadline != null)
                  _buildDetailRow(Icons.timer_outlined, 'Deadline',
                      DateTimeUtils.formatDate(app.deadline!)),
                if (app.source != null)
                  _buildDetailRow(Icons.source_outlined, 'Source', app.source!),
              ]),

              // Contact info
              if (app.contactName != null ||
                  app.contactEmail != null ||
                  app.contactPhone != null)
                _buildDetailSection('Contact', [
                  if (app.contactName != null)
                    _buildDetailRow(
                        Icons.person_outline, 'Name', app.contactName!),
                  if (app.contactEmail != null)
                    _buildDetailRow(
                      Icons.email_outlined,
                      'Email',
                      app.contactEmail!,
                      onTap: () => _launchUrl('mailto:${app.contactEmail}'),
                    ),
                  if (app.contactPhone != null)
                    _buildDetailRow(
                      Icons.phone_outlined,
                      'Phone',
                      app.contactPhone!,
                      onTap: () => _launchUrl('tel:${app.contactPhone}'),
                    ),
                ]),

              // Links
              if (app.jobUrl != null || app.companyWebsite != null)
                _buildDetailSection('Links', [
                  if (app.jobUrl != null)
                    _buildDetailRow(
                      Icons.link,
                      'Job Posting',
                      'Open link',
                      onTap: () => _launchUrl(app.jobUrl!),
                    ),
                  if (app.companyWebsite != null)
                    _buildDetailRow(
                      Icons.language,
                      'Company Website',
                      'Open link',
                      onTap: () => _launchUrl(app.companyWebsite!),
                    ),
                ]),

              // Notes
              if (app.notes != null && app.notes!.isNotEmpty)
                _buildDetailSection('Notes', [], content: app.notes),

              // Description
              if (app.description != null && app.description!.isNotEmpty)
                _buildDetailSection('Job Description', [],
                    content: app.description),

              const SizedBox(height: 80),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/interviews/new'),
          icon: const Icon(Icons.event_available),
          label: const Text('Schedule Interview'),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> rows,
      {String? content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (rows.isNotEmpty)
          Card(
            child: Column(children: rows),
          ),
        if (content != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(label),
      subtitle: Text(value),
      trailing: onTap != null ? const Icon(Icons.open_in_new, size: 16) : null,
      onTap: onTap,
    );
  }

  String _formatSalary(int? min, int? max, String currency) {
    if (min != null && max != null) {
      return '$currency ${_formatNumber(min)} - ${_formatNumber(max)}';
    } else if (min != null) {
      return '$currency ${_formatNumber(min)}+';
    } else if (max != null) {
      return 'Up to $currency ${_formatNumber(max)}';
    }
    return 'Not specified';
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
