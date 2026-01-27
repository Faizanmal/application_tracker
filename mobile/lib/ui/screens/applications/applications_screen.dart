import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../../widgets/application_list_item.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/bulk_actions.dart';
import '../../widgets/advanced_search.dart';
import '../../widgets/voice_features.dart';
import '../import_export_screen.dart';

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
  bool _showAdvancedSearch = false;

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

  void _handleVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();
    if (lowerCommand.contains('new') || lowerCommand.contains('add') || lowerCommand.contains('create')) {
      context.push('/applications/new');
    } else if (lowerCommand.contains('search')) {
      final searchTerm = lowerCommand.replaceFirst('search', '').trim();
      if (searchTerm.isNotEmpty) {
        _searchController.text = searchTerm;
        _onSearch(searchTerm);
      }
    } else if (lowerCommand.contains('filter')) {
      setState(() => _showAdvancedSearch = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationsProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);
    final selectedApps = ref.watch(selectedApplicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: isSelectionMode 
            ? Text('${selectedApps.length} selected')
            : const Text('Applications'),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(selectionModeProvider.notifier).state = false;
                  ref.read(selectedApplicationsProvider.notifier).state = {};
                },
              )
            : null,
        actions: [
          if (!isSelectionMode) ...[
            IconButton(
              icon: Icon(_showAdvancedSearch 
                  ? Icons.filter_list_off 
                  : Icons.filter_list),
              tooltip: 'Advanced Search',
              onPressed: () {
                setState(() => _showAdvancedSearch = !_showAdvancedSearch);
              },
            ),
            VoiceCommandButton(
              onCommand: (command) {
                _handleVoiceCommand(command);
              },
            ),
            ImportExportButton(
              onImportComplete: () => _loadApplications(),
            ),
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: 'Bulk Select',
              onPressed: () {
                ref.read(selectionModeProvider.notifier).state = true;
              },
            ),
          ],
        ],
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
          // Advanced search panel (collapsible)
          if (_showAdvancedSearch) ...[
            const AdvancedSearchPanel(),
            const Divider(),
          ],
          // Search bar with voice
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 8),
                VoiceInputField(
                  onResult: (text) {
                    _searchController.text = text;
                    _onSearch(text);
                  },
                ),
              ],
            ),
          ),

          // Bulk actions bar when in selection mode
          if (isSelectionMode) const BulkActionsBar(),

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
                            final isSelected = selectedApps.contains(application.id);
                            
                            if (isSelectionMode) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: SelectableApplicationCard(
                                  applicationId: application.id,
                                  isSelected: isSelected,
                                  child: ApplicationListItem(
                                    application: application,
                                    onTap: () {
                                      // Toggle selection
                                      final current = ref.read(selectedApplicationsProvider);
                                      if (current.contains(application.id)) {
                                        ref.read(selectedApplicationsProvider.notifier).state = 
                                            {...current}..remove(application.id);
                                      } else {
                                        ref.read(selectedApplicationsProvider.notifier).state = 
                                            {...current, application.id};
                                      }
                                    },
                                    onStarToggle: () => ref
                                        .read(applicationsProvider.notifier)
                                        .toggleStarred(application.id),
                                  ),
                                ),
                              );
                            }
                            
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
      // Hide FAB when in selection mode
      floatingActionButton: isSelectionMode 
          ? null
          : FloatingActionButton.extended(
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
