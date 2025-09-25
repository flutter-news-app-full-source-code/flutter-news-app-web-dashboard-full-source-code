part of 'headlines_filter_bloc.dart';

/// {@template headlines_filter_state}
/// The state for the headlines filter UI.
///
/// Manages the search query and the set of selected content statuses
/// that the user wants to filter by.
/// {@endtemplate}
class HeadlinesFilterState extends Equatable {
  /// {@macro headlines_filter_state}
  const HeadlinesFilterState({
    this.searchQuery = '',
    // Default to showing only active items.
    this.selectedStatuses = const {ContentStatus.active},
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The set of content statuses to be included in the filter.
  final Set<ContentStatus> selectedStatuses;

  /// Creates a copy of this state with the given fields replaced with the
  /// new values.
  HeadlinesFilterState copyWith({
    String? searchQuery,
    Set<ContentStatus>? selectedStatuses,
  }) {
    return HeadlinesFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
    );
  }

  @override
  List<Object> get props => [searchQuery, selectedStatuses];
}
