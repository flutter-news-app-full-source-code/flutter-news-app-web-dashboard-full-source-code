part of 'topics_filter_bloc.dart';

/// {@template topics_filter_state}
/// The state for the topics filter UI.
///
/// Manages the search query and the set of selected content statuses
/// that the user wants to filter by.
/// {@endtemplate}
class TopicsFilterState extends Equatable {
  /// {@macro topics_filter_state}
  const TopicsFilterState({
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
  TopicsFilterState copyWith({
    String? searchQuery,
    Set<ContentStatus>? selectedStatuses,
  }) {
    return TopicsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
    );
  }

  @override
  List<Object> get props => [searchQuery, selectedStatuses];
}
