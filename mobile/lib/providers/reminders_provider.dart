import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

/// Reminders state
class RemindersState {
  final List<Reminder> reminders;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final String? statusFilter;

  const RemindersState({
    this.reminders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.statusFilter,
  });

  RemindersState copyWith({
    List<Reminder>? reminders,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
    String? statusFilter,
  }) {
    return RemindersState(
      reminders: reminders ?? this.reminders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

/// Reminders state notifier
class RemindersNotifier extends StateNotifier<RemindersState> {
  final ReminderRepository _repository;

  RemindersNotifier(this._repository) : super(const RemindersState());

  /// Load reminders
  Future<void> loadReminders({String? status}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      statusFilter: status,
      currentPage: 1,
    );

    try {
      final response = await _repository.getReminders(
        page: 1,
        status: status,
      );
      
      state = state.copyWith(
        reminders: response.results,
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

  /// Load more reminders
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.getReminders(
        page: nextPage,
        status: state.statusFilter,
      );
      
      state = state.copyWith(
        reminders: [...state.reminders, ...response.results],
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

  /// Create reminder
  Future<Reminder> createReminder(CreateReminderRequest request) async {
    final reminder = await _repository.createReminder(request);
    state = state.copyWith(
      reminders: [reminder, ...state.reminders],
    );
    return reminder;
  }

  /// Update reminder
  Future<void> updateReminder(String id, UpdateReminderRequest request) async {
    final updated = await _repository.updateReminder(id, request);
    _updateReminderInList(updated);
  }

  /// Delete reminder
  Future<void> deleteReminder(String id) async {
    await _repository.deleteReminder(id);
    state = state.copyWith(
      reminders: state.reminders.where((r) => r.id != id).toList(),
    );
  }

  /// Complete reminder
  Future<void> completeReminder(String id) async {
    final updated = await _repository.completeReminder(id);
    _updateReminderInList(updated);
  }

  /// Snooze reminder
  Future<void> snoozeReminder(String id, Duration duration) async {
    final snoozeUntil = DateTime.now().add(duration);
    final updated = await _repository.snoozeReminder(id, snoozeUntil);
    _updateReminderInList(updated);
  }

  void _updateReminderInList(Reminder updated) {
    final index = state.reminders.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      final newList = [...state.reminders];
      newList[index] = updated;
      state = state.copyWith(reminders: newList);
    }
  }

  /// Refresh reminders
  Future<void> refresh() async {
    await loadReminders(status: state.statusFilter);
  }
}

/// Provider for reminders
final remindersProvider =
    StateNotifierProvider<RemindersNotifier, RemindersState>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return RemindersNotifier(repository);
});

/// Provider for pending reminders
final pendingRemindersProvider = Provider<List<Reminder>>((ref) {
  final reminders = ref.watch(remindersProvider).reminders;
  return reminders.where((r) => r.status == 'pending').toList();
});

/// Provider for overdue reminders
final overdueRemindersProvider = Provider<List<Reminder>>((ref) {
  final reminders = ref.watch(remindersProvider).reminders;
  final now = DateTime.now();
  
  return reminders.where((r) {
    return r.status == 'pending' && r.dueAt.isBefore(now);
  }).toList();
});

/// Provider for today's reminders
final todayRemindersProvider = Provider<List<Reminder>>((ref) {
  final reminders = ref.watch(remindersProvider).reminders;
  final now = DateTime.now();
  
  return reminders.where((r) {
    return r.status == 'pending' &&
           r.dueAt.year == now.year &&
           r.dueAt.month == now.month &&
           r.dueAt.day == now.day;
  }).toList();
});
