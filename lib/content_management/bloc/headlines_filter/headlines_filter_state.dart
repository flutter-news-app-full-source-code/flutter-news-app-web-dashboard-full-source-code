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
    this.selectedStatus = ContentStatus.active,
    this.selectedSourceIds = const [],
    this.selectedTopicIds = const [],
    this.selectedCountryIds = const [],
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  /// The list of source IDs to be included in the filter.
  final List<String> selectedSourceIds;

  /// The list of topic IDs to be included in the filter.
  final List<String> selectedTopicIds;

  /// The list of country IDs to be included in the filter.
  final List<String> selectedCountryIds;

  /// Creates a copy of this state with the given fields replaced with the
  /// new values.
  HeadlinesFilterState copyWith({
    String? searchQuery,
    ContentStatus? selectedStatus,
    List<String>? selectedSourceIds,
    List<String>? selectedTopicIds,
    List<String>? selectedCountryIds,
  }) {
    return HeadlinesFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSourceIds: selectedSourceIds ?? this.selectedSourceIds,
      selectedTopicIds: selectedTopicIds ?? this.selectedTopicIds,
      selectedCountryIds: selectedCountryIds ?? this.selectedCountryIds,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    selectedStatus,
    selectedSourceIds,
    selectedTopicIds,
    selectedCountryIds,
  ];
}
