import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/application.dart';

/// Filter state for advanced search
class SearchFiltersState {
  final String query;
  final List<ApplicationStatus> statuses;
  final List<JobType> jobTypes;
  final List<WorkLocationType> workLocationTypes;
  final DateTime? appliedAfter;
  final DateTime? appliedBefore;
  final double? salaryMin;
  final double? salaryMax;
  final List<String> tags;
  final bool favoritesOnly;
  final bool archivedOnly;
  final String sortBy;
  final bool sortDescending;

  const SearchFiltersState({
    this.query = '',
    this.statuses = const [],
    this.jobTypes = const [],
    this.workLocationTypes = const [],
    this.appliedAfter,
    this.appliedBefore,
    this.salaryMin,
    this.salaryMax,
    this.tags = const [],
    this.favoritesOnly = false,
    this.archivedOnly = false,
    this.sortBy = 'updated_at',
    this.sortDescending = true,
  });

  SearchFiltersState copyWith({
    String? query,
    List<ApplicationStatus>? statuses,
    List<JobType>? jobTypes,
    List<WorkLocationType>? workLocationTypes,
    DateTime? appliedAfter,
    DateTime? appliedBefore,
    double? salaryMin,
    double? salaryMax,
    List<String>? tags,
    bool? favoritesOnly,
    bool? archivedOnly,
    String? sortBy,
    bool? sortDescending,
  }) {
    return SearchFiltersState(
      query: query ?? this.query,
      statuses: statuses ?? this.statuses,
      jobTypes: jobTypes ?? this.jobTypes,
      workLocationTypes: workLocationTypes ?? this.workLocationTypes,
      appliedAfter: appliedAfter ?? this.appliedAfter,
      appliedBefore: appliedBefore ?? this.appliedBefore,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      tags: tags ?? this.tags,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      archivedOnly: archivedOnly ?? this.archivedOnly,
      sortBy: sortBy ?? this.sortBy,
      sortDescending: sortDescending ?? this.sortDescending,
    );
  }

  bool get hasActiveFilters =>
      statuses.isNotEmpty ||
      jobTypes.isNotEmpty ||
      workLocationTypes.isNotEmpty ||
      appliedAfter != null ||
      appliedBefore != null ||
      salaryMin != null ||
      salaryMax != null ||
      tags.isNotEmpty ||
      favoritesOnly ||
      archivedOnly;

  int get activeFilterCount {
    int count = 0;
    if (statuses.isNotEmpty) count++;
    if (jobTypes.isNotEmpty) count++;
    if (workLocationTypes.isNotEmpty) count++;
    if (appliedAfter != null || appliedBefore != null) count++;
    if (salaryMin != null || salaryMax != null) count++;
    if (tags.isNotEmpty) count++;
    if (favoritesOnly) count++;
    if (archivedOnly) count++;
    return count;
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'statuses': statuses.map((s) => s.name).toList(),
      'job_types': jobTypes.map((j) => j.name).toList(),
      'work_location_types': workLocationTypes.map((w) => w.name).toList(),
      'applied_after': appliedAfter?.toIso8601String(),
      'applied_before': appliedBefore?.toIso8601String(),
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'tags': tags,
      'favorites_only': favoritesOnly,
      'archived_only': archivedOnly,
      'sort_by': sortBy,
      'sort_descending': sortDescending,
    };
  }

  factory SearchFiltersState.fromJson(Map<String, dynamic> json) {
    return SearchFiltersState(
      query: json['query'] ?? '',
      statuses: (json['statuses'] as List?)
              ?.map((s) => ApplicationStatus.values.firstWhere(
                    (e) => e.name == s,
                    orElse: () => ApplicationStatus.draft,
                  ))
              .toList() ??
          [],
      jobTypes: (json['job_types'] as List?)
              ?.map((j) => JobType.values.firstWhere(
                    (e) => e.name == j,
                    orElse: () => JobType.fullTime,
                  ))
              .toList() ??
          [],
      workLocationTypes: (json['work_location_types'] as List?)
              ?.map((w) => WorkLocationType.values.firstWhere(
                    (e) => e.name == w,
                    orElse: () => WorkLocationType.onsite,
                  ))
              .toList() ??
          [],
      appliedAfter: json['applied_after'] != null
          ? DateTime.parse(json['applied_after'])
          : null,
      appliedBefore: json['applied_before'] != null
          ? DateTime.parse(json['applied_before'])
          : null,
      salaryMin: json['salary_min']?.toDouble(),
      salaryMax: json['salary_max']?.toDouble(),
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      favoritesOnly: json['favorites_only'] ?? false,
      archivedOnly: json['archived_only'] ?? false,
      sortBy: json['sort_by'] ?? 'updated_at',
      sortDescending: json['sort_descending'] ?? true,
    );
  }
}

