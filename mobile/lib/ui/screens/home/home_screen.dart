import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/models.dart';
import '../../../providers/providers.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/interview_card.dart';
import '../../widgets/reminder_card.dart';
import '../../widgets/application_list_item.dart';

/// Home/Dashboard screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load all data for dashboard
    await Future.wait([
      ref.read(applicationsProvider.notifier).loadApplications(),
      ref.read(interviewsProvider.notifier).loadUpcoming(),
      ref.read(remindersProvider.notifier).loadReminders(status: 'pending'),
      ref.read(analyticsProvider.notifier).loadOverview(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final analytics = ref.watch(analyticsProvider);
    final upcomingInterviews = ref.watch(upcomingInterviewsProvider);
    final overdueReminders = ref.watch(overdueRemindersProvider);
    final starredApps = ref.watch(starredApplicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back${user?.firstName != null ? ', ${user!.firstName}' : ''}!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              DateTimeUtils.formatDate(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => context.push('/analytics'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Row
              _buildStatsSection(analytics.overview),
              const SizedBox(height: 24),

              // Weekly Goal Progress
              _buildWeeklyGoalCard(analytics.overview),
              const SizedBox(height: 24),

              // Overdue Reminders Alert
              if (overdueReminders.isNotEmpty) ...[
                _buildOverdueRemindersAlert(overdueReminders),
                const SizedBox(height: 24),
              ],

              // Upcoming Interviews
              if (upcomingInterviews.isNotEmpty) ...[
                _buildSectionHeader(
                  'Upcoming Interviews',
                  onSeeAll: () => context.go('/interviews'),
                ),
                const SizedBox(height: 12),
                ...upcomingInterviews.take(3).map((interview) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InterviewCard(
                    interview: interview,
                    onTap: () => context.push('/interviews/${interview.id}'),
                  ),
                )),
                const SizedBox(height: 16),
              ],

              // Starred Applications
              if (starredApps.isNotEmpty) ...[
                _buildSectionHeader(
                  'Starred Applications',
                  onSeeAll: () => context.go('/applications'),
                ),
                const SizedBox(height: 12),
                ...starredApps.take(3).map((app) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ApplicationListItem(
                    application: app,
                    onTap: () => context.push('/applications/${app.id}'),
                  ),
                )),
              ],

              // Quick Actions
              const SizedBox(height: 24),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/applications/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add Application'),
      ),
    );
  }

  Widget _buildStatsSection(AnalyticsOverview? overview) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Applications',
            value: '${overview?.totalApplications ?? 0}',
            icon: Icons.work_outline,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Interviews',
            value: '${overview?.interviewsScheduled ?? 0}',
            icon: Icons.event_outlined,
            color: AppTheme.warningColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Offers',
            value: '${overview?.offersReceived ?? 0}',
            icon: Icons.celebration_outlined,
            color: AppTheme.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyGoalCard(AnalyticsOverview? overview) {
    final progress = overview != null && overview.weeklyGoal > 0
        ? (overview.weeklyProgress / overview.weeklyGoal).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Goal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${overview?.weeklyProgress ?? 0} / ${overview?.weeklyGoal ?? 10}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppTheme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? AppTheme.successColor : AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progress >= 1.0
                  ? '🎉 Goal achieved!'
                  : '${((1.0 - progress) * (overview?.weeklyGoal ?? 10)).ceil()} more to go',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverdueRemindersAlert(List<Reminder> reminders) {
    return Card(
      color: AppTheme.errorColor.withValues(alpha: 0.1),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.errorColor,
          ),
        ),
        title: Text(
          '${reminders.length} Overdue Reminder${reminders.length > 1 ? 's' : ''}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Tap to view and take action'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/reminders'),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add_circle_outline,
                label: 'New\nApplication',
                onTap: () => context.push('/applications/new'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.event_available,
                label: 'Schedule\nInterview',
                onTap: () => context.push('/interviews/new'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.analytics_outlined,
                label: 'View\nAnalytics',
                onTap: () => context.push('/analytics'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
