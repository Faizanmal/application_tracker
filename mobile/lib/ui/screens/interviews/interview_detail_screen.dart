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

/// Interview detail screen
class InterviewDetailScreen extends ConsumerWidget {
  final String interviewId;

  const InterviewDetailScreen({
    super.key,
    required this.interviewId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interviewAsync = ref.watch(interviewProvider(interviewId));

    return interviewAsync.when(
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
                onPressed: () => ref.invalidate(interviewProvider(interviewId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (interview) => _InterviewDetailContent(interview: interview),
    );
  }
}

class _InterviewDetailContent extends ConsumerStatefulWidget {
  final Interview interview;

  const _InterviewDetailContent({required this.interview});

  @override
  ConsumerState<_InterviewDetailContent> createState() =>
      _InterviewDetailContentState();
}

class _InterviewDetailContentState
    extends ConsumerState<_InterviewDetailContent> {
  bool _isLoading = false;

  Future<void> _markAsCompleted() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Interview'),
        content: const Text('Mark this interview as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(interviewsProvider.notifier)
            .completeInterview(widget.interview.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Interview completed!')),
          );
          context.pop();
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
  }

  @override
  Widget build(BuildContext context) {
    final interview = widget.interview;
    final type = InterviewType.fromValue(interview.interviewType);
    final status = InterviewStatus.fromValue(interview.status);
    final isUpcoming = interview.scheduledAt.isAfter(DateTime.now());
    final countdown = DateTimeUtils.getCountdown(interview.scheduledAt);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interview Details'),
          actions: [
            if (interview.status == 'scheduled' && isUpcoming)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Mark as completed',
                onPressed: _markAsCompleted,
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
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: type.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(type.icon, color: type.color),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (interview.application != null)
                                  Text(
                                    '${interview.application!.jobTitle} at ${interview.application!.companyName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppTheme.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status.label,
                              style: TextStyle(
                                color: status.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Countdown
                          if (isUpcoming && interview.status == 'scheduled')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    countdown,
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date & Time
              _buildSection('Schedule', [
                _buildDetailRow(
                  Icons.calendar_today_outlined,
                  'Date',
                  DateTimeUtils.formatDate(interview.scheduledAt),
                ),
                _buildDetailRow(
                  Icons.access_time,
                  'Time',
                  _formatTime(interview.scheduledAt),
                ),
                if (interview.duration != null)
                  _buildDetailRow(
                    Icons.timer_outlined,
                    'Duration',
                    '${interview.duration} minutes',
                  ),
              ]),

              // Location/Meeting link
              if (interview.location != null || interview.meetingLink != null)
                _buildSection('Location', [
                  if (interview.location != null)
                    _buildDetailRow(
                      Icons.location_on_outlined,
                      'Address',
                      interview.location!,
                    ),
                  if (interview.meetingLink != null)
                    _buildDetailRow(
                      Icons.videocam_outlined,
                      'Meeting Link',
                      'Join meeting',
                      onTap: () => _launchUrl(interview.meetingLink!),
                    ),
                ]),

              // Interviewer
              if (interview.interviewerName != null ||
                  interview.interviewerRole != null)
                _buildSection('Interviewer', [
                  if (interview.interviewerName != null)
                    _buildDetailRow(
                      Icons.person_outline,
                      'Name',
                      interview.interviewerName!,
                    ),
                  if (interview.interviewerRole != null)
                    _buildDetailRow(
                      Icons.badge_outlined,
                      'Role',
                      interview.interviewerRole!,
                    ),
                ]),

              // Notes
              if (interview.notes != null && interview.notes!.isNotEmpty)
                _buildSection('Notes', [], content: interview.notes),

              // Feedback (for completed interviews)
              if (interview.feedback != null && interview.feedback!.isNotEmpty)
                _buildSection('Feedback', [], content: interview.feedback),

              const SizedBox(height: 80),
            ],
          ),
        ),
        floatingActionButton: isUpcoming && interview.status == 'scheduled'
            ? FloatingActionButton.extended(
                onPressed: () {
                  // TODO: Navigate to prep screen or show prep tips
                  _showPrepTips();
                },
                icon: const Icon(Icons.psychology_outlined),
                label: const Text('Prep Tips'),
              )
            : null,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> rows, {String? content}) {
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
          Card(child: Column(children: rows)),
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

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showPrepTips() {
    final type = InterviewType.fromValue(widget.interview.interviewType);
    final tips = _getPrepTips(type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  '${type.label} Prep Tips',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: tips.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tips[index],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> _getPrepTips(InterviewType type) {
    switch (type) {
      case InterviewType.phone:
        return [
          'Find a quiet place with good cell reception',
          'Have your resume and the job description in front of you',
          'Prepare a few questions to ask the interviewer',
          'Keep your answers concise - aim for 1-2 minutes per question',
          'Smile while talking - it affects your tone positively',
        ];
      case InterviewType.video:
        return [
          'Test your camera, microphone, and internet connection',
          'Choose a clean, well-lit background',
          'Dress professionally from head to toe',
          'Look at the camera, not the screen, when speaking',
          'Close unnecessary tabs and applications',
          'Have water nearby and your notes off-screen',
        ];
      case InterviewType.onsite:
        return [
          'Plan your route and arrive 10-15 minutes early',
          'Bring copies of your resume and a notepad',
          'Dress appropriately for the company culture',
          'Be polite to everyone you meet',
          'Prepare a firm handshake and confident smile',
          'Research the office location and parking options',
        ];
      case InterviewType.technical:
        return [
          'Review fundamental data structures and algorithms',
          'Practice coding problems on a whiteboard or shared editor',
          'Think out loud and explain your approach',
          'Ask clarifying questions before diving in',
          'Consider edge cases and test your solution',
          'Review the job posting for required technologies',
        ];
      case InterviewType.behavioral:
        return [
          'Use the STAR method: Situation, Task, Action, Result',
          'Prepare stories for common behavioral questions',
          'Research the company values and culture',
          'Be honest and authentic in your responses',
          'Quantify your achievements when possible',
          'Practice your elevator pitch',
        ];
      case InterviewType.panel:
        return [
          'Research each interviewer if their names are provided',
          'Make eye contact with everyone, not just the person asking',
          'Address responses to the whole panel',
          'Bring extra copies of your resume',
          'Take notes on each person\'s role',
          'Thank each interviewer individually at the end',
        ];
      case InterviewType.assessment:
        return [
          'Read all instructions carefully before starting',
          'Manage your time wisely across all sections',
          'Get a good night\'s sleep beforehand',
          'Find a quiet, distraction-free environment',
          'If timed, don\'t spend too long on any single question',
          'Review the types of assessments common for this role',
        ];
      case InterviewType.other:
        return [
          'Review the job description thoroughly',
          'Research the company and recent news',
          'Prepare thoughtful questions to ask',
          'Practice your introduction and key talking points',
          'Get a good night\'s sleep and eat well',
          'Arrive or log in a few minutes early',
        ];
    }
  }
}
