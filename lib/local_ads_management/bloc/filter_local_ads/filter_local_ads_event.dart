part of 'filter_local_ads_bloc.dart';

sealed class FilterLocalAdsEvent extends Equatable {
  const FilterLocalAdsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to notify the BLoC that the search query has changed.
final class FilterLocalAdsSearchQueryChanged extends FilterLocalAdsEvent {
  const FilterLocalAdsSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to notify the BLoC that the selected content status has changed.
final class FilterLocalAdsStatusChanged extends FilterLocalAdsEvent {
  const FilterLocalAdsStatusChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to request applying all current filters.
final class FilterLocalAdsApplied extends FilterLocalAdsEvent {
  const FilterLocalAdsApplied({
    required this.searchQuery,
    required this.selectedStatus,
  });

  final String searchQuery;
  final ContentStatus selectedStatus;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedStatus,
  ];
}

/// Event to request resetting all filters to their initial state.
final class FilterLocalAdsReset extends FilterLocalAdsEvent {
  const FilterLocalAdsReset();
}
