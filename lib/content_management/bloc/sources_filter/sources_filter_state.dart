part of 'sources_filter_bloc.dart';

/// {@template sources_filter_state}
/// The state for the sources filter UI.
///
/// Manages the search query and the set of selected content statuses
/// that the user wants to filter by.
/// {@endtemplate}
class SourcesFilterState extends Equatable {
  /// {@macro sources_filter_state}
  const SourcesFilterState({
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
  SourcesFilterState copyWith({
    String? searchQuery,
    Set<ContentStatus>? selectedStatuses,
  }) {
    return SourcesFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
    );
  }

  @override
  List<Object> get props => [searchQuery, selectedStatuses];
}
