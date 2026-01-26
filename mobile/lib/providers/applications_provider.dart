import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../core/constants/app_constants.dart';

/// Applications state
class ApplicationsState {
  final List<Application> applications;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final String? statusFilter;
  final String? searchQuery;

  const ApplicationsState({
    this.applications = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.statusFilter,
    this.searchQuery,
  });

  ApplicationsState copyWith({
    List<Application>? applications,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
    String? statusFilter,
    String? searchQuery,
  }) {
    return ApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Applications state notifier
class ApplicationsNotifier extends StateNotifier<ApplicationsState> {
  final ApplicationRepository _repository;

  ApplicationsNotifier(this._repository) : super(const ApplicationsState());

  /// Load applications (first page)
  Future<void> loadApplications({String? status, String? search}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      statusFilter: status,
      searchQuery: search,
      currentPage: 1,
    );

    try {
      final response = await _repository.getApplications(
        page: 1,
        status: status,
        search: search,
      );
      
      state = state.copyWith(
        applications: response.results,
        isLoading: false,
        hasMore: response.next != null,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more applications (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.getApplications(
        page: nextPage,
        status: state.statusFilter,
        search: state.searchQuery,
      );
      
      state = state.copyWith(
        applications: [...state.applications, ...response.results],
        isLoading: false,
        hasMore: response.next != null,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Create new application
  Future<Application> createApplication(CreateApplicationRequest request) async {
    final application = await _repository.createApplication(request);
    state = state.copyWith(
      applications: [application, ...state.applications],
    );
    return application;
  }

  /// Update application
  Future<void> updateApplication(String id, UpdateApplicationRequest request) async {
    final updated = await _repository.updateApplication(id, request);
    final index = state.applications.indexWhere((a) => a.id == id);
    if (index != -1) {
      final newList = [...state.applications];
      newList[index] = updated;
      state = state.copyWith(applications: newList);
    }
  }

  /// Update application status
  Future<void> updateStatus(String id, String status) async {
    final updated = await _repository.updateStatus(id, status);
    final index = state.applications.indexWhere((a) => a.id == id);
    if (index != -1) {
      final newList = [...state.applications];
      newList[index] = updated;
      state = state.copyWith(applications: newList);
    }
  }

  /// Delete application
  Future<void> deleteApplication(String id) async {
    await _repository.deleteApplication(id);
    state = state.copyWith(
      applications: state.applications.where((a) => a.id != id).toList(),
    );
  }

  /// Toggle starred
  Future<void> toggleStarred(String id) async {
    final app = state.applications.firstWhere((a) => a.id == id);
    final updated = await _repository.toggleStarred(id, !app.starred);
    final index = state.applications.indexWhere((a) => a.id == id);
    if (index != -1) {
      final newList = [...state.applications];
      newList[index] = updated;
      state = state.copyWith(applications: newList);
    }
  }

  /// Refresh applications
  Future<void> refresh() async {
    await loadApplications(
      status: state.statusFilter,
      search: state.searchQuery,
    );
  }
}

/// Provider for applications
final applicationsProvider =
    StateNotifierProvider<ApplicationsNotifier, ApplicationsState>((ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return ApplicationsNotifier(repository);
});

/// Provider for single application
final applicationProvider =
    FutureProvider.family<Application, String>((ref, id) async {
  final repository = ref.watch(applicationRepositoryProvider);
  return repository.getApplication(id);
});

/// Provider for applications grouped by status (Kanban)
final kanbanApplicationsProvider = Provider<Map<String, List<Application>>>((ref) {
  final applications = ref.watch(applicationsProvider).applications;
  
  final grouped = <String, List<Application>>{};
  for (final status in ApplicationStatus.values) {
    grouped[status.value] = applications
        .where((a) => a.status == status.value)
        .toList();
  }
  
  return grouped;
});

/// Provider for starred applications
final starredApplicationsProvider = Provider<List<Application>>((ref) {
  final applications = ref.watch(applicationsProvider).applications;
  return applications.where((a) => a.starred).toList();
});
