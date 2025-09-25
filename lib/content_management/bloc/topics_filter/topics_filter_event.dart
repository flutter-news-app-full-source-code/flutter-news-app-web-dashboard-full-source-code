part of 'topics_filter_bloc.dart';

sealed class TopicsFilterEvent extends Equatable {
  const TopicsFilterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to notify the BLoC that the search query has changed.
final class TopicsSearchQueryChanged extends TopicsFilterEvent {
  const TopicsSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to notify the BLoC that the selected content status has changed.
final class TopicsStatusFilterChanged extends TopicsFilterEvent {
  const TopicsStatusFilterChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to request applying all current filters.
final class TopicsFilterApplied extends TopicsFilterEvent {
  const TopicsFilterApplied({
    required this.searchQuery,
    required this.selectedStatus,
  });

  final String searchQuery;
  final ContentStatus selectedStatus;

  @override
  List<Object?> get props => [searchQuery, selectedStatus];
}

/// Event to request resetting all filters to their initial state.
final class TopicsFilterReset extends TopicsFilterEvent {
  const TopicsFilterReset();
}
