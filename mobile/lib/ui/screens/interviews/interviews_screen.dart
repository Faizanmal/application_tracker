import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/providers.dart';
import '../../widgets/interview_card.dart';
import '../../widgets/loading_overlay.dart';

/// Interviews list screen
class InterviewsScreen extends ConsumerStatefulWidget {
  const InterviewsScreen({super.key});

  @override
  ConsumerState<InterviewsScreen> createState() => _InterviewsScreenState();
}

class _InterviewsScreenState extends ConsumerState<InterviewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInterviews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInterviews() async {
    await ref.read(interviewsProvider.notifier).loadInterviews();
    await ref.read(interviewsProvider.notifier).loadUpcomingInterviews();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interviewsProvider);
    final upcomingInterviews = ref.watch(upcomingInterviewsProvider);
    final todayInterviews = ref.watch(todayInterviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interviews'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Today'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming tab
          _buildInterviewList(
            isLoading: state.isLoading && state.upcomingInterviews.isEmpty,
            interviews: upcomingInterviews,
            emptyIcon: Icons.event_available,
            emptyTitle: 'No upcoming interviews',
            emptySubtitle: 'Schedule interviews for your applications',
          ),

          // Today tab
          _buildInterviewList(
            isLoading: state.isLoading && state.interviews.isEmpty,
            interviews: todayInterviews,
            emptyIcon: Icons.today,
            emptyTitle: 'No interviews today',
            emptySubtitle: 'Enjoy your day or schedule some interviews',
          ),

          // All tab
          _buildInterviewList(
            isLoading: state.isLoading && state.interviews.isEmpty,
            interviews: state.interviews,
            emptyIcon: Icons.event_note,
            emptyTitle: 'No interviews yet',
            emptySubtitle: 'Schedule your first interview',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/interviews/new'),
        icon: const Icon(Icons.add),
        label: const Text('Schedule'),
      ),
    );
  }

  Widget _buildInterviewList({
    required bool isLoading,
    required List interviews,
    required IconData emptyIcon,
    required String emptyTitle,
    required String emptySubtitle,
  }) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (interviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: AppTheme.textTertiary),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInterviews,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: interviews.length,
        itemBuilder: (context, index) {
          final interview = interviews[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InterviewCard(
              interview: interview,
              onTap: () => context.push('/interviews/${interview.id}'),
            ),
          );
        },
      ),
    );
  }
}