/// Saved search model
class SavedSearch {
  final String id;
  final String name;
  final SearchFiltersState filters;
  final DateTime createdAt;

  const SavedSearch({
    required this.id,
    required this.name,
    required this.filters,
    required this.createdAt,
  });
}

/// Search filters provider
final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFiltersState>((ref) {
  return SearchFiltersNotifier();
});

class SearchFiltersNotifier extends StateNotifier<SearchFiltersState> {
  SearchFiltersNotifier() : super(const SearchFiltersState());

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void toggleStatus(ApplicationStatus status) {
    final newStatuses = List<ApplicationStatus>.from(state.statuses);
    if (newStatuses.contains(status)) {
      newStatuses.remove(status);
    } else {
      newStatuses.add(status);
    }
    state = state.copyWith(statuses: newStatuses);
  }

  void toggleJobType(JobType jobType) {
    final newJobTypes = List<JobType>.from(state.jobTypes);
    if (newJobTypes.contains(jobType)) {
      newJobTypes.remove(jobType);
    } else {
      newJobTypes.add(jobType);
    }
    state = state.copyWith(jobTypes: newJobTypes);
  }

  void toggleWorkLocationType(WorkLocationType type) {
    final newTypes = List<WorkLocationType>.from(state.workLocationTypes);
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }
    state = state.copyWith(workLocationTypes: newTypes);
  }

  void setDateRange(DateTime? after, DateTime? before) {
    state = state.copyWith(appliedAfter: after, appliedBefore: before);
  }

  void setSalaryRange(double? min, double? max) {
    state = state.copyWith(salaryMin: min, salaryMax: max);
  }

  void toggleTag(String tag) {
    final newTags = List<String>.from(state.tags);
    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      newTags.add(tag);
    }
    state = state.copyWith(tags: newTags);
  }

  void setFavoritesOnly(bool value) {
    state = state.copyWith(favoritesOnly: value);
  }

  void setArchivedOnly(bool value) {
    state = state.copyWith(archivedOnly: value);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void toggleSortOrder() {
    state = state.copyWith(sortDescending: !state.sortDescending);
  }

  void applyFilters(SearchFiltersState filters) {
    state = filters;
  }

  void clearFilters() {
    state = SearchFiltersState(
      query: state.query,
      sortBy: state.sortBy,
      sortDescending: state.sortDescending,
    );
  }

  void reset() {
    state = const SearchFiltersState();
  }
}

/// Advanced search panel
class AdvancedSearchPanel extends ConsumerWidget {
  final VoidCallback? onClose;
  final VoidCallback? onApply;

