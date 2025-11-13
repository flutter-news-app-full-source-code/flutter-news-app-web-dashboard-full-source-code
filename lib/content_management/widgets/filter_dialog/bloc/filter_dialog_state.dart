part of 'filter_dialog_bloc.dart';

/// Represents the status of the filter dialog's operations.
enum FilterDialogStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template filter_dialog_state}
/// The state for the [FilterDialogBloc].
/// {@endtemplate}
final class FilterDialogState extends Equatable {
  /// {@macro filter_dialog_state}
  const FilterDialogState({
    required this.activeTab,
    this.status = FilterDialogStatus.initial,
    this.filterOptionsStatus = FilterDialogStatus.initial,
    this.exception,
    this.searchQuery = '',
    this.selectedStatus = ContentStatus.active,
    this.selectedSourceIds = const [],
    this.selectedTopicIds = const [],
    this.selectedCountryIds = const [],
    this.isBreaking = BreakingNewsFilterStatus.all,
    this.selectedSourceTypes = const [],
    this.selectedLanguageCodes = const [],
    this.selectedHeadquartersCountryIds = const [],
    this.availableSources = const [],
    this.availableTopics = const [],
    this.availableCountries = const [],
    this.availableLanguages = const [],
  });

  /// The current status of the filter dialog's main operations.
  final FilterDialogStatus status;

  /// The status of loading filter options (e.g., sources, topics).
  final FilterDialogStatus filterOptionsStatus;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The currently active content management tab.
  final ContentManagementTab activeTab;

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  /// The list of source IDs to be included in the filter for headlines.
  final List<String> selectedSourceIds;

  /// The list of topic IDs to be included in the filter for headlines.
  final List<String> selectedTopicIds;

  /// The list of country IDs to be included in the filter for headlines.
  final List<String> selectedCountryIds;

  /// The breaking news status to filter by for headlines.
  /// `null` = all, `true` = breaking only, `false` = non-breaking only.
  final BreakingNewsFilterStatus isBreaking;

  /// The list of source types to be included in the filter for sources.
  final List<SourceType> selectedSourceTypes;

  /// The list of language codes to be included in the filter for sources.
  final List<String> selectedLanguageCodes;

  /// The list of headquarters country IDs to be included in the filter for sources.
  final List<String> selectedHeadquartersCountryIds;

  /// The list of available sources for selection.
  final List<Source> availableSources;

  /// The list of available topics for selection.
  final List<Topic> availableTopics;

  /// The list of available countries for selection.
  final List<Country> availableCountries;

  /// The list of available languages for selection.
  final List<Language> availableLanguages;

  /// Creates a copy of this [FilterDialogState] with updated values.
  FilterDialogState copyWith({
    FilterDialogStatus? status,
    FilterDialogStatus? filterOptionsStatus,
    HttpException? exception,
    ContentManagementTab? activeTab,
    String? searchQuery,
    ContentStatus? selectedStatus,
    List<String>? selectedSourceIds,
    List<String>? selectedTopicIds,
    List<String>? selectedCountryIds,
    BreakingNewsFilterStatus? isBreaking,
    List<SourceType>? selectedSourceTypes,
    List<String>? selectedLanguageCodes,
    List<String>? selectedHeadquartersCountryIds,
    List<Source>? availableSources,
    List<Topic>? availableTopics,
    List<Country>? availableCountries,
    List<Language>? availableLanguages,
  }) {
    return FilterDialogState(
      status: status ?? this.status,
      filterOptionsStatus: filterOptionsStatus ?? this.filterOptionsStatus,
      exception: exception,
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSourceIds: selectedSourceIds ?? this.selectedSourceIds,
      selectedTopicIds: selectedTopicIds ?? this.selectedTopicIds,
      selectedCountryIds: selectedCountryIds ?? this.selectedCountryIds,
      isBreaking: isBreaking ?? this.isBreaking,
      selectedSourceTypes: selectedSourceTypes ?? this.selectedSourceTypes,
      selectedLanguageCodes:
          selectedLanguageCodes ?? this.selectedLanguageCodes,
      selectedHeadquartersCountryIds:
          selectedHeadquartersCountryIds ?? this.selectedHeadquartersCountryIds,
      availableSources: availableSources ?? this.availableSources,
      availableTopics: availableTopics ?? this.availableTopics,
      availableCountries: availableCountries ?? this.availableCountries,
      availableLanguages: availableLanguages ?? this.availableLanguages,
    );
  }

  @override
  List<Object?> get props => [
    status,
    filterOptionsStatus,
    exception,
    activeTab,
    searchQuery,
    selectedStatus,
    selectedSourceIds,
    selectedTopicIds,
    selectedCountryIds,
    isBreaking,
    selectedSourceTypes,
    selectedLanguageCodes,
    selectedHeadquartersCountryIds,
    availableSources,
    availableTopics,
    availableCountries,
    availableLanguages,
  ];
}
