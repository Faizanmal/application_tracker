import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

/// Interviews state
class InterviewsState {
  final List<Interview> interviews;
  final List<Interview> upcomingInterviews;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final String? statusFilter;

  const InterviewsState({
    this.interviews = const [],
    this.upcomingInterviews = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.statusFilter,
  });

  InterviewsState copyWith({
    List<Interview>? interviews,
    List<Interview>? upcomingInterviews,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
    String? statusFilter,
  }) {
    return InterviewsState(
      interviews: interviews ?? this.interviews,
      upcomingInterviews: upcomingInterviews ?? this.upcomingInterviews,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

/// Interviews state notifier
class InterviewsNotifier extends StateNotifier<InterviewsState> {
  final InterviewRepository _repository;

  InterviewsNotifier(this._repository) : super(const InterviewsState());

  /// Load interviews
  Future<void> loadInterviews({String? status}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      statusFilter: status,
      currentPage: 1,
    );

    try {
      final response = await _repository.getInterviews(
        page: 1,
        status: status,
      );
      
      state = state.copyWith(
        interviews: response.results,
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

  /// Load upcoming interviews
  Future<void> loadUpcomingInterviews() async {
    try {
      final upcoming = await _repository.getUpcomingInterviews();
      state = state.copyWith(upcomingInterviews: upcoming);
    } catch (e) {
      // Ignore errors for upcoming
    }
  }

  /// Load upcoming interviews (alias)
  Future<void> loadUpcoming() async {
    return loadUpcomingInterviews();
  }

  /// Load more interviews
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.getInterviews(
        page: nextPage,
        status: state.statusFilter,
      );
      
      state = state.copyWith(
        interviews: [...state.interviews, ...response.results],
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

  /// Create interview
  Future<Interview> createInterview(CreateInterviewRequest request) async {
    final interview = await _repository.createInterview(request);
    state = state.copyWith(
      interviews: [interview, ...state.interviews],
    );
    // Reload upcoming
    await loadUpcoming();
    return interview;
  }

  /// Update interview
  Future<void> updateInterview(String id, UpdateInterviewRequest request) async {
    final updated = await _repository.updateInterview(id, request);
    _updateInterviewInList(updated);
  }

  /// Delete interview
  Future<void> deleteInterview(String id) async {
    await _repository.deleteInterview(id);
    state = state.copyWith(
      interviews: state.interviews.where((i) => i.id != id).toList(),
      upcomingInterviews: state.upcomingInterviews.where((i) => i.id != id).toList(),
    );
  }

  /// Complete interview (simple version)
  Future<void> completeInterview(String id) async {
    final updated = await _repository.completeInterview(id, 5);
    _updateInterviewInList(updated);
    // Remove from upcoming
    state = state.copyWith(
      upcomingInterviews: state.upcomingInterviews.where((i) => i.id != id).toList(),
    );
  }

  /// Complete interview with details
  Future<void> completeInterviewWithDetails(
    String id,
    int rating, {
    String? feedback,
    String? notes,
  }) async {
    final updated = await _repository.completeInterview(
      id,
      rating,
      feedback: feedback,
      notes: notes,
    );
    _updateInterviewInList(updated);
    // Remove from upcoming
    state = state.copyWith(
      upcomingInterviews: state.upcomingInterviews.where((i) => i.id != id).toList(),
    );
  }

  void _updateInterviewInList(Interview updated) {
    final index = state.interviews.indexWhere((i) => i.id == updated.id);
    if (index != -1) {
      final newList = [...state.interviews];
      newList[index] = updated;
      state = state.copyWith(interviews: newList);
    }
  }

  /// Refresh interviews
  Future<void> refresh() async {
    await Future.wait([
      loadInterviews(status: state.statusFilter),
      loadUpcoming(),
    ]);
  }
}

/// Provider for interviews
final interviewsProvider =
    StateNotifierProvider<InterviewsNotifier, InterviewsState>((ref) {
  final repository = ref.watch(interviewRepositoryProvider);
  return InterviewsNotifier(repository);
});

/// Provider for single interview
final interviewProvider =
    FutureProvider.family<Interview, String>((ref, id) async {
  final repository = ref.watch(interviewRepositoryProvider);
  return repository.getInterview(id);
});

/// Provider for upcoming interviews (limit 5)
final upcomingInterviewsProvider = Provider<List<Interview>>((ref) {
  final interviews = ref.watch(interviewsProvider).upcomingInterviews;
  return interviews.take(5).toList();
});

/// Provider for today's interviews
final todayInterviewsProvider = Provider<List<Interview>>((ref) {
  final interviews = ref.watch(interviewsProvider).upcomingInterviews;
  final now = DateTime.now();
  
  return interviews.where((i) {
    return i.scheduledAt.year == now.year &&
           i.scheduledAt.month == now.month &&
           i.scheduledAt.day == now.day;
  }).toList();
});