  const AdvancedSearchPanel({
    super.key,
    this.onClose,
    this.onApply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (filters.hasActiveFilters) ...[
                const SizedBox(width: 8),
                Badge(
                  label: Text('${filters.activeFilterCount}'),
                ),
              ],
              const Spacer(),
              TextButton(
                onPressed: () {
                  ref.read(searchFiltersProvider.notifier).clearFilters();
                },
                child: const Text('Clear'),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Filter
                  _FilterSection(
                    title: 'Status',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ApplicationStatus.values.map((status) {
                        return FilterChip(
                          label: Text(_formatEnum(status.name)),
                          selected: filters.statuses.contains(status),
                          onSelected: (_) {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .toggleStatus(status);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // Job Type Filter
                  _FilterSection(
                    title: 'Job Type',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: JobType.values.map((type) {
                        return FilterChip(
                          label: Text(_formatEnum(type.name)),
                          selected: filters.jobTypes.contains(type),
                          onSelected: (_) {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .toggleJobType(type);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // Work Location Filter
                  _FilterSection(
                    title: 'Work Location',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: WorkLocationType.values.map((type) {
                        return FilterChip(
                          label: Text(_formatEnum(type.name)),
                          selected: filters.workLocationTypes.contains(type),
                          onSelected: (_) {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .toggleWorkLocationType(type);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  // Date Range Filter
                  _FilterSection(
                    title: 'Applied Date',
                    child: Row(
                      children: [
                        Expanded(
                          child: _DateButton(
                            label: 'From',
                            date: filters.appliedAfter,
                            onDateSelected: (date) {
                              ref
                                  .read(searchFiltersProvider.notifier)
                                  .setDateRange(date, filters.appliedBefore);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DateButton(
                            label: 'To',
                            date: filters.appliedBefore,
                            onDateSelected: (date) {
                              ref
                                  .read(searchFiltersProvider.notifier)
                                  .setDateRange(filters.appliedAfter, date);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Salary Range Filter
                  _FilterSection(
                    title: 'Salary Range',
                    child: _SalaryRangeSlider(
                      minValue: filters.salaryMin,
                      maxValue: filters.salaryMax,
                      onChanged: (min, max) {
                        ref
                            .read(searchFiltersProvider.notifier)
                            .setSalaryRange(min, max);
                      },
                    ),
                  ),

                  // Quick Filters
                  _FilterSection(
                    title: 'Quick Filters',
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Favorites Only'),
                          value: filters.favoritesOnly,
                          onChanged: (value) {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .setFavoritesOnly(value);
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Archived Only'),
                          value: filters.archivedOnly,
                          onChanged: (value) {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .setArchivedOnly(value);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Sort Options
                  _FilterSection(
                    title: 'Sort By',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ('updated_at', 'Last Updated'),
                        ('created_at', 'Created'),
                        ('applied_date', 'Applied Date'),
                        ('company_name', 'Company'),
                        ('job_title', 'Job Title'),
                        ('salary_max', 'Salary'),
                      ].map((option) {
                        return ChoiceChip(
                          label: Text(option.$2),
                          selected: filters.sortBy == option.$1,
                          onSelected: (_) {
                            ref
                                .read(searchFiltersProvider.notifier)
                                .setSortBy(option.$1);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  ListTile(
                    leading: Icon(
                      filters.sortDescending
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                    title: Text(filters.sortDescending
                        ? 'Descending'
                        : 'Ascending'),
                    onTap: () {
                      ref
                          .read(searchFiltersProvider.notifier)
                          .toggleSortOrder();
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onApply,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatEnum(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onDateSelected;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selected != null) {
          onDateSelected(selected);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 16),
          const SizedBox(width: 8),
          Text(date != null
              ? '${date!.month}/${date!.day}/${date!.year}'
              : label),
          if (date != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => onDateSelected(null),
              child: const Icon(Icons.close, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

class _SalaryRangeSlider extends StatefulWidget {
  final double? minValue;
  final double? maxValue;
  final void Function(double? min, double? max) onChanged;

  const _SalaryRangeSlider({
    this.minValue,
    this.maxValue,
    required this.onChanged,
  });

  @override
  State<_SalaryRangeSlider> createState() => _SalaryRangeSliderState();
}

class _SalaryRangeSliderState extends State<_SalaryRangeSlider> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(
      widget.minValue ?? 0,
      widget.maxValue ?? 300000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: _values,
          min: 0,
          max: 300000,
          divisions: 30,
          labels: RangeLabels(
            '\$${(_values.start / 1000).round()}K',
            '\$${(_values.end / 1000).round()}K',
          ),
          onChanged: (values) {
            setState(() => _values = values);
          },
          onChangeEnd: (values) {
            widget.onChanged(
              values.start > 0 ? values.start : null,
              values.end < 300000 ? values.end : null,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${(_values.start / 1000).round()}K'),
            Text('\$${(_values.end / 1000).round()}K'),
          ],
        ),
      ],
    );
  }
}

/// Search bar with filters button
class ApplicationSearchBar extends ConsumerWidget {
  final VoidCallback? onFilterTap;

  const ApplicationSearchBar({
    super.key,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);

    return SearchBar(
      hintText: 'Search applications...',
      leading: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.search),
      ),
      trailing: [
        if (filters.hasActiveFilters)
          Badge(
            label: Text('${filters.activeFilterCount}'),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: onFilterTap,
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: onFilterTap,
          ),
      ],
      onChanged: (value) {
        ref.read(searchFiltersProvider.notifier).setQuery(value);
      },
    );
  }
}
