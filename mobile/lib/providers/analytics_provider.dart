import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

/// Analytics state
class AnalyticsState {
  final AnalyticsOverview? overview;
  final bool isLoading;
  final String? error;
  final String? startDate;
  final String? endDate;

  const AnalyticsState({
    this.overview,
    this.isLoading = false,
    this.error,
    this.startDate,
    this.endDate,
  });

  AnalyticsState copyWith({
    AnalyticsOverview? overview,
    bool? isLoading,
    String? error,
    String? startDate,
    String? endDate,
  }) {
    return AnalyticsState(
      overview: overview ?? this.overview,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// Analytics state notifier
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsNotifier(this._repository) : super(const AnalyticsState());

  /// Load analytics overview
  Future<void> loadOverview({String? startDate, String? endDate}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      startDate: startDate,
      endDate: endDate,
    );

    try {
      final overview = await _repository.getOverview(
        startDate: startDate,
        endDate: endDate,
      );
      
      state = state.copyWith(
        overview: overview,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Set date range
  Future<void> setDateRange(String startDate, String endDate) async {
    await loadOverview(startDate: startDate, endDate: endDate);
  }

  /// Refresh analytics
  Future<void> refresh() async {
    await loadOverview(startDate: state.startDate, endDate: state.endDate);
  }
}

/// Provider for analytics
final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return AnalyticsNotifier(repository);
});

/// Provider for weekly goal progress
final weeklyGoalProgressProvider = Provider<double>((ref) {
  final overview = ref.watch(analyticsProvider).overview;
  if (overview == null || overview.weeklyGoal == 0) return 0.0;
  
  return (overview.weeklyProgress / overview.weeklyGoal).clamp(0.0, 1.0);
});

/// Provider for response rate
final responseRateProvider = Provider<double>((ref) {
  final overview = ref.watch(analyticsProvider).overview;
  return overview?.responseRate ?? 0.0;
});
