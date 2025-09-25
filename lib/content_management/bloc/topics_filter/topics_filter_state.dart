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
    this.selectedStatus = ContentStatus.active,
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  /// Creates a copy of this state with the given fields replaced with the
  /// new values.
  TopicsFilterState copyWith({
    String? searchQuery,
    ContentStatus? selectedStatus,
  }) {
    return TopicsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object> get props => [searchQuery, selectedStatus];
}
