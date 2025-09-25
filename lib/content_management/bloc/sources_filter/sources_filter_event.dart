part of 'sources_filter_bloc.dart';

sealed class SourcesFilterEvent extends Equatable {
  const SourcesFilterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to notify the BLoC that the search query has changed.
final class SourcesSearchQueryChanged extends SourcesFilterEvent {
  const SourcesSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to notify the BLoC that the selected content status has changed.
final class SourcesStatusFilterChanged extends SourcesFilterEvent {
  const SourcesStatusFilterChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to notify the BLoC that the selected source types have changed.
final class SourcesSourceTypeFilterChanged extends SourcesFilterEvent {
  const SourcesSourceTypeFilterChanged(this.sourceTypes);

  final List<SourceType> sourceTypes;

  @override
  List<Object?> get props => [sourceTypes];
}

/// Event to notify the BLoC that the selected language codes have changed.
final class SourcesLanguageFilterChanged extends SourcesFilterEvent {
  const SourcesLanguageFilterChanged(this.languageCodes);

  final List<String> languageCodes;

  @override
  List<Object?> get props => [languageCodes];
}

/// Event to notify the BLoC that the selected headquarters country IDs have changed.
final class SourcesHeadquartersFilterChanged extends SourcesFilterEvent {
  const SourcesHeadquartersFilterChanged(this.countryIds);

  final List<String> countryIds;

  @override
  List<Object?> get props => [countryIds];
}

/// Event to request applying all current filters.
final class SourcesFilterApplied extends SourcesFilterEvent {
  const SourcesFilterApplied({
    required this.searchQuery,
    required this.selectedStatus,
    required this.selectedSourceTypes,
    required this.selectedLanguageCodes,
    required this.selectedHeadquartersCountryIds,
  });

  final String searchQuery;
  final ContentStatus selectedStatus;
  final List<SourceType> selectedSourceTypes;
  final List<String> selectedLanguageCodes;
  final List<String> selectedHeadquartersCountryIds;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedStatus,
    selectedSourceTypes,
    selectedLanguageCodes,
    selectedHeadquartersCountryIds,
  ];
}

/// Event to request resetting all filters to their initial state.
final class SourcesFilterReset extends SourcesFilterEvent {
  const SourcesFilterReset();
}
