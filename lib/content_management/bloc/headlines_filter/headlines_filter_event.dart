part of 'headlines_filter_bloc.dart';

sealed class HeadlinesFilterEvent extends Equatable {
  const HeadlinesFilterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to notify the BLoC that the search query has changed.
final class HeadlinesSearchQueryChanged extends HeadlinesFilterEvent {
  const HeadlinesSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to notify the BLoC that the selected content status has changed.
final class HeadlinesStatusFilterChanged extends HeadlinesFilterEvent {
  const HeadlinesStatusFilterChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to notify the BLoC that the selected source IDs have changed.
final class HeadlinesSourceFilterChanged extends HeadlinesFilterEvent {
  const HeadlinesSourceFilterChanged(this.sourceIds);

  final List<String> sourceIds;

  @override
  List<Object?> get props => [sourceIds];
}

/// Event to notify the BLoC that the selected topic IDs have changed.
final class HeadlinesTopicFilterChanged extends HeadlinesFilterEvent {
  const HeadlinesTopicFilterChanged(this.topicIds);

  final List<String> topicIds;

  @override
  List<Object?> get props => [topicIds];
}

/// Event to notify the BLoC that the selected country IDs have changed.
final class HeadlinesCountryFilterChanged extends HeadlinesFilterEvent {
  const HeadlinesCountryFilterChanged(this.countryIds);

  final List<String> countryIds;

  @override
  List<Object?> get props => [countryIds];
}

/// Event to request applying all current filters.
final class HeadlinesFilterApplied extends HeadlinesFilterEvent {
  const HeadlinesFilterApplied({
    required this.searchQuery,
    required this.selectedStatus,
    required this.selectedSourceIds,
    required this.selectedTopicIds,
    required this.selectedCountryIds,
  });

  final String searchQuery;
  final ContentStatus selectedStatus;
  final List<String> selectedSourceIds;
  final List<String> selectedTopicIds;
  final List<String> selectedCountryIds;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedStatus,
    selectedSourceIds,
    selectedTopicIds,
    selectedCountryIds,
  ];
}

/// Event to request resetting all filters to their initial state.
final class HeadlinesFilterReset extends HeadlinesFilterEvent {
  const HeadlinesFilterReset();
}
