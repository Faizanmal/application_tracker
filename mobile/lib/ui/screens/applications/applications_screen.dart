import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../../widgets/application_list_item.dart';
import '../../widgets/loading_overlay.dart';

/// Applications list screen
class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String? _selectedStatus;

  final _statuses = [
    null, // All
    ...ApplicationStatus.values.map((s) => s.value),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ApplicationStatus.values.length + 1,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    _loadApplications();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final index = _tabController.index;
    _selectedStatus = index == 0 ? null : ApplicationStatus.values[index - 1].value;
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    await ref.read(applicationsProvider.notifier).loadApplications(
      status: _selectedStatus,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
  }

  void _onSearch(String query) {
    ref.read(applicationsProvider.notifier).loadApplications(
      status: _selectedStatus,
      search: query.isNotEmpty ? query : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: 'All'),
            ...ApplicationStatus.values.map((s) => Tab(text: s.label)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search applications...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _onSearch,
            ),
          ),

          // Applications list
          Expanded(
            child: state.isLoading && state.applications.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.applications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadApplications,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.applications.length +
                              (state.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.applications.length) {
                              // Load more indicator
                              if (!state.isLoading) {
                                ref
                                    .read(applicationsProvider.notifier)
                                    .loadMore();
                              }
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final application = state.applications[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ApplicationListItem(
                                application: application,
                                onTap: () => context.push(
                                  '/applications/${application.id}',
                                ),
                                onStarToggle: () => ref
                                    .read(applicationsProvider.notifier)
                                    .toggleStarred(application.id),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/applications/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No applications found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedStatus != null
                ? 'No applications with this status'
                : 'Start tracking your job applications',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/applications/new'),
            icon: const Icon(Icons.add),
            label: const Text('Add Application'),
          ),
        ],
      ),
    );
  }
}
