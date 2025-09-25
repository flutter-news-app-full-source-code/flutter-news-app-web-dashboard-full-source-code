part of 'filter_dialog_bloc.dart';

/// Base class for all events related to the [FilterDialogBloc].
sealed class FilterDialogEvent extends Equatable {
  const FilterDialogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the filter dialog's state from the current filter BLoCs.
final class FilterDialogInitialized extends FilterDialogEvent {
  const FilterDialogInitialized({
    required this.activeTab,
    this.headlinesFilterState,
    this.topicsFilterState,
    this.sourcesFilterState,
  });

  final ContentManagementTab activeTab;
  final HeadlinesFilterState? headlinesFilterState;
  final TopicsFilterState? topicsFilterState;
  final SourcesFilterState? sourcesFilterState;

  @override
  List<Object?> get props => [
    activeTab,
    headlinesFilterState,
    topicsFilterState,
    sourcesFilterState,
  ];
}

/// Event to load filter options (e.g., sources, topics, countries, languages).
final class FilterOptionsLoadRequested extends FilterDialogEvent {
  const FilterOptionsLoadRequested();
}

/// Event to update the temporary search query.
final class FilterDialogSearchQueryChanged extends FilterDialogEvent {
  const FilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to update the temporary selected content status.
final class FilterDialogStatusChanged extends FilterDialogEvent {
  const FilterDialogStatusChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to update the temporary selected source IDs for headlines.
final class FilterDialogHeadlinesSourceIdsChanged extends FilterDialogEvent {
  const FilterDialogHeadlinesSourceIdsChanged(this.sourceIds);

  final List<String> sourceIds;

  @override
  List<Object?> get props => [sourceIds];
}

/// Event to update the temporary selected topic IDs for headlines.
final class FilterDialogHeadlinesTopicIdsChanged extends FilterDialogEvent {
  const FilterDialogHeadlinesTopicIdsChanged(this.topicIds);

  final List<String> topicIds;

  @override
  List<Object?> get props => [topicIds];
}

/// Event to update the temporary selected country IDs for headlines.
final class FilterDialogHeadlinesCountryIdsChanged extends FilterDialogEvent {
  const FilterDialogHeadlinesCountryIdsChanged(this.countryIds);

  final List<String> countryIds;

  @override
  List<Object?> get props => [countryIds];
}

/// Event to update the temporary selected source types for sources.
final class FilterDialogSourceTypesChanged extends FilterDialogEvent {
  const FilterDialogSourceTypesChanged(this.sourceTypes);

  final List<SourceType> sourceTypes;

  @override
  List<Object?> get props => [sourceTypes];
}

/// Event to update the temporary selected language codes for sources.
final class FilterDialogLanguageCodesChanged extends FilterDialogEvent {
  const FilterDialogLanguageCodesChanged(this.languageCodes);

  final List<String> languageCodes;

  @override
  List<Object?> get props => [languageCodes];
}

/// Event to update the temporary selected headquarters country IDs for sources.
final class FilterDialogHeadquartersCountryIdsChanged
    extends FilterDialogEvent {
  const FilterDialogHeadquartersCountryIdsChanged(this.countryIds);

  final List<String> countryIds;

  @override
  List<Object?> get props => [countryIds];
}
